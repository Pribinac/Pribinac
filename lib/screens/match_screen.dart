import 'dart:async';

import 'package:flutter/material.dart';

import '../data/question_bank.dart';
import '../game/duel.dart';

enum _Phase { pickCategory, botPicked, question, roundResult, finalResult }

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key, required this.bank, this.questionSeconds = 20});

  final QuestionBank bank;
  final int questionSeconds;

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  late final DuelMatch _match = DuelMatch(widget.bank);
  Timer? _timer;
  late _Phase _phase;
  late List<String> _options;
  int _secondsLeft = 0;
  int? _chosen;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _beginRound();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _beginRound() {
    if (_match.playerPicksNext) {
      _options = _match.categoryOptions();
      _phase = _Phase.pickCategory;
    } else {
      _options = [_match.botPickCategory()];
      _phase = _Phase.botPicked;
    }
  }

  void _startRound(String category) {
    _match.startRound(category);
    _showQuestion();
  }

  void _showQuestion() {
    setState(() {
      _phase = _Phase.question;
      _chosen = null;
      _locked = false;
      _secondsLeft = widget.questionSeconds;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        _answer(null);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _answer(int? index) {
    if (_locked) return;
    _timer?.cancel();
    setState(() {
      _locked = true;
      _chosen = index;
      if (index == null) _secondsLeft = 0;
    });
    _match.answer(index);
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      if (_match.roundDone) {
        setState(() => _phase = _match.finished ? _Phase.finalResult : _Phase.roundResult);
      } else {
        _showQuestion();
      }
    });
  }

  void _nextRound() {
    setState(_beginRound);
  }

  String _name(String key) => widget.bank.categoryNames[key] ?? key;

  @override
  Widget build(BuildContext context) {
    final roundLabel = 'Runda ${_match.rounds.length + (_phase == _Phase.pickCategory || _phase == _Phase.botPicked ? 1 : 0)} / ${DuelMatch.roundsTotal}';
    return Scaffold(
      appBar: AppBar(
        title: Text(_phase == _Phase.finalResult ? 'Kraj meča' : roundLabel),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('Ti ${_match.playerTotal} : ${_match.botTotal} Računar',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: switch (_phase) {
            _Phase.pickCategory => _buildPick(),
            _Phase.botPicked => _buildBotPicked(),
            _Phase.question => _buildQuestion(),
            _Phase.roundResult => _buildRoundResult(),
            _Phase.finalResult => _buildFinal(),
          },
        ),
      ),
    );
  }

  Widget _buildPick() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Izaberi kategoriju',
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 24),
        for (final key in _options)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FilledButton.tonal(
              onPressed: () => _startRound(key),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Text(_name(key), style: const TextStyle(fontSize: 20)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBotPicked() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Računar je izabrao kategoriju',
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(_name(_options.first),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: () => _startRound(_options.first),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Kreni', style: TextStyle(fontSize: 20)),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestion() {
    final round = _match.current;
    final q = round.questions[_match.questionIndex];
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('${_name(round.category)} · pitanje ${_match.questionIndex + 1} / ${DuelMatch.questionsPerRound}',
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        LinearProgressIndicator(value: _secondsLeft / widget.questionSeconds, minHeight: 8),
        const SizedBox(height: 4),
        Align(alignment: Alignment.centerRight, child: Text('$_secondsLeft s')),
        const SizedBox(height: 16),
        Expanded(
          flex: 2,
          child: Center(
            child: Text(q.text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              for (var i = 0; i < q.answers.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: !_locked
                              ? scheme.secondaryContainer
                              : i == q.correctIndex
                                  ? Colors.green.shade700
                                  : i == _chosen
                                      ? Colors.red.shade700
                                      : scheme.secondaryContainer.withValues(alpha: 0.4),
                          foregroundColor: !_locked ? scheme.onSecondaryContainer : Colors.white,
                        ),
                        onPressed: _locked ? null : () => _answer(i),
                        child: Text(q.answers[i], textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _marks(List<int?> answers, DuelRound round) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < round.questions.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              round.questions[i].isCorrect(answers[i]) ? Icons.check_circle : Icons.cancel,
              color: round.questions[i].isCorrect(answers[i]) ? Colors.green : Colors.red,
              size: 36,
            ),
          ),
      ],
    );
  }

  Widget _buildRoundResult() {
    final round = _match.current;
    final style = Theme.of(context).textTheme.titleMedium;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Rezultat runde · ${_name(round.category)}',
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        Text('Ti', textAlign: TextAlign.center, style: style),
        const SizedBox(height: 8),
        _marks(round.playerAnswers, round),
        const SizedBox(height: 24),
        Text('Računar', textAlign: TextAlign.center, style: style),
        const SizedBox(height: 8),
        _marks(round.botAnswers, round),
        const SizedBox(height: 40),
        FilledButton(
          onPressed: _nextRound,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Sledeća runda', style: TextStyle(fontSize: 20)),
          ),
        ),
      ],
    );
  }

  Widget _buildFinal() {
    final p = _match.playerTotal;
    final b = _match.botTotal;
    final title = p > b ? 'Pobedio si!' : p < b ? 'Poraz' : 'Nerešeno';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text('Ti $p : $b Računar',
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 40),
        FilledButton(
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => MatchScreen(bank: widget.bank)),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Revanš', style: TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Text('Glavni meni', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}
