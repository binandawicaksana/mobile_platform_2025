import 'dart:io';

void main() {
  stdout.write("Masukkan tanggal: ");
  var tgl = int.tryParse(stdin.readLineSync()!);

  stdout.write("Masukkan bulan: ");
  var bln = int.tryParse(stdin.readLineSync()!);

  stdout.write("Masukkan tahun: ");
  var thn = int.tryParse(stdin.readLineSync()!);

  if (tgl == null || bln == null || thn == null) {
    print("Hanya menerima format Angka");
  } else if (tgl < 1 || tgl > 31) {
    print("Anda Salah Memasukan Tanggal");
  } else if (bln < 1 || bln > 12) {
    print("Anda Salah Memasukan Bulan");
  } else if (thn < 1000 || thn > 2999) {
    print("Anda Salah Memasukan Tahun");
  } else {
    print("$tgl-$bln-$thn");
  }
}