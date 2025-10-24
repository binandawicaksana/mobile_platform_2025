import 'dart:async';

void main() async {
  print("🎶 Now playing: Kehlani - Folded");
  print("Get ready to sing along!\n");

  // Lirik dan waktu tampil (dalam detik)
  final lyrics = [
    {"time": 0, "text": "Meet me at my door while it's still open"},
    {"time": 4, "text": "I know it's getting cold out, but tell me that it's not frozen"},
    {"time": 9, "text": "So come pick up your clothes"},
    {"time": 12, "text": "I have them folded"},
    {"time": 15, "text": "I'll let your body decide if this is good enough for you"},
    {"time": 20, "text": "Already folding it for you"},
    {"time": 23, "text": "Already folding up for you"},
    {"time": 26, "text": "I'll let your body decide if this is good enough for you"},
    {"time": 31, "text": "Already folding it for you"},
    {"time": 34, "text": "Already folding up for you"},
    {"time": 37, "text": "I'll let your body decide if this is good enough for you"},
    {"time": 42, "text": "Already folding it for you"},
    {"time": 45, "text": "Already folding up for you"},
    {"time": 48, "text": "I'll let your body decide if this is good enough for you"},
    // Menuju ending — makin cepat jedanya
    {"time": 52, "text": "Already folding it for you"},
    {"time": 54, "text": "Already folding up for you"},
  ];

  final startTime = DateTime.now();

  for (var line in lyrics) {
    final delay = Duration(seconds: line["time"] as int);
    final now = DateTime.now();
    final elapsed = now.difference(startTime);

    if (elapsed < delay) {
      await Future.delayed(delay - elapsed);
    }

    print(line["text"]);
  }

  print("\n🎵 End of 'Folded' — nice timing!");
}
