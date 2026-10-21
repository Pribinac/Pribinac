import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kviz_dvoboj/data/question_bank.dart';
import 'package:kviz_dvoboj/screens/home_screen.dart';

void main() {
  testWidgets('početni ekran prikazuje broj pitanja i pokreće meč', (tester) async {
    final json = jsonDecode(File('assets/pitanja/pitanja.json').readAsStringSync());
    final bank = QuestionBank.fromJson(json as Map<String, dynamic>);
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(bankLoader: () async => bank),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Kviz Dvoboj'), findsOneWidget);
    expect(find.text('${bank.total} pitanja'), findsOneWidget);

    await tester.tap(find.text('Nova igra'));
    await tester.pumpAndSettle();
    expect(find.text('Izaberi kategoriju'), findsOneWidget);
    expect(find.text('Runda 1 / 6'), findsOneWidget);
  });
}
