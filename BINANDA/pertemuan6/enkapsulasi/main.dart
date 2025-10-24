import 'persegi_panjang.dart';
void main(List<String> args) {
  PersegiPanjang kotak; // inisialisasi persegi panjang
  double luasKotak; // inisialisasi tipe data luas kotak
  kotak = new PersegiPanjang(); 
  kotak.setPanjang(4.0); // set nilai panjang
  kotak.setLebar(6.0); //set nilai lebar
  luasKotak = kotak.hitungLuas(); // allias luaskotak
  print(luasKotak); // mencetak luas kotak
}