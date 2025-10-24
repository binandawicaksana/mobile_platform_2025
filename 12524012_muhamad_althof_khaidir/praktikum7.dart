import 'dart:async';

// Struktur untuk menyimpan lirik dan waktu jeda
class LyricLine {
  final String text;
  final Duration delay;

  LyricLine(this.text, this.delay);
}

void main() async {
  print("=== 🎤 Karaoke Mode: ON ===\n");

  // Daftar lirik dan jeda waktu antar baris
  final lyrics = [
    LyricLine("...", Duration(seconds: 4)),
    LyricLine("Humingang malalim, pumikit na muna", Duration(seconds: 5)),
    LyricLine("At baka-sakaling namamalikmata lang", Duration(seconds: 5)),
    LyricLine("Ba't nababahala? 'Di ba't ako'y mag-isa?", Duration(seconds: 5)),
    LyricLine("'Kala ko'y payapa, boses mo'y tumatawag pa", Duration(seconds: 5)),
    LyricLine("...", Duration(seconds: 2)),
    LyricLine("Binaon naman na ang lahat", Duration(seconds: 2)),
    LyricLine("Tinakpan naman na 'king sugat", Duration(seconds: 3)),
    LyricLine("Ngunit ba't ba andito pa rin?", Duration(seconds: 3)),
    LyricLine("Hirap na 'kong intindihin", Duration(seconds: 4)),
    LyricLine("...", Duration(seconds: 4)),
    LyricLine("Tanging panalangin, lubayan na sana", Duration(seconds: 10)),
    LyricLine("Dahil sa bawat tingin, mukha mo'y nakikita", Duration(seconds: 9)),
    LyricLine("Kahit sa'n man mapunta ay anino mo'y kumakapit sa 'king kamay", Duration(seconds: 8)),
    LyricLine("Ako ay dahan-dahang nililibing nang buhay pa", Duration(seconds: 4)),
    LyricLine("...", Duration(seconds: 5)),
  ];

  // Tampilkan tiap baris dengan delay sesuai
  for (var line in lyrics) {
    await Future.delayed(line.delay);
    print(line.text);
  }

  print("\n=== 🎶 Lagu Selesai ===");
}