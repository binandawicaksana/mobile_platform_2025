import 'dart:io';

void main() {
  stdout.write("Masukkan Tanggal (1-31): ");
  String? inputTanggal = stdin.readLineSync();

  if (inputTanggal == null || int.tryParse(inputTanggal) == null) {
    print("Hanya menerima format Angka");
    return;
  } else {
    int tanggal = int.parse(inputTanggal);
    if (tanggal < 1 || tanggal > 31) {
      print("Anda Salah Memasukan Tanggal");
      return;
    }
  }

  stdout.write("Masukkan Bulan (1-12): ");
  String? inputBulan = stdin.readLineSync();

  if (inputBulan == null || int.tryParse(inputBulan) == null) {
    print("Hanya menerima format Angka");
    return;
  } else {
    int bulan = int.parse(inputBulan);
    if (bulan < 1 || bulan > 12) {
      print("Anda Salah Memasukan Bulan");
      return;
    }
  }

  stdout.write("Masukkan Tahun (1000-2999): ");
  String? inputTahun = stdin.readLineSync();

  if (inputTahun == null || int.tryParse(inputTahun) == null) {
    print("Hanya menerima format Angka");
    return;
  } else {
    int tahun = int.parse(inputTahun);
    if (tahun < 1000 || tahun > 2999) {
      print("Anda Salah Memasukan Tahun");
      return;
    } else {
      print("$inputTanggal - $inputBulan - $inputTahun");
    }
  }
}
