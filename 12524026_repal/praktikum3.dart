import 'dart:io';

void main() {
  try {
    // Input tanggal
    stdout.write("Masukkan Tanggal (1-31): ");
    int tanggal = int.parse(stdin.readLineSync()!);

    // Input bulan
    stdout.write("Masukkan Bulan (1-12): ");
    int bulan = int.parse(stdin.readLineSync()!);

    // Input tahun
    stdout.write("Masukkan Tahun (1000-2999): ");
    int tahun = int.parse(stdin.readLineSync()!);

    // Validasi tanggal
    if (tanggal < 1 || tanggal > 31) {
      print("Anda Salah Memasukan Tanggal");
    }
    // Validasi bulan
    else if (bulan < 1 || bulan > 12) {
      print("Anda Salah Memasukan Bulan");
    }
    // Validasi tahun
    else if (tahun < 1000 || tahun > 2999) {
      print("Anda Salah Memasukan Tahun");
    }
    // Jika semua benar
    else {
      print("$tanggal - $bulan - $tahun");
    }
  } catch (e) {
    // Jika input bukan angka
    print("Hanya menerima format Angka");
  }
}
ru