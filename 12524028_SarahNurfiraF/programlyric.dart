import 'dart:async';

class Line {
  final Duration time;
  final String text;
  const Line(this.time, this.text);
}

Future<void> main() async {
  print("=== Karaoke Async: Nadin Amizah (Rayuan Perempuan Gila) ===");
  print("Mulai dalam 2 detik...\n");
  await Future.delayed(const Duration(seconds: 2));


  final lyrics = <Line>[
    Line(const Duration(seconds: 0),  "Menurutmu, apa benar saat ini kau masih mencintaiku?"),
    Line(const Duration(seconds: 5),  "Menurutmu, apa yang bisa dicinta dari diriku?"),
    Line(const Duration(seconds: 10), "Bukan apa, hanya bersiap, tak ada yang tahu, aku takut"),
    Line(const Duration(seconds: 15), "Tak pernah ada yang lama menungguku sejak dulu"),
    Line(const Duration(seconds: 20), "Yang terjadi sebelumnya"),
    Line(const Duration(seconds: 23), "Semua orang takut padaku, wo-oh-oh"),
    Line(const Duration(seconds: 27), "Panggil aku"),
    Line(const Duration(seconds: 29), "Perempuan gila"),
    Line(const Duration(seconds: 32), "Hantu berkepala"),
    Line(const Duration(seconds: 35), "Keji membunuh kasihnya"),
  ];

  final start = DateTime.now();
  for (final line in lyrics) {
    final elapsed = DateTime.now().difference(start);
    final remain = line.time - elapsed;
    if (remain > Duration.zero) {
      await Future.delayed(remain); 
    }
    print("♪ ${line.text}");
  }

  print("\n=== Selesai guyssssssss🎶 ===");
}