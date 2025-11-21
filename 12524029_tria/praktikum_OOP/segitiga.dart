class Segitiga {
  double alas;
  double tinggi;

<<<<<<< HEAD
  // Constructor
  Segitiga(this.alas, this.tinggi);

  // Method untuk menghitung luas
=======
  Segitiga(this.alas, this.tinggi);

>>>>>>> fabdb0bad6bb3a23e37c1c05f43003ec864e8aff
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
