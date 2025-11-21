// Program Perhitungan Luas Bangun Datar dengan OOP dan Enkapsulasi
// Nama: Daud Zulfikar

// Class abstrak sebagai parent class
abstract class BangunDatar {
  // Method abstrak yang akan diimplementasikan oleh child class
  double hitungLuas();
  
  // Method untuk menampilkan hasil perhitungan
  void tampilLuas() {
    print('Luas: ${hitungLuas()} satuan persegi');
  }
}

// Class PersegiPanjang dengan enkapsulasi
class PersegiPanjang extends BangunDatar {
  // Property dengan access modifier private (ditandai dengan underscore)
  double _panjang = 0;
  double _lebar = 0;
  
  // Constructor
  PersegiPanjang([double panjang = 0, double lebar = 0]) {
    this._panjang = panjang;
    this._lebar = lebar;
  }
  
  // Getter untuk panjang
  double get panjang {
    return _panjang;
  }
  
  // Setter untuk panjang dengan validasi
  set panjang(double value) {
    // Validasi: nilai tidak boleh negatif
    if (value < 0) {
      value = 0;
      print('Nilai panjang tidak boleh negatif. Nilai diubah menjadi 0.');
    }
    _panjang = value;
  }
  
  // Getter untuk lebar
  double get lebar {
    return _lebar;
  }
  
  // Setter untuk lebar dengan validasi
  set lebar(double value) {
    // Validasi: nilai tidak boleh negatif
    if (value < 0) {
      value = 0;
      print('Nilai lebar tidak boleh negatif. Nilai diubah menjadi 0.');
    }
    _lebar = value;
  }
  
  // Implementasi method hitungLuas dari class BangunDatar
  @override
  double hitungLuas() {
    return _panjang * _lebar;
  }
}

// Class Segitiga dengan enkapsulasi
class Segitiga extends BangunDatar {
  // Property dengan access modifier private
  double _alas = 0;
  double _tinggi = 0;
  
  // Constructor
  Segitiga([double alas = 0, double tinggi = 0]) {
    this._alas = alas;
    this._tinggi = tinggi;
  }
  
  // Getter untuk alas
  double get alas {
    return _alas;
  }
  
  // Setter untuk alas dengan validasi
  set alas(double value) {
    if (value < 0) {
      value = 0;
      print('Nilai alas tidak boleh negatif. Nilai diubah menjadi 0.');
    }
    _alas = value;
  }
  
  // Getter untuk tinggi
  double get tinggi {
    return _tinggi;
  }
  
  // Setter untuk tinggi dengan validasi
  set tinggi(double value) {
    if (value < 0) {
      value = 0;
      print('Nilai tinggi tidak boleh negatif. Nilai diubah menjadi 0.');
    }
    _tinggi = value;
  }
  
  // Implementasi method hitungLuas dari class BangunDatar
  @override
  double hitungLuas() {
    return 0.5 * _alas * _tinggi;
  }
}

// Class Lingkaran dengan enkapsulasi
class Lingkaran extends BangunDatar {
  // Property dengan access modifier private
  double _jariJari = 0;
  final double _pi = 3.14159265359;
  
  // Constructor
  Lingkaran([double jariJari = 0]) {
    this._jariJari = jariJari;
  }
  
  // Getter untuk jari-jari
  double get jariJari {
    return _jariJari;
  }
  
  // Setter untuk jari-jari dengan validasi
  set jariJari(double value) {
    if (value < 0) {
      value = 0;
      print('Nilai jari-jari tidak boleh negatif. Nilai diubah menjadi 0.');
    }
    _jariJari = value;
  }
  
  // Getter untuk pi (read-only)
  double get pi {
    return _pi;
  }
  
  // Implementasi method hitungLuas dari class BangunDatar
  @override
  double hitungLuas() {
    return _pi * _jariJari * _jariJari;
  }
}

// Main function untuk demonstrasi program
void main() {
  print('=== Program Perhitungan Luas Bangun Datar ===\n');
  
  // Demonstrasi PersegiPanjang
  print('--- Persegi Panjang ---');
  var persegiPanjang = PersegiPanjang();
  persegiPanjang.panjang = 5;
  persegiPanjang.lebar = 3;
  print('Panjang: ${persegiPanjang.panjang}');
  print('Lebar: ${persegiPanjang.lebar}');
  persegiPanjang.tampilLuas();
  
  // Demonstrasi validasi nilai negatif
  print('\nMencoba mengatur nilai negatif:');
  persegiPanjang.panjang = -2;
  print('Panjang setelah validasi: ${persegiPanjang.panjang}');
  
  // Demonstrasi Segitiga
  print('\n--- Segitiga ---');
  var segitiga = Segitiga();
  segitiga.alas = 6;
  segitiga.tinggi = 4;
  print('Alas: ${segitiga.alas}');
  print('Tinggi: ${segitiga.tinggi}');
  segitiga.tampilLuas();
  
  // Demonstrasi Lingkaran
  print('\n--- Lingkaran ---');
  var lingkaran = Lingkaran();
  lingkaran.jariJari = 7;
  print('Jari-jari: ${lingkaran.jariJari}');
  print('Nilai π: ${lingkaran.pi}');
  lingkaran.tampilLuas();
  
  // Demonstrasi constructor dengan parameter
  print('\n--- Menggunakan Constructor dengan Parameter ---');
  var pp2 = PersegiPanjang(4, 6);
  print('Persegi Panjang - Panjang: ${pp2.panjang}, Lebar: ${pp2.lebar}');
  pp2.tampilLuas();
  
  var s2 = Segitiga(8, 5);
  print('Segitiga - Alas: ${s2.alas}, Tinggi: ${s2.tinggi}');
  s2.tampilLuas();
  
  var l2 = Lingkaran(10);
  print('Lingkaran - Jari-jari: ${l2.jariJari}');
  l2.tampilLuas();
}