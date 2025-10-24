class Segitiga {
  double alas;
  double tinggi;

  Segitiga(this.alas, this.tinggi);

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
