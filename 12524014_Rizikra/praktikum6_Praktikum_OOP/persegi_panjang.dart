import 'bangun_datar.dart';

class PersegiPanjang extends BangunDatar {
  double panjang;
  double lebar;

  PersegiPanjang(this.panjang, this.lebar);

  @override
  double hitungLuas() => panjang * lebar;
}
