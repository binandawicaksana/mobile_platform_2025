import 'dart:io';

void main() {
 
  stdout.write("Masukkan Nilai A: ");
  int a = int.parse(stdin.readLineSync()!);
  stdout.write("Masukkan Nilai B: ");
  int b = int.parse(stdin.readLineSync()!);
  stdout.write("Masukkan Nama Lengkap: ");
  String? namaLengkap = stdin.readLineSync();

  int penjumlahan = a + b;
  int pengurangan = a - b;
  int perkalian = a * b;
  double pembagian = a / b;

  print("Nama Lengkap: $namaLengkap");
  print("Hasil Penjumlahan: $penjumlahan");
  print("Hasil Pengurangan: $pengurangan");
  print("Hasil Perkalian: $perkalian");
  print("Hasil Pembagian: $pembagian");
}