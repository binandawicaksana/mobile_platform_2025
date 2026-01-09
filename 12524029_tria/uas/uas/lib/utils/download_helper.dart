library download_helper;

import 'download_helper_stub.dart'
    if (dart.library.html) 'download_helper_web.dart'
    if (dart.library.io) 'download_helper_io.dart' as impl;

Future<void> saveTicketFile(String filename, String content) =>
    impl.saveTicketFile(filename, content);

Future<void> openPrintPreview(String title, String html) =>
    impl.openPrintPreview(title, html);

