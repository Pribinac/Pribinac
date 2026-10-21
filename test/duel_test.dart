import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kviz_dvoboj/data/question_bank.dart';
import 'package:kviz_dvoboj/game/duel.dart';

QuestionBank loadBank() {
  final json = jsonDecode(File('assets/pitanja/pitanja.json').readAsStringSync());
  return QuestionBank.fromJson(json as Map<String, dynamic>);
}

void main() {
  final bank = loadBank();

  test('baza ima bar 1000 pitanja i svaka kategorija je popunjena', () {
    expect(bank.total, greaterThanOrEqualTo(1000));
    for (final k in bank.categoryNames.keys) {
      expect(bank.countIn(k), greaterThan(50), reason: k);
    }
  });

  test('tačan odgovor je uvek na označenom indeksu i odgovori su različiti', () {
    final random = Random(1);
    for (final k in bank.categoryNames.keys) {
      for (final q in bank.draw(k, 40, random)) {
        expect(q.answers.length, 4);
        expect(q.answers.toSet().length, 4);
        expect(q.correctIndex, inInclusiveRange(0, 3));
      }
    }
  });

  test('meč ima 6 rundi po 3 pitanja, bez ponavljanja pitanja', () {
    final match = DuelMatch(bank, random: Random(7));
    final seen = <int>{};
    while (!match.finished) {
      final cat = match.playerPicksNext
          ? match.categoryOptions().first
          : match.botPickCategory();
      final round = match.startRound(cat);
      expect(round.pickedByPlayer, match.rounds.length.isOdd);
      for (final q in round.questions) {
        expect(seen.add(q.id), isTrue);
        match.answer(q.correctIndex);
      }
      expect(match.roundDone, isTrue);
    }
    expect(match.rounds.length, 6);
    expect(match.playerTotal, 18);
    expect(match.botTotal, lessThanOrEqualTo(18));
  });

  test('isteklo vreme (null) ne donosi poene', () {
    final match = DuelMatch(bank, random: Random(3));
    match.startRound(match.categoryOptions().first);
    for (var i = 0; i < 3; i++) {
      expect(match.answer(null), isFalse);
    }
    expect(match.playerTotal, 0);
  });

  test('računar sa veštinom 1.0 uvek pogađa, sa 0.0 nikad', () {
    final good = DuelMatch(bank, random: Random(5), botSkill: 1);
    good.startRound(good.categoryOptions().first);
    expect(good.botTotal, 3);
    final bad = DuelMatch(bank, random: Random(5), botSkill: 0);
    bad.startRound(bad.categoryOptions().first);
    expect(bad.botTotal, 0);
  });
}
