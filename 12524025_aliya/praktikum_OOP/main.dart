import 'persegi_panjang.dart';
import 'segitiga.dart';
import 'lingkaran.dart';

void main() {
  var persegiPanjang = PersegiPanjang(10, 5);
  var segitiga = Segitiga(6, 4);
  var lingkaran = Lingkaran(7);

  print("=== Program Menghitung Luas Bangun Datar (OOP) ===\n");
  persegiPanjang.tampilkanInfo();
  print("\n----------------------\n");
  segitiga.tampilkanInfo();
  print("\n----------------------\n");
  lingkaran.tampilkanInfo();
}
