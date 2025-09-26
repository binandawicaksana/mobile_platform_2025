import 'dart:io';

void main() {
  stdout.write("Masukkan Tanggal: ");
  String? inputTanggal = stdin.readLineSync();
  if (inputTanggal == null || !isNumeric(inputTanggal)) {
    print("Anda Salah Memasukan Tanggal (harus angka)");
    return;
  }
  int tanggal = int.parse(inputTanggal);
  if (tanggal < 1 || tanggal > 31) {
    print("Anda Salah Memasukan Tanggal (1-31)");
    return;
  }

  stdout.write("Masukkan Bulan: ");
  String? inputBulan = stdin.readLineSync();
  if (inputBulan == null || !isNumeric(inputBulan)) {
    print("Anda Salah Memasukan Bulan (harus angka)");
    return;
  }
  int bulan = int.parse(inputBulan);
  if (bulan < 1 || bulan > 12) {
    print("Anda Salah Memasukan Bulan (1-12)");
    return;
  }

  stdout.write("Masukkan Tahun: ");
  String? inputTahun = stdin.readLineSync();
  if (inputTahun == null || !isNumeric(inputTahun)) {
    print("Anda Salah Memasukan Tahun (harus angka)");
    return;
  }
  int tahun = int.parse(inputTahun);
  if (tahun < 1000 || tahun > 2999) {
    print("Anda Salah Memasukan Tahun (1000-2999)");
    return;
  }

  print("Tanggal Valid: $tanggal - $bulan - $tahun");
}

bool isNumeric(String str) {
  return int.tryParse(str) != null;
}
