import 'dart:io';
import 'dart:math';

//PERSEGI PANJANG
class PersegiPanjang {
  late double _panjang;
  late double _lebar;

  void setPanjang(double value) {
    if (value < 0) value *= -1;
    _panjang = value;
  }

  void setLebar(double value) {
    if (value < 0) value *= -1;
    _lebar = value;
  }

  double hitungLuas() {
    return _panjang * _lebar;
  }
}
//SEGITIGA
class Segitiga {
  late double _alas;
  late double _tinggi;

  void setAlas(double value) {
    if (value < 0) value *= -1;
    _alas = value;
  }

  void setTinggi(double value) {
    if (value < 0) value *= -1;
    _tinggi = value;
  }

  double hitungLuas() {
    return 0.5 * _alas * _tinggi;
  }
}
//LINGKARAN
class Lingkaran {
  late double _jariJari;

  void setJariJari(double value) {
    if (value < 0) value *= -1;
    _jariJari = value;
  }

  double hitungLuas() {
    return pi * _jariJari * _jariJari;
  }
}
// PROGRAM UTAMA
void main() {
  print("\n Program perhitungan LUAS bangun datar\n");
  print("Pilih bangun datar yang ingin dihitung:");
  print("1. Persegi Panjang");
  print("2. Segitiga");
  print("3. Lingkaran");
  stdout.write("Input pilihan (1/2/3): ");
  String? pilihan = stdin.readLineSync();

  switch (pilihan) {
    case '1':
      PersegiPanjang kotak = PersegiPanjang();
      stdout.write("Masukkan panjang: ");
      double panjang = double.parse(stdin.readLineSync()!);
      stdout.write("Masukkan lebar: ");
      double lebar = double.parse(stdin.readLineSync()!);
      kotak.setPanjang(panjang);
      kotak.setLebar(lebar);
      print("\nLuas Persegi Panjang = ${kotak.hitungLuas()}");
      break;

    case '2':
      Segitiga segitiga = Segitiga();
      stdout.write("Masukkan alas: ");
      double alas = double.parse(stdin.readLineSync()!);
      stdout.write("Masukkan tinggi: ");
      double tinggi = double.parse(stdin.readLineSync()!);
      segitiga.setAlas(alas);
      segitiga.setTinggi(tinggi);
      print("\nLuas Segitiga = ${segitiga.hitungLuas()}");
      break;

    case '3':
      Lingkaran lingkaran = Lingkaran();
      stdout.write("Masukkan jari-jari: ");
      double r = double.parse(stdin.readLineSync()!);
      lingkaran.setJariJari(r);
      print("\nLuas Lingkaran = ${lingkaran.hitungLuas().toStringAsFixed(2)}");
      break;

    default:
      print("Pilihan tidak valid. Silakan jalankan ulang program.");
  }
}