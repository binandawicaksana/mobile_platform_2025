import 'dart:io';

void main() {
  stdout.write("Masukkan tanggal: ");
  var tgl = int.tryParse(stdin.readLineSync()!);

  stdout.write("Masukkan bulan: ");
  var bln = int.tryParse(stdin.readLineSync()!);

  stdout.write("Masukkan tahun: ");
  var thn = int.tryParse(stdin.readLineSync()!);

  bool adaError = false;

  if (tgl == null || bln == null || thn == null) {
    print("Hanya menerima format Angka");
    adaError = true;
  }

  if (tgl != null && (tgl < 1 || tgl > 31)) {
    print("Anda Salah Memasukan Tanggal");
    adaError = true;
  }

  if (bln != null && (bln < 1 || bln > 12)) {
    print("Anda Salah Memasukan Bulan");
    adaError = true;
  }

  if (thn != null && (thn < 1000 || thn > 2999)) {
    print("Anda Salah Memasukan Tahun");
    adaError = true;
  }

  if (!adaError) {
    print("$tgl-$bln-$thn");
  }
}