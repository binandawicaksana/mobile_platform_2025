import 'dart:io';

void main() {
  stdout.write("Masukkan tanggal (1-31): ");
  var inputTanggal = stdin.readLineSync();
  stdout.write("Masukkan bulan (1-12): ");
  var inputBulan = stdin.readLineSync();
  stdout.write("Masukkan tahun (1000-2999): ");
  var inputTahun = stdin.readLineSync();

  if (int.tryParse(inputTanggal!) == null ||
      int.tryParse(inputBulan!) == null ||
      int.tryParse(inputTahun!) == null) {
    print("hanya menerima angka");
    return;
  }

  var tanggal = int.parse(inputTanggal);
  var bulan = int.parse(inputBulan);
  var tahun = int.parse(inputTahun);

  void cekTanggal(int tgl) {
    if (tgl < 1 || tgl > 31) {
      print("Anda Salah Memasukan Tanggal");
    }
  }

  void cekBulan(int bln) {
    if (bln < 1 || bln > 12) {
      print("Anda Salah Memasukan Bulan");
    }
  }

  void cekTahun(int thn) {
    if (thn < 1000 || thn > 2999) {
      print("Anda Salah Memasukan Tahun");
    }
  }

  cekTanggal(tanggal);
  cekBulan(bulan);
  cekTahun(tahun);

  if (tanggal >= 1 &&
      tanggal <= 31 &&
      bulan >= 1 &&
      bulan <= 12 &&
      tahun >= 1000 &&
      tahun <= 2999) {
    print("[$tanggal] - [$bulan] - [$tahun]");
  }
}
