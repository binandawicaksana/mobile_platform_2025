import 'dart:math';

// ==============================
// Kelas Abstrak (Abstraction)
// ==============================
abstract class BangunDatar {
  String nama;

  BangunDatar(this.nama);

  // Method abstrak — harus di-override oleh kelas turunan
  double hitungLuas();

  void info() {
    print("Bangun Datar: $nama");
  }
}

// ==============================
// Kelas Turunan 1 - Persegi Panjang
// ==============================
class PersegiPanjang extends BangunDatar {
  double _panjang; // enkapsulasi (private dengan underscore)
  double _lebar;

  PersegiPanjang(this._panjang, this._lebar) : super("Persegi Panjang");

  // getter dan setter (encapsulation)
  double get panjang => _panjang;
  set panjang(double value) => _panjang = value;

  double get lebar => _lebar;
  set lebar(double value) => _lebar = value;

  @override
  double hitungLuas() => _panjang * _lebar;
}

// ==============================
// Kelas Turunan 2 - Segitiga
// ==============================
class Segitiga extends BangunDatar {
  double _alas;
  double _tinggi;

  Segitiga(this._alas, this._tinggi) : super("Segitiga");

  @override
  double hitungLuas() => 0.5 * _alas * _tinggi;
}

// ==============================
// Kelas Turunan 3 - Lingkaran
// ==============================
class Lingkaran extends BangunDatar {
  double _jariJari;

  Lingkaran(this._jariJari) : super("Lingkaran");

  @override
  double hitungLuas() => pi * pow(_jariJari, 2);
}

// ==============================
// Fungsi Utama (Main Program)
// ==============================
void main() {
  print("=== Program Luas Bangun Datar (OOP - Dart) ===\n");

  // Membuat objek dari setiap bangun
  var persegiPanjang = PersegiPanjang(5, 10);
  var segitiga = Segitiga(6, 8);
  var lingkaran = Lingkaran(7);

  // Polimorfisme — semua objek disimpan dalam list yang sama
  List<BangunDatar> bangunList = [persegiPanjang, segitiga, lingkaran];

  for (var bangun in bangunList) {
    bangun.info();
    print("Luas: ${bangun.hitungLuas().toStringAsFixed(2)}\n");
  }
}
