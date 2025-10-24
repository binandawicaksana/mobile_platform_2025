import 'dart:async';

void main() async {
  List<String> lyrics = [
    "Lagunya begini, nadanya begitu",
    "Liriknya sederhana tapi jujur sekali",
    "Tak perlu banyak kata buat kau mengerti",
    "Bahwa cinta tak serumit teori",
  ];

  print("=== Karaoke: Lagunya Begini Nadanya Begitu (Jason Ranti) ===\n");

  for (var line in lyrics) {
    print(line);
    await Future.delayed(Duration(seconds: 3)); // jeda antar baris
  }

  print("\n=== Selesai ===");
}
