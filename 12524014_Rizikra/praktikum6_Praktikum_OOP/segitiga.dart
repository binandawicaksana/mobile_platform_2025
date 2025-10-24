import 'bangun_datar.dart';

class Segitiga extends BangunDatar {
  double alas;
  double tinggi;

  Segitiga(this.alas, this.tinggi);

  @override
  double hitungLuas() => 0.5 * alas * tinggi;
}
