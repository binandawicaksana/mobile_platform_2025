part of 'package:uas/main.dart';

class ScanBillScreen extends StatefulWidget {
  const ScanBillScreen({super.key, required this.repository});

  final ExpenseRepository repository;

  @override
  State<ScanBillScreen> createState() => _ScanBillScreenState();
}

class _ScanBillScreenState extends State<ScanBillScreen> {
  final TextEditingController _receiptController = TextEditingController();
  final GeminiOcrService _ocrService = GeminiOcrService();
  final LocalOcrService _localOcrService = LocalOcrService();
  ReceiptScanResult? _latestResult;
  bool _isScanning = false;
  bool _isLocalOcrRunning = false;
  String? _error;
  String? _selectedImageBase64;
  String? _selectedImageName;

  @override
  void dispose() {
    _receiptController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    Uint8List? bytes = file.bytes;
    if (bytes == null && file.path != null && !kIsWeb) {
      try {
        bytes = await File(file.path!).readAsBytes();
      } catch (e) {
        setState(() => _error = 'Tidak dapat membaca file gambar: $e');
        return;
      }
    }
    if (bytes == null) {
      setState(() => _error = 'Tidak dapat membaca file gambar.');
      return;
    }
    final base64 = base64Encode(bytes);
    setState(() {
      _selectedImageBase64 = base64;
      _selectedImageName = file.name;
      _error = null;
    });
  }

  void _clearImage() {
    setState(() {
      _selectedImageBase64 = null;
      _selectedImageName = null;
    });
  }

  Future<void> _runLocalOcr() async {
    final image = _selectedImageBase64;
    if (image == null) {
      debugPrint('Unggah gambar terlebih dahulu.');
      return;
    }
    setState(() {
      _isLocalOcrRunning = true;
      _error = null;
    });
    try {
      final text = await _localOcrService.extractTextFromBase64(image);
      if (text.isEmpty) {
        debugPrint('OCR lokal tidak menemukan teks.');
      } else {
        _receiptController.text = text;
        _latestResult = null;
        debugPrint('OCR lokal berhasil, hasil ditempel.');
      }
    } catch (e) {
      setState(() => _error = 'OCR lokal gagal: $e');
    } finally {
      if (mounted) {
        setState(() => _isLocalOcrRunning = false);
      }
    }
  }

  Future<void> _runScan() async {
    if (_isScanning) return;
    final text = _receiptController.text.trim();
    final hasText = text.isNotEmpty;
    final shouldSendImage = !hasText;
    if (!hasText && _selectedImageBase64 == null) {
      debugPrint('Tempel teks atau unggah gambar struk dulu.');
      return;
    }
    setState(() {
      _isScanning = true;
      _error = null;
    });
    try {
      final result = await _ocrService.analyzeReceipt(
        plainText: hasText ? text : null,
        imageBase64: shouldSendImage ? _selectedImageBase64 : null,
      );
      setState(() => _latestResult = result);
    } catch (e) {
      setState(() => _error = 'Gagal memproses struk: $e');
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _saveResult() async {
    final result = _latestResult;
    if (result == null || !result.hasData) return;
    final categoryId = _resolveCategoryId(result.category);
    if (categoryId == null) {
      debugPrint('Kategori tidak dikenali.');
      return;
    }
    final transaction = ExpenseTransaction(
      title: result.title.isNotEmpty ? result.title : 'Transaksi hasil scan',
      categoryId: categoryId,
      amount: result.amount,
      date: DateTime.now(),
    );
    try {
      await widget.repository.addTransaction(transaction);
      if (!mounted) return;
      debugPrint('Hasil scan disimpan ke transaksi.');
      setState(() => _latestResult = ReceiptScanResult.empty());
    } catch (e) {
      if (!mounted) return;
      debugPrint('Gagal menyimpan transaksi: $e');
    }
  }

  String? _resolveCategoryId(String predicted) {
    if (widget.repository.categories.isEmpty) return null;
    if (predicted.isEmpty) return widget.repository.categories.first.id;
    final lower = predicted.toLowerCase();
    for (final category in widget.repository.categories) {
      if (category.name.toLowerCase().contains(lower) ||
          lower.contains(category.name.toLowerCase()) ||
          category.shortLabel.toLowerCase() == lower) {
        return category.id;
      }
    }
    return widget.repository.categories.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final result = _latestResult;
    final isRepoReady = widget.repository.isInitialized &&
        widget.repository.categories.isNotEmpty;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(
            subtitle: 'Mode',
            title: 'Scan Bill',
            trailing: AvatarBadge(initials: 'RP'),
          ),
          const CameraActionsRow(labels: ['Import', 'Riwayat Scan']),
          const SizedBox(height: 12),
          const CameraPreview(),
          const SizedBox(height: 16),
          const CameraControls(),
          const SizedBox(height: 16),
          if (!_ocrService.isConfigured)
            const _GeminiWarningBanner(),
          const SizedBox(height: 12),
          if (!isRepoReady)
            const _RepoNotReadyBanner(),
          const SizedBox(height: 12),
          InfoCard(
            title: 'Unggah foto struk (opsional)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            _isScanning || !isRepoReady ? null : _pickImage,
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Pilih dari perangkat'),
                      ),
                    ),
                    if (_selectedImageBase64 != null) ...[
                      const SizedBox(width: 12),
                      IconButton(
                        tooltip: 'Hapus gambar',
                        onPressed:
                            _isScanning || !isRepoReady ? null : _clearImage,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ],
                ),
                if (_selectedImageBase64 != null && _selectedImageName != null)
                  _ImagePreviewCard(
                    fileName: _selectedImageName!,
                  ),
                if (_selectedImageBase64 != null && !kIsWeb)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: OutlinedButton.icon(
                      onPressed: _isLocalOcrRunning || !isRepoReady
                          ? null
                          : _runLocalOcr,
                      icon: _isLocalOcrRunning
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.text_snippet_outlined),
                      label: Text(
                        _isLocalOcrRunning
                            ? 'OCR lokal berjalan...'
                            : 'Gunakan OCR Lokal (Tesseract)',
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          InfoCard(
            title: 'Tempel teks struk',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _receiptController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText:
                        'Contoh: Kopi Panas Rp25.000, Pajak 10%, Total Rp27.500',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            _isScanning || !isRepoReady ? null : _runScan,
                        icon: _isScanning
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.auto_awesome),
                        label: Text(_isScanning ? 'Memindai...' : 'Scan dengan Gemini'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: _isScanning || !isRepoReady
                          ? null
                          : () {
                              _receiptController.clear();
                              setState(() => _latestResult = null);
                            },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          InfoCard(
            title: 'Hasil Gemini',
            child: result == null
                ? const _EmptyDashboardMessage(
                    message: 'Belum ada hasil scan. Tempel struk dan tekan Scan.',
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ResultRow(label: 'Judul', value: result.title),
                      _ResultRow(
                        label: 'Nominal',
                        value: CurrencyFormatter.formatFull(result.amount),
                      ),
                      _ResultRow(label: 'Kategori', value: result.category),
                      if (result.notes?.isNotEmpty == true)
                        _ResultRow(label: 'Catatan', value: result.notes!),
                      _ResultRow(
                        label: 'Confidence',
                        value: '${(result.confidence * 100).toStringAsFixed(0)}%',
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: result.hasData && !_isScanning && isRepoReady
                            ? _saveResult
                            : null,
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan ke Transaksi'),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: MockupColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeminiWarningBanner extends StatelessWidget {
  const _GeminiWarningBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: Colors.amber),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'GEMINI_API_KEY belum diatur. Menampilkan hasil contoh.',
              style: TextStyle(fontSize: 12, color: MockupColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePreviewCard extends StatelessWidget {
  const _ImagePreviewCard({required this.fileName});

  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MockupColors.pillBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.image_outlined, color: MockupColors.blueDark),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: MockupColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RepoNotReadyBanner extends StatelessWidget {
  const _RepoNotReadyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MockupColors.accentOrange.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.lock_clock, color: MockupColors.accentOrange),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sedang memuat data kategori. Tunggu beberapa saat sebelum memindai.',
              style: TextStyle(fontSize: 12, color: MockupColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
