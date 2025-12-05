class PersegiPanjang {
  double panjang;
  double lebar;

  // Constructor
  PersegiPanjang(this.panjang, this.lebar);

  // Method untuk menghitung luas
  double hitungLuas() {
    return panjang * lebar;
  }

  // Method untuk menampilkan informasi
  void tampilkanInfo() {
    print("Persegi Panjang:");
    print("Panjang: $panjang");
    print("Lebar: $lebar");
    print("Luas: ${hitungLuas()}");
  }
}
