import 'dart:io';

void main(List<String> args) {
  stdout.write("masukkan nama depan: ");
  String? namadepan = stdin.readLineSync();

  stdout.write("masukkan nama belakang: ");
  String? namabelakang = stdin.readLineSync();

  stdout.write("masukkan angka a: ");
  int a = int.parse(stdin.readLineSync()!);

  stdout.write("masukkan angka b: ");
  int b = int.parse(stdin.readLineSync()!);

  print("\n=== Hasil ===");
  print("Nama lengkap : $namadepan $namabelakang");
  print("a = $a");
  print("b = $b");
  print("Jumlah a + b = ${a + b}");
}
