void loopingPertama() {
  print("LOOPING PERTAMA");
  for (int i = 2; i <= 20; i += 2) {
    print("$i - I love codding 💕");
  }
}

void loopingKedua() {
  print("\nLOOPING KEDUA");
  for (int i = 20; i >= 2; i -= 2) {
    print("$i - I will become a mobile developer ✨");
  }
}

void main() {
  loopingPertama();
  loopingKedua();
}