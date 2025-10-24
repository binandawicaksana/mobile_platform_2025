import 'dart:async';
import 'dart:io';

// Fungsi untuk menampilkan teks dengan efek karaoke (huruf per huruf)
Future<void> ketik(String teks, {int delay = 70}) async {
  for (var i = 0; i < teks.length; i++) {
    stdout.write(teks[i]);
    await Future.delayed(Duration(milliseconds: delay));
  }
  print('');
}

// Fungsi utama untuk menampilkan lirik karaoke
Future<void> tampilkanLirikKaraoke() async {
  List<String> lirik = [
    "🎵 Burning on",
    "Just like the match you strike to incinerate",
    "The lives of everyone you know",
    "And what's the worst you take",
    "From every heart you break?"
  ];

  print("\n🎤 MULAI KARAOKE 🎶");
  print("Lagu: Helena - My Chemical Romance");
  print("-------------------------------------\n");

  // tampilkan tiap baris lirik dengan jeda antar baris
  for (int i = 0; i < lirik.length; i++) {
    await ketik(lirik[i]);
    await Future.delayed(Duration(milliseconds: 2500)); // jeda antar baris
  }

  print("\n✨ Karaoke selesai! Terima kasih sudah bernyanyi 🎧");
}

// Fungsi main (asynchronous)
Future<void> main() async {
  await tampilkanLirikKaraoke();
}
