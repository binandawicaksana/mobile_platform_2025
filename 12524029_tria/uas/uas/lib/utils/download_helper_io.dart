import 'dart:io';

Future<void> saveTicketFile(String filename, String content) async {
  final dir = await Directory.systemTemp.createTemp('tiket_');
  final file = File('${dir.path}/$filename');
  await file.writeAsString(content);
}

Future<void> openPrintPreview(String title, String html) async {
  // On IO, no print preview. Save an HTML copy instead.
  final dir = await Directory.systemTemp.createTemp('tiket_preview_');
  final file = File('${dir.path}/ticket.html');
  await file.writeAsString(html);
}

