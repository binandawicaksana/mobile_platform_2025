import 'dart:math';
import 'bangun_datar.dart';

class Lingkaran extends BangunDatar {
  double _jariJari = 0;

  set jariJari(double value) {
    if (value > 0) {
      _jariJari = value;
    } else {
      print('⚠️ Jari-jari harus lebih dari 0!');
    }
  }

  double get jariJari => _jariJari;

  @override
  double hitungLuas() => pi * _jariJari * _jariJari;

  @override
  void info() {
    print('⚪ Lingkaran: jari-jari=$_jariJari');
    print('👉 Luas = ${hitungLuas()}');
  }
}
