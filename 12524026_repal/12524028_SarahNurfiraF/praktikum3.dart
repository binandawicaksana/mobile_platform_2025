import 'dart:io';

void main() {

  stdout.write("Masukkan Tanggal: ");
  String? inputTanggal = stdin.readLineSync();

  stdout.write("Masukkan Bulan: ");
  String? inputBulan = stdin.readLineSync();

  stdout.write("Masukkan Tahun: ");
  String? inputTahun = stdin.readLineSync();

  if (inputTanggal == null || inputBulan == null || inputTahun == null ||
      int.tryParse(inputTanggal) == null ||
      int.tryParse(inputBulan) == null ||
      int.tryParse(inputTahun) == null) {
    print("Hanya menerima format Angka");
    return;
  }

  int tanggal = int.parse(inputTanggal);
  int bulan = int.parse(inputBulan);
  int tahun = int.parse(inputTahun);

  if (tanggal < 1 || tanggal > 31) {
    print("Anda Salah Memasukan Tanggal");
  } else if (bulan < 1 || bulan > 12) {
    print("Anda Salah Memasukan Bulan");
  } else if (tahun < 1000 || tahun > 2999) {
    print("Anda Salah Memasukan Tahun");
  } else {
 
    print("$tanggal-$bulan-$tahun");
  }
}