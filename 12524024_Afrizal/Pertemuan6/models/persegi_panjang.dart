import 'bangun_datar.dart';

class PersegiPanjang extends BangunDatar {
  double _panjang = 0;
  double _lebar = 0;

  set panjang(double value) {
    if (value > 0) {
      _panjang = value;
    } else {
      print('⚠️ Panjang harus lebih dari 0!');
    }
  }

  set lebar(double value) {
    if (value > 0) {
      _lebar = value;
    } else {
      print('⚠️ Lebar harus lebih dari 0!');
    }
  }

  double get panjang => _panjang;
  double get lebar => _lebar;

  @override
  double hitungLuas() => _panjang * _lebar;

  @override
  void info() {
    print('🔷 Persegi Panjang: panjang=$_panjang, lebar=$_lebar');
    print('👉 Luas = ${hitungLuas()}');
  }
}
