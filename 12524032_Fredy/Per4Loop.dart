void main() {
  //panggil function loop peetama
  loopingPertama(20);
  //panggil function loop kedua
  loopingKedua(20);
}
//function loop pertama
void loopingPertama(int batas) {
  print("LOOPING PERTAMA");
  for (int i = 2; i <= batas; i += 2) {
    print("$i- i love coding");
  }
}
//function loop kedua
void loopingKedua(int batas) {
  print("LOOPING KEDUA");
  for (int i = batas; i >= 2; i -= 2) {
    print("$i - i will become a mobile developer");
  }
}