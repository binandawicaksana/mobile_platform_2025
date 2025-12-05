import 'dart:math';

class Lingkaran {
  double jariJari;

  // Constructor
  Lingkaran(this.jariJari);

  // Method untuk menghitung luas
  double hitungLuas() {
    return pi * pow(jariJari, 2);
  }

  void tampilkanInfo() {
    print("Lingkaran:");
    print("Jari-jari: $jariJari");
    print("Luas: ${hitungLuas()}");
  }
}
