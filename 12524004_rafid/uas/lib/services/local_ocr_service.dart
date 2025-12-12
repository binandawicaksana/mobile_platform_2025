import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class LocalOcrException implements Exception {
  LocalOcrException(this.message);

  final String message;

  @override
  String toString() => 'LocalOcrException: $message';
}

class LocalOcrService {
  Future<String> extractTextFromBase64(
    String base64Data, {
    String language = 'ind',
  }) async {
    if (kIsWeb) {
      throw LocalOcrException('OCR lokal tidak tersedia pada mode Web.');
    }

    final bytes = base64Decode(base64Data);
    final tempDir = await Directory.systemTemp.createTemp('ocr_local_');
    final inputFile = File('${tempDir.path}/receipt.png');
    await inputFile.writeAsBytes(bytes);

    final executable = _resolveExecutable();
    try {
      final result = await Process.run(
        executable,
        [
          inputFile.path,
          'stdout',
          '-l',
          language,
        ],
      );

      if (result.exitCode != 0) {
        throw LocalOcrException(
          result.stderr?.toString().trim().isEmpty == true
              ? 'Tesseract gagal dijalankan.'
              : result.stderr.toString(),
        );
      }

      return result.stdout.toString().trim();
    } on ProcessException catch (e) {
      throw LocalOcrException(
        'Tidak dapat menjalankan $executable. Pastikan Tesseract terpasang dan PATH sudah diset. (${e.message})',
      );
    } finally {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  }

  String _resolveExecutable() {
    if (!Platform.isWindows) return 'tesseract';
    final candidates = [
      _findExecutableInPath('tesseract.exe'),
      _findExecutableInPath('tesseract'),
      _findInDefaultLocation(),
    ];
    return candidates.firstWhere(
      (path) => path != null,
      orElse: () => 'tesseract',
    )!;
  }

  String? _findExecutableInPath(String name) {
    try {
      final result = Process.runSync(
        Platform.isWindows ? 'where' : 'which',
        [name],
      );
      if (result.exitCode == 0) {
        final path = (result.stdout as String).split('\n').first.trim();
        if (path.isNotEmpty) return path;
      }
    } catch (_) {}
    return null;
  }

  String? _findInDefaultLocation() {
    const defaultPath = r'C:\Program Files\Tesseract-OCR\tesseract.exe';
    if (File(defaultPath).existsSync()) {
      return defaultPath;
    }
    return null;
  }
}
