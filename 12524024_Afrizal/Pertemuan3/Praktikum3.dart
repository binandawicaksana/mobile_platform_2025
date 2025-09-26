import 'dart:io';

void main() {
  print("Masukkan Tanggal: ");
  var inputTanggal = stdin.readLineSync();
  print("Masukkan Bulan: ");
  var inputBulan = stdin.readLineSync();
  print("Masukkan Tahun: ");
  var inputTahun = stdin.readLineSync();

  var tanggal = int.tryParse(inputTanggal ?? "");
  var bulan = int.tryParse(inputBulan ?? "");
  var tahun = int.tryParse(inputTahun ?? "");

  if (tanggal == null || bulan == null || tahun == null) {
    print("Hanya menerima format Angka");
  } else if ((tanggal < 1 || tanggal > 31) &&
             (bulan < 1 || bulan > 12) &&
             (tahun < 1000 || tahun > 2999)) {
    print("Anda Salah Memasukan Tanggal, Bulan, dan Tahun");
  } else if ((tanggal < 1 || tanggal > 31) &&
             (bulan < 1 || bulan > 12)) {
    print("Anda Salah Memasukan Tanggal, dan Bulan");
  } else if ((tanggal < 1 || tanggal > 31) &&
             (tahun < 1000 || tahun > 2999)) {
    print("Anda Salah Memasukan Tanggal, dan Tahun");
  } else if ((bulan < 1 || bulan > 12) &&
             (tahun < 1000 || tahun > 2999)) {
    print("Anda Salah Memasukan Bulan, dan Tahun");
  } else if (tanggal < 1 || tanggal > 31) {
    print("Anda Salah Memasukan Tanggal");
  } else if (bulan < 1 || bulan > 12) {
    print("Anda Salah Memasukan Bulan");
  } else if (tahun < 1000 || tahun > 2999) {
    print("Anda Salah Memasukan Tahun"); 
  } else {
    print("Output = $tanggal - $bulan - $tahun");
  }
}
