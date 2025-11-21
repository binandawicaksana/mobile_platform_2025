import 'dart:async';

Future<void> main() async {
  print("🎤 Karaoke - Untuk Mencintaimu (by Seventeen)");
  print("---------------------------------------------\n");

  List<Map<String, dynamic>> lyrics = [
    {"line": "Apa yang harus aku lakukan", "delay": 5},
    {"line": "Untuk membuat kau mencintaiku?", "delay": 5},
    {"line": "Segala upaya", "delay": 6},
    {"line": "T'lah kulakukan untukmu", "delay": 6},
    {"line": "Apa yang harus aku tunjukkan", "delay": 3},
    {"line": "Untuk membuat kau menyayangiku?", "delay": 5},
    {"line": "Inilah aku", "delay": 3},
    {"line": "Yang memilih kau untukku", "delay": 8},
    {"line": "Kar'na aku mencintaimu", "delay": 7},
    {"line": "Dan hatiku hanya untukmu", "delay": 7},
    {"line": "Tak akan menyerah", "delay": 4},
    {"line": "Dan takkan berhenti mencintaimu", "delay": 4},
    {"line": "Ku berjuang dalam hidupku", "delay": 5},
    {"line": "Untuk s'lalu memilikimu", "delay": 5},
    {"line": "Seumur hidupku, setulus hatiku", "delay": 5},
    {"line": "Hanya untukmu", "delay": 10},
    {"line": "Hu-wo", "delay": 5},
    {"line": "Kar'na aku mencintaimu", "delay": 7},
    {"line": "Dan hatiku hanya untukmu", "delay": 7},
    {"line": "Tak akan menyerah", "delay": 4},
    {"line": "Dan takkan berhenti mencintaimu", "delay": 9},
    {"line": "Ku berjuang dalam hidupku", "delay": 8},
    {"line": "Untuk s'lalu memilikimu", "delay": 8},
    {"line": "Seumur hidupku, setulus hatiku", "delay": 5},
    {"line": "Hanya untukmu", "delay": 7},
    {"line": "Seumur hidupku, setulus hatiku", "delay": 7},
    {"line": "Uh-uh", "delay": 5},
  ];

  for (var item in lyrics) {
    await Future.delayed(Duration(milliseconds: (item["delay"] * 1000).round()));
    print(item["line"]);
  }

  print("\n🎶 Lagu selesai. Terima kasih sudah bernyanyi!");
}
