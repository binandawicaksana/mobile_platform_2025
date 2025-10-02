void main() {
  print("LOOPING PERTAMA");
  loopingPertama();
  
  print("\nLOOPING KEDUA");
  loopingKedua();
}

void loopingPertama() {
  for (int i = 2; i <= 20; i += 2) {
    print("$i - I love lucas 💌 💋");
  }
}

void loopingKedua() {
  for (int i = 20; i >= 2; i -= 2) {
    print("$i - I will become a mobile developer 📌");
  }
}
