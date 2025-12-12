// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:uas/main.dart';

void main() {
  sqfliteFfiInit();
  sqflite.databaseFactory = databaseFactoryFfi;

  testWidgets('Expense app menampilkan layar autentikasi', (tester) async {
    await tester.pumpWidget(const ExpenseMockupApp());
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(AuthScreen), findsOneWidget);
  });
}
