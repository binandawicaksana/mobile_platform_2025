import 'dart:io';

void main(List<String> args) {
  print("masukan pasword");
  String? inputText = stdin.readLineSync()!;
  print("pasword : ${inputText}");
}
