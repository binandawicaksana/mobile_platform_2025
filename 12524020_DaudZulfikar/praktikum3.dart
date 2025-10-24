import 'dart:io';

void main() {
  stdout.write("Masukkan tanggal: ");
  String? inputTanggal = stdin.readLineSync();
  stdout.write("Masukkan bulan: ");
  String? inputBulan = stdin.readLineSync();
  stdout.write("Masukkan tahun: ");
  String? inputTahun = stdin.readLineSync();

  
  int? tanggal = int.tryParse(inputTanggal ?? '');
  int? bulan = int.tryParse(inputBulan ?? '');
  int? tahun = int.tryParse(inputTahun ?? '');

  if (tanggal == null || bulan == null || tahun == null) {
    print("Hanya menerima format Angka");
    return;
  }

  
  if (tanggal < 1 || tanggal > 31) {
    print("Anda Salah Memasukan Tanggal");
    return;
  }
  if (bulan < 1 || bulan > 12) {
    print("Anda Salah Memasukan Bulan");
    return;
  }
  if (tahun < 1000 || tahun > 2999) {
    print("Anda Salah Memasukan Tahun");
    return;
  }

  print("$tanggal - $bulan - $tahun");
}

//nama: Daud Zulfikar
//npm: 12524020
// Teknik informatika semester 3