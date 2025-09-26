import 'dart:io';

void main() {
  stdout.write("Masukkan Nama Depan: ");
  String? namaDepan = stdin.readLineSync();

  stdout.write("Masukkan Nama Belakang: ");
  String? namaBelakang = stdin.readLineSync();

  stdout.write("Masukkan Nilai A: ");
  int a = int.parse(stdin.readLineSync()!);

  stdout.write("Masukkan Nilai B: ");
  int b = int.parse(stdin.readLineSync()!);

  print("Nama Lengkap : $namaDepan $namaBelakang");

  int hasilTambah = a + b;
  int hasilKurang = a - b;
  int hasilKali = a * b;
  double hasilBagi = a / b;

  print("Hasil Penjumlahan: $hasilTambah");
  print("Hasil Pengurangan: $hasilKurang");
  print("Hasil Perkalian: $hasilKali");
  print("Hasil Pembagian: $hasilBagi");
}