import 'package:flutter/material.dart';
import 'pulsa_pembayaran.dart';

class PulsaDataPage extends StatefulWidget {
  const PulsaDataPage({super.key});

  @override
  State<PulsaDataPage> createState() => _PulsaDataPageState();
}

class _PulsaDataPageState extends State<PulsaDataPage> {
  final phoneC = TextEditingController();
  String provider = "Telkomsel";
  int selectedNominal = 0;
  String tipe = 'Pulsa';
  int selectedData = -1;

  final providers = const ["Telkomsel", "Indosat", "XL", "Tri", "Smartfren"];
  final nominals = const ["5.000", "10.000", "20.000", "50.000", "100.000"];
  final dataPacks = const [
    {"label": "1 GB", "valid": "7 hari", "price": "15.000"},
    {"label": "2 GB", "valid": "7 hari", "price": "22.000"},
    {"label": "3 GB", "valid": "30 hari", "price": "35.000"},
    {"label": "5 GB", "valid": "30 hari", "price": "52.000"},
    {"label": "10 GB", "valid": "30 hari", "price": "90.000"},
    {"label": "Unlimited", "valid": "7 hari", "price": "65.000"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        title: const Text("Pulsa & Data"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nomor HP", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: phoneC,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "08xxxxxxxxxx",
                prefixIcon: const Icon(Icons.phone_iphone_outlined),
                filled: true,
                fillColor: const Color(0xFFFFFBF5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 14),
            const Text("Provider", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFBF5), Color(0xFFF4E0C8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: providers.map((p) {
                  final active = provider == p;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.network_cell, size: 16),
                        const SizedBox(width: 4),
                        Text(p),
                      ],
                    ),
                    selected: active,
                    onSelected: (_) => setState(() => provider = p),
                    selectedColor: const Color(0xFFB45F4B),
                    labelStyle: TextStyle(color: active ? Colors.white : Colors.black),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, size: 16),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Isi ulang pulsa & paket data instan ke semua operator. Pembayaran cepat dan aman.",
                      style: TextStyle(fontSize: 12.5, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            const Text("Tipe Produk", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [Icon(Icons.phone_android_outlined, size: 16), SizedBox(width: 4), Text('Pulsa')],
                    ),
                    selected: tipe == 'Pulsa',
                    onSelected: (_) => setState(() { tipe = 'Pulsa'; selectedData = -1; }),
                    selectedColor: const Color(0xFFB45F4B),
                    labelStyle: TextStyle(color: tipe == 'Pulsa' ? Colors.white : Colors.black),
                  ),
                  ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [Icon(Icons.data_saver_off_outlined, size: 16), SizedBox(width: 4), Text('Paket Data')],
                    ),
                    selected: tipe == 'Data',
                    onSelected: (_) => setState(() { tipe = 'Data'; }),
                    selectedColor: const Color(0xFFB45F4B),
                    labelStyle: TextStyle(color: tipe == 'Data' ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            if (tipe == 'Pulsa') ...[
              const Text("Pilih Nominal", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: nominals.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.2,
                ),
                itemBuilder: (_, i) {
                  final active = selectedNominal == i;
                  return GestureDetector(
                    onTap: () => setState(() => selectedNominal = i),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFFB45F4B) : const Color(0xFFFFFBF5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFB45F4B)),
                        boxShadow: active
                            ? const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))]
                            : const [],
                      ),
                      child: Text(
                        "Rp ${nominals[i]}",
                        style: TextStyle(
                          color: active ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ] else ...[
              const Text("Pilih Paket Data", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dataPacks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.0,
                ),
                itemBuilder: (_, i) {
                  final pack = dataPacks[i];
                  final active = selectedData == i;
                  return GestureDetector(
                    onTap: () => setState(() => selectedData = i),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFFB45F4B) : const Color(0xFFFFFBF5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFB45F4B)),
                        boxShadow: active
                            ? const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))]
                            : const [],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pack['label']!,
                            style: TextStyle(
                              color: active ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            pack['valid']!,
                            style: TextStyle(
                              color: active ? Colors.white70 : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "Rp ${pack['price']}",
                              style: TextStyle(
                                color: active ? Colors.white : Colors.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB45F4B),
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
                icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                label: const Text('Bayar Sekarang', style: TextStyle(fontWeight: FontWeight.w600)),
                onPressed: () {
                  if (phoneC.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mohon isi nomor terlebih dahulu.')),
                    );
                    return;
                  }

                  if (tipe == 'Pulsa') {
                    if (selectedNominal < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mohon pilih nominal pulsa.')),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PulsaPembayaranPage(
                          phoneNumber: phoneC.text,
                          provider: provider,
                          nominal: nominals[selectedNominal],
                        ),
                      ),
                    );
                  } else {
                    if (selectedData < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mohon pilih paket data.')),
                      );
                      return;
                    }
                    final pack = dataPacks[selectedData];
                    final label = "${pack['label']} • ${pack['valid']}";
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PulsaPembayaranPage(
                          phoneNumber: phoneC.text,
                          provider: provider,
                          nominal: pack['price']!,
                          paketLabel: label,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
