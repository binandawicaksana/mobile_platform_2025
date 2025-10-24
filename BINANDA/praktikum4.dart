// Fungsi untuk melakukan looping pertama
loopingPertama() {
  print('LOOPING PERTAMA');
  // Looping dari 2 hingga 20, bertambah 2 setiap iterasi
  for (int i = 2; i <= 20; i += 2) {
    print('$i - I love coding');
  }
}
// Fungsi untuk melakukan looping kedua
loopingKedua() {
  print('---'); // Pemisah untuk output yang lebih jelas
  print('LOOPING KEDUA');
  // Looping dari 20 hingga 2, berkurang 2 setiap iterasi
  for (int i = 20; i >= 2; i -= 2) {
    print('$i - I will become a mobile developer');
  }
}
// Fungsi utama (main function) tempat eksekusi program dimulai
void main() {
  // Panggil fungsi loopingPertama
  loopingPertama();

  // Panggil fungsi loopingKedua
  loopingKedua();
}