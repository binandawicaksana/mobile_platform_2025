import 'dart:io';

void main() {
  stdout.write("Masukkan Tanggal (1-31): ");
  var tanggalInput = stdin.readLineSync();

  stdout.write("Masukkan Bulan (1-12): ");
  var bulanInput = stdin.readLineSync();

  stdout.write("Masukkan Tahun (1000-2999): ");
  var tahunInput = stdin.readLineSync();

  // Cek apakah input berupa angka
  int? tanggal = int.tryParse(tanggalInput ?? "");
  int? bulan = int.tryParse(bulanInput ?? "");
  int? tahun = int.tryParse(tahunInput ?? "");

  if (tanggal == null || bulan == null || tahun == null) {
    print("Anda Salah Memasukkan format Angka");
  } else {
    if (tanggal >= 1 && tanggal <= 31) {
      if (bulan >= 1 && bulan <= 12) {
        if (tahun >= 1000 && tahun <= 2999) {
          print("$tanggal-$bulan-$tahun"); // output benar
        } else {
          print("Anda Salah Memasukkan Tahun");
        }
      } else {
        print("Anda Salah Memasukkan Bulan");
      }
    } else {
      print("Anda Salah Memasukkan Tanggal");
    }
  }
}