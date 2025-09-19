import 'dart:io';

void main() {
  stdout.write('Masukkan nama depan anda: ');
  String? namaDepan = stdin.readLineSync();

  stdout.write('Masukkan nama belakang anda: ');
  String? namaBelakang = stdin.readLineSync();

  stdout.write('Masukkan nilai A: ');
  int a = int.parse(stdin.readLineSync()!);

  stdout.write('Masukkan nilai B: ');
  int b = int.parse(stdin.readLineSync()!);

  print('\nNama Lengkap: $namaDepan $namaBelakang');
  print('Hasil penjumlahan: ${a + b}');
  print('Hasil pengurangan: ${a - b}');
  print('Hasil perkalian: ${a * b}');
  if (b != 0) {
    print('Hasil pembagian: ${a / b}');
  } else {
    print('Hasil pembagian: Tidak dapat membagi dengan nol');
  }
}