import 'dart:math';

import '../data/question_bank.dart';
import '../models/question.dart';

/// Jedna runda: 3 pitanja iz iste kategorije, oba igrača odgovaraju na ista.
class DuelRound {
  DuelRound({required this.category, required this.questions})
      : playerAnswers = List.filled(questions.length, null),
        opponentAnswers = List.filled(questions.length, null);

  final String category;
  final List<Question> questions;

  /// Indeks izabranog odgovora; `null` znači da nije odgovoreno (vrijeme isteklo).
  final List<int?> playerAnswers;
  final List<int?> opponentAnswers;

  int get playerScore => _score(playerAnswers);
  int get opponentScore => _score(opponentAnswers);

  int _score(List<int?> answers) {
    var s = 0;
    for (var i = 0; i < questions.length; i++) {
      if (questions[i].isCorrect(answers[i])) s++;
    }
    return s;
  }
}

/// Meč: jedna runda po izabranoj kategoriji (6 rundi po 3 pitanja). Protivnik
/// za sada igra računar; u pravoj verziji njegove odgovore šalje server.
class DuelMatch {
  DuelMatch(
    this.bank, {
    required this.categories,
    Random? random,
    this.opponentSkill = 0.6,
  })  : random = random ?? Random(),
        assert(categories.length == roundsTotal);

  static const roundsTotal = 6;
  static const questionsPerRound = 3;

  final QuestionBank bank;
  final List<String> categories;
  final Random random;

  /// Vjerovatnoća da protivnik tačno odgovori na pojedino pitanje.
  final double opponentSkill;

  final List<DuelRound> rounds = [];
  final Set<int> _seen = {};
  int _answered = 0;

  bool get roundDone => rounds.isNotEmpty && _answered >= questionsPerRound;
  bool get finished => rounds.length == roundsTotal && roundDone;

  /// Indeks pitanja na koje igrač treba da odgovori u trenutnoj rundi.
  int get questionIndex => _answered;

  int get playerTotal => rounds.fold(0, (a, r) => a + r.playerScore);
  int get opponentTotal => rounds.fold(0, (a, r) => a + r.opponentScore);

  DuelRound get current => rounds.last;

  /// Počinje sljedeću rundu u izabranoj kategoriji.
  DuelRound startRound() {
    assert(rounds.length < roundsTotal);
    final category = categories[rounds.length];
    final questions = bank.draw(category, questionsPerRound, random, seen: _seen);
    _seen.addAll(questions.map((q) => q.id));
    final round = DuelRound(category: category, questions: questions);
    for (var i = 0; i < questions.length; i++) {
      round.opponentAnswers[i] = _opponentAnswer(questions[i]);
    }
    rounds.add(round);
    _answered = 0;
    return round;
  }

  /// Bilježi igračev odgovor na trenutno pitanje. Vraća da li je tačan.
  bool answer(int? index) {
    final q = current.questions[_answered];
    current.playerAnswers[_answered] = index;
    _answered++;
    return q.isCorrect(index);
  }

  int? _opponentAnswer(Question q) {
    if (random.nextDouble() < opponentSkill) return q.correctIndex;
    final wrong = [for (var i = 0; i < q.answers.length; i++) if (i != q.correctIndex) i];
    return wrong[random.nextInt(wrong.length)];
  }
}
