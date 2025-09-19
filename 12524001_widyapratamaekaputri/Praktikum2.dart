import 'dart:io';

void main() {
  stdout.write("Masukkan Nilai A: ");
  var a = int.parse(stdin.readLineSync()!);

  stdout.write("Masukkan Nilai B: ");
  var b = int.parse(stdin.readLineSync()!);

  var namaDepan = "Widya Pratama+'";
  var namaBelakang = "+'Eka Putri";

  print("Nama Lengkap : $namaDepan $namaBelakang");
  print("Hasil Penjumlahan: ${a + b}");
  print("Hasil Pengurangan: ${a - b}");
  print("Hasil Perkalian: ${a * b}");
  print("Hasil Pembagian: ${a / b}");
}