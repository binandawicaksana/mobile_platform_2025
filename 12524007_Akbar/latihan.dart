import 'dart:async';
import 'dart:io';

const List<Map<String, dynamic>> iceCreamLyrics = [
  
  {'lyric': "Come a little closer 'cause you looking thirsty", 'duration': 2500},
  {'lyric': "I'ma make it better, sip it like a Slurpee", 'duration': 2000},
  {'lyric': "Snow cone chilly, get it free like Willy (Oh)", 'duration': 2100},
  {'lyric': "In the jeans like Billie, you be poppin' like a wheelie", 'duration': 2000},

  {'lyric': "Even in the sun, you know I keep it icy", 'duration': 2300},
  {'lyric': "You could take a lick, but it's too cold to bite me (Haha)", 'duration': 2200},
  {'lyric': "Brr, brr, frozen, you're the one been chosen", 'duration': 2100},
  {'lyric': "Play the part like Moses, keep it fresh like roses (Oh)", 'duration': 2500},

  {'lyric': "", 'duration': 500},
  {'lyric': "Look so good, yeah, look so sweet (Hey)", 'duration': 1300},
  {'lyric': "Lookin' good enough to eat", 'duration': 1000},
  {'lyric': "Coldest with this kiss, so he call me ice cream", 'duration': 2000},
  {'lyric': "Catch me in the fridge, right where the ice be", 'duration': 2000},

  {'lyric': "Look so good, yeah, look so sweet (Hey)", 'duration': 1300},
  {'lyric': "Baby, you deserve a treat", 'duration': 1000},
  {'lyric': "Diamonds on my wrist, so he call me ice cream", 'duration': 2000},
  {'lyric': "You could double-dip 'cause I know you like me", 'duration': 2500},

  {'lyric': "", 'duration': 500}, 
  {'lyric': "Ice cream chillin', chillin', ice cream chillin'", 'duration': 1800},
  {'lyric': "Ice cream chillin', chillin', ice cream chillin'", 'duration': 2500},

  {'lyric': "\n(Verse 2 - Jennie)", 'duration': 1000},
  {'lyric': "I know that my heart can be so cold", 'duration': 2000},
  {'lyric': "But I'm sweet for you, come put me in a cone (In a cone)", 'duration': 2500},
];

void main() async {
  print("====================================");
  print("           KARAOKE LIRIK            ");
  print("  BLACKPINK (with Selena Gomez) - Ice Cream  ");
  print("====================================");
  print("Memulai dalam 3 detik...");
  await Future.delayed(Duration(seconds: 3));

  for (var item in iceCreamLyrics) {
    String lyric = item['lyric'];
    int durationMs = item['duration'];

    if (lyric.isNotEmpty) {
      print(lyric);
    }

    await Future.delayed(Duration(milliseconds: durationMs));
  }

  print("\n====================================");
  print("        LIRIK SELESAI DITAMPILKAN.        ");
  print("====================================");
}