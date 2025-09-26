import 'dart:io';
void main(List<String> args) {
  stdout.write("Masukkan nilai A: ");
  int nilaiA = int.parse(stdin.readLineSync()!);
  stdout.write("Masukkan nilai B: ");
  int nilaiB = int.parse(stdin.readLineSync()!);
  stdout.write("Masukkan nama depan: ");
  String namaDepan = stdin.readLineSync()!;
  stdout.write("Masukkan nama belakang: ");
  String namaBelakang = stdin.readLineSync()!;
  String namaLengkap = "$namaDepan +' '+ $namaBelakang";
  int hasilJumlah = nilaiA + nilaiB;
  int hasilKali = nilaiA * nilaiB;
  double hasilBagi = nilaiA / nilaiB;
  print("\nnilai A: $nilaiA");
  print("nilai B: $nilaiB");
  print("nama lengkap : $namaLengkap");
  print("hasil penjumlahan: $hasilJumlah");
  print("hasil perkalian: $hasilKali");
  print("hasil pembagian: $hasilBagi");
}