import 'dart:async';

void main() async {
  print("🎶 Now playing: TWICE - Strategy (Pre-Chorus + Reff)");
  print("Get ready to sing along!\n");

  // Daftar lirik dan waktu tampil (detik)
  final lyrics = [
    {"time": 0, "text": 'When I say, "Hi"'},
    {"time": 3, "text": "I'm feeling all your attention on me"},
    {"time": 7, "text": "Hi"},
    {"time": 9, "text": "No reason to be so shy with me"},
    {"time": 13, "text": "I ain't gonna bite, come on over (no)"},
    {"time": 17, "text": "I know you wanna move a little closer (yeah)"},
    {"time": 21, "text": "I got a plan to get you with me"},
    {"time": 25, "text": "I got you on my radar, soon you're gonna be with me"},
    {"time": 30, "text": "My strategy, strategy will get ya, get ya, baby"},
    {"time": 35, "text": "Winnin' is my trademark, soon you'll never wanna leave"},
    {"time": 40, "text": "My strategy, strategy will get ya, get ya, baby"},
    {"time": 45, "text": "Hey, boy, I'ma get ya"},
    {"time": 48, "text": "I'ma get you real good and I bet ya"},
    {"time": 52, "text": "Hey, boy, once I get ya"},
    {"time": 55, "text": "You'll be, oh, so glad that I met ya"},
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

  print("\n🎵 End of Pre-Chorus + Reff — Good job!");
}
