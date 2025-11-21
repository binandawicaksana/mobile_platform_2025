import 'dart:io';
import 'dart:async';

// ANSI color code untuk warna terminal
const String merah = '\x1B[91m';
const String putih = '\x1B[97m';
const String reset = '\x1B[0m';

void clearScreen() {
  // Membersihkan layar terminal (Windows / Mac / Linux)
  if (Platform.isWindows) {
    stdout.write(Process.runSync("cls", [], runInShell: true).stdout);
  } else {
    stdout.write('\x1B[2J\x1B[0;0H');
  }
}

Future<void> tampilkanLirik(List<String> lirik, Duration jeda) async {
  for (var baris in lirik) {
    clearScreen();

    // Menampilkan baris lirik dengan warna
    if (baris.contains("Stand By Me") || baris.contains("Oasis")) {
      print("$merah$baris$reset");
    } else {
      print("$putih$baris$reset");
    }

    await Future.delayed(jeda);
  }

  clearScreen();
  print("$merah🎵 Lagu selesai! Stand By Me - OASIS 🎵$reset");
}

void main() async {
 List<String> lirikLagu = [
  "If you’re leaving will you take me with you?",
  "I’m tired of talking on my phone",
  "There is one thing I can never give you",
  "My heart will never be your home",
  "",
  "So what’s the matter with you?",
  "Sing me something new… Don’t you know",
  "The cold and wind and rain don’t know",
  "They only seem to come and go away",
  "",
  "Stand by me, nobody knows the way it’s gonna be",
  "Stand by me, nobody knows the way it’s gonna be",
  "Stand by me, nobody knows the way it’s gonna be",
];


  print("${merah}=== 🎶'Stand By Me' 🎶 ===$reset");
  stdout.write("${putih}ENTER to lets song... 🎤$reset");
  stdin.readLineSync();

  await tampilkanLirik(lirikLagu, const Duration(seconds: 4));
}
