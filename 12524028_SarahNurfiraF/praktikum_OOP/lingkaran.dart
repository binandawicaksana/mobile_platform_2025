import 'dart:math';

class Lingkaran {
  double jariJari;

  Lingkaran(this.jariJari);

  double hitungLuas() {
    return pi * pow(jariJari, 2);
  }

  void tampilkanInfo() {
    print("Lingkaran:");
    print("Jari-jari: $jariJari");
    print("Luas: ${hitungLuas()}");
  }
}
