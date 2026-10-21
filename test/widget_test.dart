import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kviz_dvoboj/data/question_bank.dart';
import 'package:kviz_dvoboj/main.dart';

void main() {
  testWidgets('prolazak kroz celu partiju do rezultata', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    final json = jsonDecode(File('assets/pitanja/pitanja.json').readAsStringSync());
    final bank = QuestionBank.fromJson(json as Map<String, dynamic>);
    await tester.pumpWidget(KvizomanijaApp(bankLoader: () async => bank));
    await tester.pumpAndSettle();
    expect(find.text('Kvizomanija'), findsOneWidget);

    await tester.tap(find.text('Nova partija'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Započni partiju'));
    await tester.pumpAndSettle();
    expect(find.text('0/6'), findsOneWidget);

    // 7 kategorija ima pitanja; biramo prvih 6.
    for (final label in ['Opšte znanje', 'Istorija', 'Geografija', 'Nauka', 'Sport', 'Muzika']) {
      await tester.tap(find.textContaining(label));
      await tester.pump();
    }
    expect(find.text('6/6'), findsOneWidget);
    await tester.tap(find.text('Počni partiju'));
    await tester.pumpAndSettle();
    expect(find.text('Runda 1/6'), findsOneWidget);

    // 18 pitanja: odgovor na prvu ponuđenu opciju, pa "dalje", pa čekanje.
    for (var round = 0; round < 6; round++) {
      for (var q = 0; q < 3; q++) {
        final answer = find.byKey(const ValueKey('odgovor-0'));
        await tester.tap(answer);
        await tester.pump();
        await tester.tap(find.byType(FilledButton));
        await tester.pump();
      }
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(find.text('Rezultat partije'), findsOneWidget);
    expect(find.text('Povratak na početnu'), findsOneWidget);

    await tester.tap(find.text('Povratak na početnu'));
    await tester.pumpAndSettle();
    expect(find.text('Kvizomanija'), findsOneWidget);
  });
}
