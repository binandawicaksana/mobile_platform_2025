import 'package:flutter/material.dart';
import 'theme_const.dart';
import 'bottom_nav.dart';
import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State
  String origin = 'Jakarta';
  String destination = 'Bali';
  bool isRoundTrip = false;
  int dewasa = 1;
  int anak = 0;
  String kelas = 'Ekonomi';
  DateTime tglPergi = DateTime.now().add(const Duration(days: 1));
  DateTime? tglPulang;

  String _formatDate(BuildContext context, DateTime date) {
    final loc = MaterialLocalizations.of(context);
    return loc.formatMediumDate(date);
  }

  Future<void> _pickPergi() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tglPergi,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        tglPergi = picked;
        if (isRoundTrip) {
          if (tglPulang == null || (tglPulang!.isBefore(tglPergi))) {
            tglPulang = tglPergi.add(const Duration(days: 2));
          }
        }
      });
    }
  }

  Future<void> _pickPulang() async {
    final base = tglPergi.add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: tglPulang ?? base,
      firstDate: base,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => tglPulang = picked);
    }
  }

  void _swapRoute() {
    setState(() {
      final temp = origin;
      origin = destination;
      destination = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      bottomNavigationBar: const MainBottomNav(currentIndex: 0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  SizedBox(width: 48),
                  Text(
                    'Beranda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Hi, Tria',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            const Text('Mau terbang ke mana hari ini?'),
                            const SizedBox(height: 16),

                            // Kartu form pencarian
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2FBFF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                          // Trip type
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => setState(() {
                                  isRoundTrip = false;
                                  tglPulang = null;
                                }),
                                child: isRoundTrip
                                    ? _chipUnselected('Satu Arah')
                                    : _chipSelected('Satu Arah'),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => setState(() {
                                  isRoundTrip = true;
                                  tglPulang = tglPergi.add(const Duration(days: 2));
                                }),
                                child: isRoundTrip
                                    ? _chipSelected('Pulang Pergi')
                                    : _chipUnselected('Pulang Pergi'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Tanggal pergi & pulang
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: _pickPergi,
                                  child: _dateBox(
                                    title: 'Tanggal Pergi',
                                    value: _formatDate(context, tglPergi),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: isRoundTrip
                                    ? InkWell(
                                        onTap: _pickPulang,
                                        child: _dateBox(
                                          title: 'Tanggal Pulang',
                                          value: _formatDate(
                                              context, tglPulang ?? tglPergi.add(const Duration(days: 2))),
                                        ),
                                      )
                                    : _iconBox(
                                        Icons.calendar_today,
                                        onTap: () async {
                                          setState(() => isRoundTrip = true);
                                          await _pickPulang();
                                        },
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Rute + tukar
                          Row(
                            children: [
                              Expanded(
                                child: _routeBox(
                                  'Awal',
                                  origin,
                                  Alignment.centerLeft,
                                  onTap: () async {
                                    final picked = await _pickCity(title: 'Pilih Kota Awal');
                                    if (picked != null) {
                                      setState(() => origin = picked);
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: _swapRoute,
                                icon: const Icon(Icons.swap_horiz),
                                tooltip: 'Tukar rute',
                              ),
                              Expanded(
                                child: _routeBox(
                                  'Tujuan',
                                  destination,
                                  Alignment.centerRight,
                                  onTap: () async {
                                    final picked = await _pickCity(title: 'Pilih Kota Tujuan');
                                    if (picked != null) {
                                      setState(() => destination = picked);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Penumpang & Kelas (responsif)
                          LayoutBuilder(
                            builder: (context, c) {
                              final isNarrow = c.maxWidth < 360;
                              if (isNarrow) {
                                return Column(
                                  children: [
                                    _passengerBox(
                                      dewasa: dewasa,
                                      anak: anak,
                                      onMinusAdult: () => setState(() => dewasa = (dewasa > 1) ? dewasa - 1 : 1),
                                      onPlusAdult: () => setState(() => dewasa++),
                                      onMinusChild: () => setState(() => anak = (anak > 0) ? anak - 1 : 0),
                                      onPlusChild: () => setState(() => anak++),
                                    ),
                                    const SizedBox(height: 12),
                                    _classSelector(),
                                  ],
                                );
                              }
                              return Row(
                                children: [
                                  Expanded(
                                    child: _passengerBox(
                                      dewasa: dewasa,
                                      anak: anak,
                                      onMinusAdult: () => setState(() => dewasa = (dewasa > 1) ? dewasa - 1 : 1),
                                      onPlusAdult: () => setState(() => dewasa++),
                                      onMinusChild: () => setState(() => anak = (anak > 0) ? anak - 1 : 0),
                                      onPlusChild: () => setState(() => anak++),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _ClassSelectorBox(
                                      kelas: kelas,
                                      onEkonomi: () => setState(() => kelas = 'Ekonomi'),
                                      onBisnis: () => setState(() => kelas = 'Bisnis'),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const DashboardPenerbanganScreen()),
                                  );
                                },
                                child: const Text('Cari Penerbangan',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widgets kecil utilitas
  Widget _chipSelected(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      );

  Widget _chipUnselected(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(color: kPrimaryColor)),
      );

  Widget _dateBox({required String title, required String value}) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _iconBox(IconData icon, {VoidCallback? onTap}) => InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Icon(icon, size: 20)),
        ),
      );

  Widget _routeBox(String label, String city, Alignment align, {VoidCallback? onTap}) =>
      InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment:
                align == Alignment.centerLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(city, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );

  Future<String?> _pickCity({required String title}) async {
    final allCities = <String>[
      'Jakarta', 'Bali', 'Surabaya', 'Bandung', 'Yogyakarta', 'Medan',
      'Semarang', 'Makassar', 'Palembang', 'Balikpapan', 'Padang', 'Malang',
      'Solo', 'Banjarmasin', 'Pontianak', 'Batam', 'Kupang', 'Manado',
    ];

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        String query = '';

        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final filtered = allCities
                .where((c) => c.toLowerCase().contains(query.toLowerCase()))
                .toList();
            final viewInsets = MediaQuery.of(ctx).viewInsets;
            return Padding(
              padding: EdgeInsets.only(bottom: viewInsets.bottom),
              child: SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.7,
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari kota...',
                            prefixIcon: const Icon(Icons.search),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (val) => setModalState(() => query = val),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(child: Text('Tidak ada hasil'))
                            : ListView.separated(
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (_, idx) {
                                  final c = filtered[idx];
                                  return ListTile(
                                    title: Text(c),
                                    onTap: () => Navigator.pop(ctx, c),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _passengerBox({
    required int dewasa,
    required int anak,
    required VoidCallback onMinusAdult,
    required VoidCallback onPlusAdult,
    required VoidCallback onMinusChild,
    required VoidCallback onPlusChild,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Penumpang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dewasa'),
              Row(children: [
                IconButton(onPressed: onMinusAdult, icon: const Icon(Icons.remove), iconSize: 18),
                Text('$dewasa', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(onPressed: onPlusAdult, icon: const Icon(Icons.add), iconSize: 18),
              ]),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Anak'),
              Row(children: [
                IconButton(onPressed: onMinusChild, icon: const Icon(Icons.remove), iconSize: 18),
                Text('$anak', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(onPressed: onPlusChild, icon: const Icon(Icons.add), iconSize: 18),
              ]),
            ],
          ),
          const SizedBox(height: 6),
          Text('$dewasa Dewasa, $anak Anak',
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  // Kelas penerbangan: Ekonomi / Bisnis (responsif, wrap)
  Widget _classSelector() => _ClassSelectorBox(
        kelas: kelas,
        onEkonomi: () => setState(() => kelas = 'Ekonomi'),
        onBisnis: () => setState(() => kelas = 'Bisnis'),
      );
}

class _ClassSelectorBox extends StatelessWidget {
  final String kelas;
  final VoidCallback onEkonomi;
  final VoidCallback onBisnis;
  const _ClassSelectorBox({
    super.key,
    required this.kelas,
    required this.onEkonomi,
    required this.onBisnis,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 8,
        runSpacing: 8,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onEkonomi,
            child: kelas == 'Ekonomi'
                ? (context.findAncestorStateOfType<_HomeScreenState>()?._chipSelected('Ekonomi') ?? const SizedBox())
                : (context.findAncestorStateOfType<_HomeScreenState>()?._chipUnselected('Ekonomi') ?? const SizedBox()),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onBisnis,
            child: kelas == 'Bisnis'
                ? (context.findAncestorStateOfType<_HomeScreenState>()?._chipSelected('Bisnis') ?? const SizedBox())
                : (context.findAncestorStateOfType<_HomeScreenState>()?._chipUnselected('Bisnis') ?? const SizedBox()),
          ),
        ],
      ),
    );
  }
}
