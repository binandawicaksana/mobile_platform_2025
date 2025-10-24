class Segitiga {
  double alas;
  double tinggi;

  // Constructor
  Segitiga(this.alas, this.tinggi);

  // Method untuk menghitung luas
  double hitungLuas() {
    return 0.5 * alas * tinggi;
  }

  void tampilkanInfo() {
    print("Segitiga:");
    print("Alas: $alas");
    print("Tinggi: $tinggi");
    print("Luas: ${hitungLuas()}");
  }
}
