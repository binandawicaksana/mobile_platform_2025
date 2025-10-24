class PersegiPanjang {
  double panjang;
  double lebar;

<<<<<<< HEAD
  // Constructor
  PersegiPanjang(this.panjang, this.lebar);

  // Method untuk menghitung luas
=======
  PersegiPanjang(this.panjang, this.lebar);

>>>>>>> fabdb0bad6bb3a23e37c1c05f43003ec864e8aff
  double hitungLuas() {
    return panjang * lebar;
  }

<<<<<<< HEAD
  // Method untuk menampilkan informasi
=======
>>>>>>> fabdb0bad6bb3a23e37c1c05f43003ec864e8aff
  void tampilkanInfo() {
    print("Persegi Panjang:");
    print("Panjang: $panjang");
    print("Lebar: $lebar");
    print("Luas: ${hitungLuas()}");
  }
}
