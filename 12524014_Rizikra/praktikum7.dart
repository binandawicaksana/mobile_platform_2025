import 'dart:async';

Future<void> tampilkanLirik(List<Map<String, dynamic>> lirik) async {
  for (var baris in lirik) {
    await Future.delayed(Duration(seconds: baris['delay']));
    print(baris['text']);
  }
}

Future<void> main() async {
  print('Lagu: "Celengan Rindu - Fiersa Besari"\n');

  // Daftar lirik dengan timing (detik)
  List<Map<String, dynamic>> lirik = [
    {'text': 'Ingin ku berdiri di sebelahmu', 'delay': 2},
    {'text': 'Menggenggam erat jari-jarimu', 'delay': 4},
    {'text': 'Mendengarkan lagu Sheila On 7', 'delay': 4},
    {'text': 'Seperti waktu itu...', 'delay': 4},
    {'text': 'saat kau di sisiku...', 'delay': 3},
  ];

  await tampilkanLirik(lirik);
}
