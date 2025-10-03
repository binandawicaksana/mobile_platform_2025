vvoid main() {
  loopingPertama();
  print(""); // baris kosong
  loopingKedua();
}

// Fungsi untuk looping pertama
void loopingPertama() {
  print("LOOPING PERTAMA");
  for (int i = 2; i <= 20; i += 2) {
    print("$i - I love coding");
  }
}

// Fungsi untuk looping kedua
void loopingKedua() {
  print("LOOPING KEDUA");
  for (int i = 20; i >= 2; i -= 2) {
    print("$i - I will become a mobile developer");
  }
}