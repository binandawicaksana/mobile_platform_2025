// import 'dart:io';

// void main() {
//   stdout.write('Masukkan Nama Depan: ');
//   String? firstName = stdin.readLineSync();

//   stdout.write('Masukkan Nama Belakang: ');
//   String? lastName = stdin.readLineSync();

//   stdout.write('Masukkan Nilai A: ');
//   String? aInput = stdin.readLineSync();

//   int a = int.tryParse(aInput ?? '0') ?? 0;

//   stdout.write('Masukkan Nilai B: ');
//   String? bInput = stdin.readLineSync();
//   int b = int.tryParse(bInput ?? '0') ?? 0;
  
//   String fullName = '$firstName $lastName';
//   int sum = a + b;
//   int difference = a - b;
//   int product = a * b;
//   double quotient = a / b;

//   print('Nama Lengkap: $fullName');
//   print('Hasil Penjumlahan: $sum');
//   print('Hasil Pengurangan: $difference');
//   print('Hasil Perkalian: $product');
//   print('Hasil Pembagian: $quotient');
// }