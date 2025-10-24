class PersegiPanjang {
  double panjang;
  double lebar;

  PersegiPanjang(this.panjang, this.lebar);

  double hitungLuas() {
    return panjang * lebar;
  }

  void tampilkanInfo() {
    print("Persegi Panjang:");
    print("Panjang: $panjang");
    print("Lebar: $lebar");
    print("Luas: ${hitungLuas()}");
  }
}
