import 'dart:io';

void main() {
  stdout.write("Masukkan Tanggal (1-31): ");
  var tanggalInput = stdin.readLineSync();

  stdout.write("Masukkan Bulan (1-12): ");
  var bulanInput = stdin.readLineSync();

  stdout.write("Masukkan Tahun (1000-2999): ");
  var tahunInput = stdin.readLineSync();

  var tanggal = int.tryParse(tanggalInput ?? "");
  var bulan = int.tryParse(bulanInput ?? "");
  var tahun = int.tryParse(tahunInput ?? "");

  if (tanggal == null || bulan == null || tahun == null) {
    print("Anda Salah Memasukkan format Angka");
    return;
  }

  bool adaError = false;

  if (tanggal < 1 || tanggal > 31) {
    print("Anda Salah Memasukkan Tanggal");
    adaError = true;
  }
  if (bulan < 1 || bulan > 12) {
    print("Anda Salah Memasukkan Bulan");
    adaError = true;
  }
  if (tahun < 1000 || tahun > 2999) {
    print("Anda Salah Memasukkan Tahun");
    adaError = true;
  }

  if (!adaError) {
    print("$tanggal-$bulan-$tahun");
  }
}