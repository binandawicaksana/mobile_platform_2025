import 'dart:io';

void main() {
  // Input nama depan
  stdout.write('Masukkan nama depan: ');
  String? namaDepan = stdin.readLineSync();

  // Input nama belakang
  stdout.write('Masukkan nama belakang: ');
  String? namaBelakang = stdin.readLineSync();

  // Input nilai a
  stdout.write('Masukkan nilai a: ');
  int a = int.parse(stdin.readLineSync()!);

  // Input nilai b
  stdout.write('Masukkan nilai b: ');
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