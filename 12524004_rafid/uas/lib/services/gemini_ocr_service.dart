import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ReceiptScanResult {
  const ReceiptScanResult({
    required this.title,
    required this.amount,
    required this.category,
    required this.confidence,
    required this.rawResponse,
    this.notes,
  });

  final String title;
  final double amount;
  final String category;
  final double confidence;
  final String rawResponse;
  final String? notes;

  bool get hasData => title.isNotEmpty && amount > 0;

  ReceiptScanResult copyWith({
    String? title,
    double? amount,
    String? category,
    double? confidence,
    String? rawResponse,
    String? notes,
  }) {
    return ReceiptScanResult(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      confidence: confidence ?? this.confidence,
      rawResponse: rawResponse ?? this.rawResponse,
      notes: notes ?? this.notes,
    );
  }

  static ReceiptScanResult empty() => const ReceiptScanResult(
        title: '',
        amount: 0,
        category: '',
        confidence: 0,
        rawResponse: '',
      );
}

class GeminiOcrService {
  GeminiOcrService({String? apiKey, GenerativeModel? model, String? modelName})
      : _apiKey = apiKey ??
            dotenv.env['GEMINI_API_KEY'] ??
            const String.fromEnvironment('GEMINI_API_KEY'),
        _model = model,
        _modelName = modelName ??
            dotenv.env['GEMINI_MODEL'] ??
            const String.fromEnvironment(
              'GEMINI_MODEL',
              defaultValue: 'gemini-1.5-flash-latest',
            );

  final String _apiKey;
  final GenerativeModel? _model;
  final String _modelName;

  bool get isConfigured => _apiKey.isNotEmpty || _model != null;

  GenerativeModel get _resolvedModel =>
      _model ?? GenerativeModel(model: _modelName, apiKey: _apiKey);

  Future<ReceiptScanResult> analyzeReceipt({
    String? imageBase64,
    String? plainText,
  }) async {
    if (!isConfigured) {
      return ReceiptScanResult(
        title: 'Contoh Kopi',
        amount: 25000,
        category: 'Minuman',
        confidence: 0.4,
        rawResponse: 'Service not configured, returning example data.',
        notes: 'Tambahkan GEMINI_API_KEY untuk memakai hasil nyata.',
      );
    }

    final prompt = '''
Anda adalah sistem OCR struk yang harus mengembalikan JSON dengan format:
{"title": "...", "amount": 0, "category": "...", "notes": "...", "confidence": 0-1}
Gunakan bahasa Indonesia. Jika nilai tidak ada, isi string kosong dan confidence 0.2.
Kategori yang valid hanya boleh salah satu dari:
- Belanja (segala pembelian non-tagihan, groceries, hadiah, dll)
- Makan & Minum (restoran, kafe, makanan/minuman)
- Transportasi (bensin, parkir, ojol, tiket transport)
- Tagihan Bulanan (listrik, internet, langganan rutin)
- Lain-lain (selain kategori di atas)

Pastikan memilih kategori terdekat dari daftar di atas.

Data struk:
${plainText ?? ''}
''';

    final contents = <Content>[];

    if (imageBase64 != null) {
      try {
        final imageBytes = base64Decode(imageBase64);
        contents.add(Content.multi([
          TextPart(prompt),
          DataPart('image/png', imageBytes),
        ]));
      } catch (_) {
        contents.add(Content.text('$prompt\n[Gagal memproses gambar, hanya teks]'));
      }
    }

    if (contents.isEmpty) {
      contents.add(Content.text(prompt));
    }

    final response = await _resolvedModel.generateContent(contents);
    final textResponse = _extractResponseText(response);
    try {
      final normalized = _sanitizeJson(textResponse);
      final decoded = jsonDecode(normalized);
      final map = _extractFirstMap(decoded);
      if (map == null) {
        throw const FormatException('Unexpected JSON structure');
      }
      return _mapToResult(map, textResponse);
    } catch (_) {
      return ReceiptScanResult(
        title: '',
        amount: 0,
        category: '',
        confidence: 0.2,
        rawResponse: textResponse,
        notes: 'Format respons tidak dikenali',
      );
    }
  }

  ReceiptScanResult _mapToResult(
    Map<dynamic, dynamic> map,
    String rawResponse,
  ) {
    final rawCategory = (map['category']?.toString() ?? '').trim();
    return ReceiptScanResult(
      title: (map['title']?.toString() ?? '').trim(),
      amount: _tryParseDouble(map['amount']),
      category: _normalizeCategory(rawCategory),
      notes: map['notes'] == null ? null : map['notes'].toString().trim(),
      confidence: _tryParseDouble(map['confidence'], fallback: 0.3),
      rawResponse: rawResponse,
    );
  }

  double _tryParseDouble(Object? value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    return fallback;
  }

  String _sanitizeJson(String raw) => raw
      .replaceAll('```json', '')
      .replaceAll('```', '')
      .replaceAll('\u0000', '')
      .trim();

  Map<dynamic, dynamic>? _extractFirstMap(dynamic decoded) {
    if (decoded is Map) {
      return decoded;
    }
    if (decoded is List) {
      for (final item in decoded) {
        if (item is Map) return item;
      }
    }
    return null;
  }

  String _extractResponseText(GenerateContentResponse response) {
    final buffer = StringBuffer();
    for (final candidate in response.candidates) {
      for (final part in candidate.content.parts) {
        if (part is TextPart) {
          buffer.writeln(part.text);
        }
      }
      if (buffer.isNotEmpty) {
        break;
      }
    }
    if (buffer.isEmpty) {
      return response.text ?? '';
    }
    return buffer.toString().trim();
  }

  String _normalizeCategory(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('makan') || lower.contains('minum') || lower.contains('food')) {
      return 'Makan & Minum';
    }
    if (lower.contains('transport') ||
        lower.contains('bensin') ||
        lower.contains('parkir') ||
        lower.contains('ojek') ||
        lower.contains('taksi')) {
      return 'Transportasi';
    }
    if (lower.contains('tagihan') ||
        lower.contains('bill') ||
        lower.contains('langganan') ||
        lower.contains('listrik') ||
        lower.contains('internet')) {
      return 'Tagihan Bulanan';
    }
    if (lower.contains('belanja') ||
        lower.contains('shopping') ||
        lower.contains('grocer') ||
        lower.contains('hadiah') ||
        lower.contains('fashion')) {
      return 'Belanja';
    }
    return 'Lain-lain';
  }
}
