import 'dart:math';

import '../data/question_bank.dart';
import '../models/question.dart';

/// Jedna runda: 3 pitanja iz iste kategorije, oba igrača odgovaraju na ista.
class DuelRound {
  DuelRound({required this.category, required this.questions, required this.pickedByPlayer})
      : playerAnswers = List.filled(questions.length, null),
        botAnswers = List.filled(questions.length, null);

  final String category;
  final List<Question> questions;
  final bool pickedByPlayer;

  /// Indeks izabranog odgovora; `null` znači da nije odgovoreno (vreme isteklo).
  final List<int?> playerAnswers;
  final List<int?> botAnswers;

  int get playerScore => _score(playerAnswers);
  int get botScore => _score(botAnswers);

  int _score(List<int?> answers) {
    var s = 0;
    for (var i = 0; i < questions.length; i++) {
      if (questions[i].isCorrect(answers[i])) s++;
    }
    return s;
  }
}

/// Meč protiv računara: 6 rundi po 3 pitanja. Igrač bira kategoriju u
/// rundama 1, 3 i 5, računar u 2, 4 i 6.
class DuelMatch {
  DuelMatch(this.bank, {Random? random, this.botSkill = 0.6})
      : random = random ?? Random();

  static const roundsTotal = 6;
  static const questionsPerRound = 3;

  final QuestionBank bank;
  final Random random;

  /// Verovatnoća da računar tačno odgovori na pojedino pitanje.
  final double botSkill;

  final List<DuelRound> rounds = [];
  final Set<int> _seen = {};

  int _answered = 0;

  bool get roundDone => rounds.isNotEmpty && _answered >= questionsPerRound;
  bool get finished => rounds.length == roundsTotal && roundDone;

  /// Indeks pitanja na koje igrač treba da odgovori u trenutnoj rundi.
  int get questionIndex => _answered;

  /// Da li igrač bira kategoriju u sledećoj rundi.
  bool get playerPicksNext => rounds.length.isEven;

  int get playerTotal => rounds.fold(0, (a, r) => a + r.playerScore);
  int get botTotal => rounds.fold(0, (a, r) => a + r.botScore);

  DuelRound get current => rounds.last;

  List<String> categoryOptions() => bank.randomCategories(random);

  /// Za rundu koju bira računar, bira nasumično jednu od ponuđenih kategorija.
  String botPickCategory() {
    final options = categoryOptions();
    return options[random.nextInt(options.length)];
  }

  DuelRound startRound(String category) {
    assert(rounds.length < roundsTotal);
    final questions = bank.draw(category, questionsPerRound, random, seen: _seen);
    _seen.addAll(questions.map((q) => q.id));
    final round = DuelRound(
      category: category,
      questions: questions,
      pickedByPlayer: playerPicksNext,
    );
    for (var i = 0; i < questions.length; i++) {
      round.botAnswers[i] = _botAnswer(questions[i]);
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

  int? _botAnswer(Question q) {
    if (random.nextDouble() < botSkill) return q.correctIndex;
    final wrong = [for (var i = 0; i < q.answers.length; i++) if (i != q.correctIndex) i];
    return wrong[random.nextInt(wrong.length)];
  }
}
