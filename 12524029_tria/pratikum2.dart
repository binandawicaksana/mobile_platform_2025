import 'dart:io';

void main() {
  // Input nama depan
  stdout.write("Masukkan Nama Depan: ");
  String? namaDepan = stdin.readLineSync();

  // Input nama belakang
  stdout.write("Masukkan Nama Belakang: ");
  String? namaBelakang = stdin.readLineSync();

  // Input nilai A
  stdout.write("Masukkan Nilai A: ");
  int a = int.parse(stdin.readLineSync()!);

  // Input nilai B
  stdout.write("Masukkan Nilai B: ");
  int b = int.parse(stdin.readLineSync()!);

  // Output nama lengkap
  print("Nama Lengkap : $namaDepan $namaBelakang");

  // Perhitungan
  int hasilTambah = a + b;
  int hasilKurang = a - b;
  int hasilKali = a * b;
  double hasilBagi = a / b;

  // Output hasil
  print("Hasil Penjumlahan: $hasilTambah");
  print("Hasil Pengurangan: $hasilKurang");
  print("Hasil Perkalian: $hasilKali");
  print("Hasil Pembagian: $hasilBagi");
}