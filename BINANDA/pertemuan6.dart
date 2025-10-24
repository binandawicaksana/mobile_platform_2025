class PersegiPanjang {
  late double panjang;
  late double lebar;
  double hitungLuas() {
    return this.panjang * this.lebar;
  }
}
void main() {
  PersegiPanjang kotak;
  double luasKotak;
  kotak = new PersegiPanjang();
  kotak.panjang = 2;
  kotak.lebar = 5;
  luasKotak = kotak.hitungLuas();
  print(luasKotak);
}