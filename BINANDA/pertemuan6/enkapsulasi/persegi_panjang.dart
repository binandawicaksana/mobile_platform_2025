class PersegiPanjang {
  late double _panjang; //initialisasi tipe data panjang
  late double _lebar; //initialisasi tipe data lebar
  void setPanjang(double value) {
    if (value < 0) {
      // validasi jika nilai di bawah 0
      value *= -1; // akan di kalikan 1, misal 1-2 hasilnya 2
    }
    _panjang = value; //alias
  }
  double getPanjang() {
    return _panjang; // mengembalikan nilai get panjang
  }
  void setLebar(double value) {
    if (value < 0) {// validasi jika nilai di bawah 0
      value *= -1; // akan di kalikan 1, misal -1 -2 hasilnya 2
    }
    _lebar = value; //alias
  }
  double getLebar() {
    return _lebar; // mengembalikan nilai get panjang
  }
  double hitungLuas() {
    return this._panjang * _lebar; //mereturn hasil
  }
}
