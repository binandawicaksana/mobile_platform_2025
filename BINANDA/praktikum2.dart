import 'dart:io';

void main(List<String> args) {
  print("Masukan Nama Depan:");
  String? namadepan = stdin.readLineSync()!;
  print("Masukan Nama Belakang:");
  String? namabelakang = stdin.readLineSync()!;
  print("Masukan Nilai A:");
  String? nilaia = stdin.readLineSync()!;
  print("Masukan Nilai B:");
  String? nilaib = stdin.readLineSync()!;
  final int _nilaia = int.parse(nilaia);
  final int _nilaib = int.parse(nilaib);
  int penjumlahan = _nilaia + _nilaib;
  int perngurangan = _nilaia - _nilaib;
  int perkalian = _nilaia * _nilaib;
  double pembagian = _nilaia / _nilaib;
  print("Nama Lengkap : $namadepan +' '+ $namabelakang");
  print("Hasil Penjumlahan: $penjumlahan");
  print("Hasil Pengurangan: $perngurangan");
  print("Hasil Perkalian: $perkalian");
  print("Hasil Pembagian: $pembagian");
  // print("password : ${inputText}");
}
