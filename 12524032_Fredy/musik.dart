import 'dart:async';

// Fungsi synchronous — hanya menampilkan judul
void tampilkanJudul() {
  print("Lagu: Kisinan 2 - Masddho");
  print("---------------------------------");
}

// Fungsi asynchronous untuk menampilkan lirik dengan delay
Future<void> tampilkanLirik() async {
  // Daftar lirik
  List<String> lirik = [
    "Bola Bali nggo dolanan",
    "Bola Bali wes kapusan",
    "Janji manis naliko",
    "Awal pacaran",
    "Dadi badut tak lakoni",
    "Dadi payung wes ngalami",
    "Kadung elos ora mikir",
    "Cinta tak pasrahke Gusti"
  ];

  try {
    // Loop setiap baris lirik dengan jeda
    for (String baris in lirik) {
      await Future.delayed(Duration(seconds: 4), () {
        print(baris);
      });
    }

    // Setelah semua lirik selesai
    print("\nKaraoke selesai!");

  } catch (e) {
    // Penanganan error
    print("Terjadi kesalahan saat memutar lirik: $e");
  }
}

// Fungsi utama
Future<void> main() async {
  tampilkanJudul();

  print("Menyiapkan lagu...\n");

  // Simulasi loading sebelum mulai
  await Future.delayed(Duration(seconds: 3));
  print("Lagu siap diputar! 🎧\n");

  await tampilkanLirik();
}
