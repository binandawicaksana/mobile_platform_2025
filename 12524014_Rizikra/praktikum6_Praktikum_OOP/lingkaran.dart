import 'dart:math';
import 'bangun_datar.dart';

class Lingkaran extends BangunDatar {
  double jariJari;

  Lingkaran(this.jariJari);

  @override
  double hitungLuas() => pi * pow(jariJari, 2);
}
