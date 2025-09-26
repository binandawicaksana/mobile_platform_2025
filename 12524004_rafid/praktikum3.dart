import 'dart:io';

void main() {
  stdout.write("Masukkan tanggal: ");
  var tgl = int.tryParse(stdin.readLineSync()!);

  stdout.write("Masukkan bulan: ");
  var bln = int.tryParse(stdin.readLineSync()!);

  stdout.write("Masukkan tahun: ");
  var thn = int.tryParse(stdin.readLineSync()!);

  if (tgl == null || bln == null || thn == null) {
    print("Hanya menerima format angka!");
    return;
  }

  bool tglValid = tgl >= 1 && tgl <= 31;
  bool blnValid = bln >= 1 && bln <= 12;
  bool thnValid = thn >= 1000 && thn <= 2999;

  if (!tglValid && !blnValid && !thnValid) {
    print("Salah semua cuy!");
  } else if (tglValid && blnValid && thnValid) {
    print("Tanggal : $tgl-$bln-$thn");
  }
}
