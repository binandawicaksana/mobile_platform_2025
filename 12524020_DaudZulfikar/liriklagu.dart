// Program karaoke lyric dengan timing untuk opening lagu

class LyricLine {
  final String text;
  final double startTime; // waktu tampil dalam detik

  LyricLine({required this.text, required this.startTime});
}

class KaraokeLyricData {
  static const String songTitle = "Forever";
  static const String artist = "Unknown Artist";

  // List lirik opening dengan waktu kemunculan (detik)
  static final List<LyricLine> openingLyrics = [
    LyricLine(text: "Do you remember", startTime: 0.0),
    LyricLine(text: "When we were young you were always with your friends", startTime: 3.0),
    LyricLine(text: "Wanted to grab your hand and run away from them", startTime: 6.5),
    LyricLine(text: "I knew that it was time to tell you how I feel", startTime: 10.0),
    LyricLine(text: "So I made a move, I took your hand", startTime: 13.0),
    LyricLine(text: "My heart was beating loud like I've never felt before", startTime: 15.5),
    LyricLine(text: "You were smiling at me like you wanted more", startTime: 19.0),
    LyricLine(text: "I think you're the one I've never seen before", startTime: 22.5),
    LyricLine(text: "I want you to know", startTime: 26.0),
    LyricLine(text: "I love you the most", startTime: 28.0),
    LyricLine(text: "I'll always be there right by your side", startTime: 31.0),
    LyricLine(text: "'Cause baby, you're always in my mind", startTime: 34.0),
    LyricLine(text: "Just give me your forever (give me your forever)", startTime: 37.5),
  ];
}

// Optional: contoh fungsi untuk print lirik opening sesuai timing
void main() async {
  for (final line in KaraokeLyricData.openingLyrics) {
    await Future.delayed(Duration(milliseconds: (line.startTime * 1000).toInt()));
    print(line.text);
  }
}
