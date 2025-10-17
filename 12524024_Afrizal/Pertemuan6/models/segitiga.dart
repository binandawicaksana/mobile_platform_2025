import 'bangun_datar.dart';

class Segitiga extends BangunDatar {
  double _alas = 0;
  double _tinggi = 0;

  set alas(double value) {
    if (value > 0) {
      _alas = value;
    } else {
      print('⚠️ Alas harus lebih dari 0!');
    }
  }

  set tinggi(double value) {
    if (value > 0) {
      _tinggi = value;
    } else {
      print('⚠️ Tinggi harus lebih dari 0!');
    }
  }

  double get alas => _alas;
  double get tinggi => _tinggi;

  @override
  double hitungLuas() => 0.5 * _alas * _tinggi;

  @override
  void info() {
    print('🔺 Segitiga: alas=$_alas, tinggi=$_tinggi');
    print('👉 Luas = ${hitungLuas()}');
  }
}
