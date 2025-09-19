// void main() {
//   print("Hell of a day");
// }

// import 'dart:io';

// void main(List<String> args) {
// print("masukan password");
// String? inputText = stdin.readLineSync()!;
// print("password : ${inputText}");
// }


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

  print("\nNama Lengkap : ${namaDepan} ${namaBelakang}");
  print("Hasil Penjumlahan : ${a + b}");
  print("Hasil Pengurangan : ${a - b}");
  print("Hasil Perkalian   : ${a * b}");
  print("Hasil Pembagian   : ${(a / b).toStringAsFixed(2)}");
}
