import 'dart:async';
import 'dart:io';

void main() async {
  //  Link YouTube (sabar)
  const youtubeLink = 'https://youtu.be/pRpeEdMmmQ0';

  //  Lirik pembuka (aman digunakan untuk contoh)
  final lyrics = [
    {'text': "You're a good soldier", 'delay': 3},
    {'text': "Choosing your battles", 'delay': 3},
    {'text': "Pick yourself up and dust yourself off", 'delay': 4},
    {'text': "And get back in the saddle", 'delay': 4},
  ];

  print(' Membuka video YouTube...');
  await Future.delayed(Duration(seconds: 2));

  // ️ Buka video di browser
  if (Platform.isWindows) {
    await Process.run('start', [youtubeLink], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', [youtubeLink]);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', [youtubeLink]);
  }

  print(' Putar lagu di YouTube... Lirik akan muncul di bawah ini!\n');
  await Future.delayed(Duration(seconds: 6)); // waktu buffer biar lagu mulai

  //  Sinkronisasi lirik dengan tempo
  for (var line in lyrics) {
    stdout.write('\x1B[2J\x1B[0;0H'); // clear screen
    print(' ${line['text']}');
    await Future.delayed(Duration(seconds: line['delay'] as int));
  }

  print('\n Opening selesai! ');
}
