import 'persegi_panjang.dart';
import 'segitiga.dart';
import 'lingkaran.dart';

void main() {
  var persegiPanjang = PersegiPanjang(10, 20);
  var segitiga = Segitiga(12, 24);
  var lingkaran = Lingkaran(21);

  print("=== Perhitungan Luas Bangun Datar ===");
  print("Persegi Panjang: ${persegiPanjang.hitungLuas()}");
  print("Segitiga: ${segitiga.hitungLuas()}");
  print("Lingkaran: ${lingkaran.hitungLuas().toStringAsFixed(2)}");
}
