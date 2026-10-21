import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/question.dart';

/// Baza pitanja učitana iz `assets/pitanja/pitanja.json`.
class QuestionBank {
  QuestionBank._(this.categoryNames, this._byCategory);

  /// Ključ kategorije -> prikazno ime (npr. `opste` -> `Opšte znanje`).
  final Map<String, String> categoryNames;
  final Map<String, List<_Raw>> _byCategory;

  static const assetPath = 'assets/pitanja/pitanja.json';

  static Future<QuestionBank> load([AssetBundle? bundle]) async {
    final json = await (bundle ?? rootBundle).loadString(assetPath);
    return QuestionBank.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  factory QuestionBank.fromJson(Map<String, dynamic> json) {
    final names = Map<String, String>.from(json['kategorije'] as Map);
    final byCategory = {for (final k in names.keys) k: <_Raw>[]};
    for (final p in json['pitanja'] as List) {
      final m = p as Map<String, dynamic>;
      byCategory[m['kategorija']]?.add(_Raw(
        id: m['id'] as int,
        text: m['pitanje'] as String,
        correct: m['tacan'] as String,
        wrong: List<String>.from(m['netacni'] as List),
      ));
    }
    return QuestionBank._(names, byCategory);
  }

  int get total => _byCategory.values.fold(0, (a, b) => a + b.length);

  int countIn(String category) => _byCategory[category]?.length ?? 0;

  /// Vuče [count] nasumičnih pitanja iz kategorije, preskačući već viđena
  /// (`seen`). Ako nestane novih, ponavlja stara umesto da padne.
  List<Question> draw(
    String category,
    int count,
    Random random, {
    Set<int> seen = const {},
  }) {
    final all = _byCategory[category] ?? const <_Raw>[];
    final fresh = all.where((q) => !seen.contains(q.id)).toList()..shuffle(random);
    final pool = fresh.length >= count
        ? fresh
        : [...fresh, ...(all.where((q) => seen.contains(q.id)).toList()..shuffle(random))];
    return [for (final q in pool.take(count)) q.toQuestion(category, random)];
  }
}

class _Raw {
  _Raw({required this.id, required this.text, required this.correct, required this.wrong});

  final int id;
  final String text;
  final String correct;
  final List<String> wrong;

  Question toQuestion(String category, Random random) {
    final answers = [correct, ...wrong]..shuffle(random);
    return Question(
      id: id,
      category: category,
      text: text,
      answers: answers,
      correctIndex: answers.indexOf(correct),
    );
  }
}
