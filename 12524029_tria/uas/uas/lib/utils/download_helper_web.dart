import 'dart:html' as html;

Future<void> saveTicketFile(String filename, String content) async {
  final bytes = html.Blob([content], 'text/plain');
  final url = html.Url.createObjectUrlFromBlob(bytes);
  final anchor = html.AnchorElement(href: url)
    ..download = filename
    ..style.display = 'none';
  html.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
}

Future<void> openPrintPreview(String title, String htmlContent) async {
  final blob = html.Blob([htmlContent], 'text/html');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, title);
  // Do not immediately revoke the URL; let the browser manage lifecycle.
}
