void main() {
  looping1();
  looping2();
}

void looping1() {
  print("LOOPING PERTAMA");
  for (int i = 2; i <= 20; i += 2) {
    print("$i - I LOVE CODING");
  }
}

void looping2() {
  print("LOOPING KEDUA");
  for (int i = 20; i >= 2; i -= 2) {
    print("$i - I WILL BECOME A MOBILE DEVELOPER");
  }
}
