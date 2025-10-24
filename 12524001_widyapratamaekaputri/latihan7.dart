import 'dart:async';

Future<void> main() async {
  print("🎤 Karaoke: Rizky Febian & Adrian Khalif - Alamak 🎶");
  print("------------------------------------------");

  // Bagian awal
  await tampilkanLirik("Ulah siapa yang bisa buat ku begini", 2);
  await tampilkanLirik("Gila, ini bahagia apa menderita", 2);
  await tampilkanLirik("Langit lagi bagus-bagusnya", 2);
  await tampilkanLirik("Tapi bagiku biasa saja", 2);
  await tampilkanLirik("Dia buatku terkesima", 3);

  // Pre-chorus
  await tampilkanLirik("Menyapamu tak berani, mencium mu apalagi", 2);
  await tampilkanLirik("Mata, pundak, lutut kaki, gemetar ku berdiri", 2);
  await tampilkanLirik("Kalau sampai ku miliki", 2);
  await tampilkanLirik("Tak mau ku tidur lagi", 2);
  await tampilkanLirik("Alamat malah nanti kau pergi", 3);

  // Reff
  await tampilkanLirik("Kalau ada sembilan nyawa", 2);
  await tampilkanLirik("Mau samamu saja semuanya", 2);
  await tampilkanLirik("Ini dada, isinya kamu semua", 2);
  await tampilkanLirik("Alamak... inikah jatuh cinta?", 3);

  print("------------------------------------------");
  print("🎶 Selesai! Terima kasih sudah karaoke! 🎤");
}

// Fungsi asynchronous untuk menampilkan lirik dengan delay
Future<void> tampilkanLirik(String lirik, int detik) async {
  print(lirik);
  await Future.delayed(Duration(seconds: detik));
}