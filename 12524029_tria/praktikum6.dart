import 'dart:async';

class Line {
  final Duration time;
  final String text;
  const Line(this.time, this.text);
}

Future<void> main() async {
  print("=== Karaoke Async: Lagu (Versi Lengkap) ===");
  print("Mulai dalam 2 detik...\n");
  await Future.delayed(const Duration(seconds: 2));

  final lyrics = <Line>[
    Line(const Duration(seconds: 0),  "Hai, masihkah"),
    Line(const Duration(seconds: 3),  "Luka itu ada di sana?"),
    Line(const Duration(seconds: 7),  "Yang kutinggalkan"),
    Line(const Duration(seconds: 10), "Saat kita masih bersama"),
    Line(const Duration(seconds: 14), "Kini waktu terasa berbeda"),
    Line(const Duration(seconds: 18), "Tanpa hadirmu"),
    Line(const Duration(seconds: 21), "Keras hati yang dulu bicara"),
    Line(const Duration(seconds: 25), "Berujung pilu"),
    Line(const Duration(seconds: 29), "Andai angin mengulang sebuah masa yang telah usang"),
    Line(const Duration(seconds: 34), "'Kan kutelan isi bumi hanya untukmu"),
    Line(const Duration(seconds: 38), "Terima bunga maafku, layu termakan egoku"),
    Line(const Duration(seconds: 43), "Meski ku tahu tak bisa"),
    Line(const Duration(seconds: 47), "Oh, mungkinkah"),
    Line(const Duration(seconds: 50), "Ada rindu di balik benci itu?"),
    Line(const Duration(seconds: 54), "Yang perlahan menghilang"),
    Line(const Duration(seconds: 58), "Saat nyamanku tak lagi kau butuh"),
    Line(const Duration(seconds: 62), "Kini waktu terasa berbeda"),
    Line(const Duration(seconds: 66), "Tanpa hadirmu"),
    Line(const Duration(seconds: 69), "Keras hati yang dulu bicara"),
    Line(const Duration(seconds: 73), "Berujung pilu"),
    Line(const Duration(seconds: 77), "Andai angin mengulang sebuah masa yang telah usang"),
    Line(const Duration(seconds: 82), "'Kan kutelan isi bumi hanya untukmu"),
    Line(const Duration(seconds: 87), "Terima bunga maafku, layu termakan egoku"),
    Line(const Duration(seconds: 92), "Meski ku tahu tak bisa"),
    Line(const Duration(seconds: 96), "Andai angin mengulang semua masa yang telah hilang"),
    Line(const Duration(seconds: 101), "'Kan kutelan isi bumi hanya untukmu"),
    Line(const Duration(seconds: 106), "Terima bunga maafku, layu termakan egoku"),
    Line(const Duration(seconds: 111), "Meski ku tahu (meski ku tahu)"),
    Line(const Duration(seconds: 115), "Meski ku tahu ku tak akan bisa"),
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

  print("\n=== Selesai ===");
}
