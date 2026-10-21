import 'package:flutter/material.dart';

class QuizCategory {
  const QuizCategory(this.key, this.label, this.icon, {this.hasQuestions = false});

  /// Ključ iz `pitanja.json`; kategorije bez pitanja se ne mogu izabrati.
  final String key;
  final String label;
  final IconData icon;
  final bool hasQuestions;
}

/// 18 kategorija iz dizajna. Samo one sa `hasQuestions` imaju pitanja u bazi.
const allCategories = <QuizCategory>[
  QuizCategory('opste', 'Opšte znanje', Icons.lightbulb_outline, hasQuestions: true),
  QuizCategory('istorija', 'Istorija', Icons.account_balance_outlined, hasQuestions: true),
  QuizCategory('geografija', 'Geografija', Icons.public, hasQuestions: true),
  QuizCategory('srbija', 'Srbija', Icons.flag_outlined),
  QuizCategory('hrvatska', 'Hrvatska', Icons.flag_outlined),
  QuizCategory('bih', 'BiH', Icons.flag_outlined),
  QuizCategory('crna_gora', 'Crna Gora', Icons.flag_outlined),
  QuizCategory('svijet', 'Svijet', Icons.travel_explore),
  QuizCategory('priroda', 'Priroda', Icons.eco_outlined),
  QuizCategory('nauka', 'Nauka', Icons.science_outlined, hasQuestions: true),
  QuizCategory('tehnologija', 'Tehnologija', Icons.memory),
  QuizCategory('sport', 'Sport', Icons.sports_soccer, hasQuestions: true),
  QuizCategory('muzika', 'Muzika', Icons.music_note_outlined, hasQuestions: true),
  QuizCategory('film', 'Film i serije', Icons.movie_outlined, hasQuestions: true),
  QuizCategory('umjetnost', 'Umjetnost', Icons.palette_outlined),
  QuizCategory('knjizevnost', 'Književnost', Icons.menu_book_outlined),
  QuizCategory('visoka_kultura', 'Visoka kultura', Icons.theater_comedy_outlined),
  QuizCategory('biznis', 'Biznis', Icons.work_outline),
];

QuizCategory categoryByKey(String key) =>
    allCategories.firstWhere((c) => c.key == key, orElse: () => allCategories.first);
