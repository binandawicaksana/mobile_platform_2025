import 'dart:async';
import 'dart:io';

const _titleColor = '\x1B[36m'; // Cyan
const _accentColor = '\x1B[35m'; // Magenta
const _lyricColor = '\x1B[33m'; // Yellow
const _reset = '\x1B[0m';

/// Simple karaoke-style printout for the chorus of "Monolog" by Pamungkas.
Future<void> main() async {
  _printHeader();

  final lyrics = <LyricLine>[
    LyricLine('[Reff]', Duration.zero),
    LyricLine('Alasan masih bersama', const Duration(seconds: 2)),
    LyricLine('Bukan karena terlanjur lama', const Duration(seconds: 2)),
    LyricLine('Tapi rasanya yang masih sama', const Duration(seconds: 2)),
    LyricLine('Seperti sejak pertama jumpa', const Duration(seconds: 2)),
    LyricLine('Dirimu di kala senja', const Duration(seconds: 2)),
    LyricLine('Duduk berdua tanpa suara', const Duration(seconds: 2)),
  ];

  for (final line in lyrics) {
    await Future.delayed(line.delayBefore);
    await _typeWriter(line.text);
  }

  print('\n${_accentColor}[Selesai] Reff selesai! Ulangi sesuka hati.$_reset');
}

class LyricLine {
  LyricLine(this.text, this.delayBefore);

  final String text;
  final Duration delayBefore;
}

Future<void> _typeWriter(String text) async {
  const charDelay = Duration(milliseconds: 120);
  stdout.write(_lyricColor);
  for (final codePoint in text.runes) {
    stdout.write(String.fromCharCode(codePoint));
    await Future.delayed(charDelay);
  }
  stdout
    ..write(_reset)
    ..writeln();
}

void _printHeader() {
  final border = '$_accentColor======================================$_reset';
  print(border);
  print(
    '$_titleColor      MONOLOG$_reset  ${_accentColor}|$_reset  '
    '${_lyricColor}Pamungkas$_reset',
  );
  print(border);
  stdout.writeln();
}
