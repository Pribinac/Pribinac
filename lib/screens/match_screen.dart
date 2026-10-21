import 'dart:async';

import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../data/categories.dart';
import '../data/demo_data.dart';
import '../game/duel.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'result_screen.dart';

enum _Phase { question, feedback, waiting }

class MatchScreen extends StatefulWidget {
  const MatchScreen({
    super.key,
    required this.opponent,
    required this.categories,
    this.questionSeconds = 20,
    this.waitDuration = const Duration(milliseconds: 1800),
  });

  final Player opponent;
  final List<String> categories;
  final int questionSeconds;

  /// Koliko traje ekran "Čeka se protivnik" (u pravoj verziji čeka se server).
  final Duration waitDuration;

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  late final DuelMatch _match = DuelMatch(BankScope.of(context), categories: widget.categories);
  Timer? _timer;
  _Phase _phase = _Phase.question;
  int _secondsLeft = 0;
  int? _chosen;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      _match.startRound();
      _armTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _armTimer() {
    _secondsLeft = widget.questionSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 1) {
        _answer(null);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _answer(int? index) {
    if (_phase != _Phase.question) return;
    _timer?.cancel();
    setState(() {
      _chosen = index;
      _phase = _Phase.feedback;
    });
    _match.answer(index);
  }

  void _next() {
    if (!_match.roundDone) {
      setState(() {
        _phase = _Phase.question;
        _chosen = null;
      });
      _armTimer();
      return;
    }
    setState(() => _phase = _Phase.waiting);
    Future.delayed(widget.waitDuration, () {
      if (!mounted) return;
      if (_match.finished) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => ResultScreen(match: _match, opponent: widget.opponent),
        ));
      } else {
        _match.startRound();
        setState(() {
          _phase = _Phase.question;
          _chosen = null;
        });
        _armTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final roundNo = _match.rounds.length;
    return Scaffold(
      appBar: AppBar(title: Text('Runda $roundNo/${DuelMatch.roundsTotal}')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ScoreHeader(match: _match, opponent: widget.opponent),
              const SizedBox(height: 16),
              Expanded(
                child: switch (_phase) {
                  _Phase.question => _question(),
                  _Phase.feedback => _feedback(),
                  _Phase.waiting => _waiting(),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _question() {
    final round = _match.current;
    final q = round.questions[_match.questionIndex];
    final cat = categoryByKey(round.category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _secondsLeft / widget.questionSeconds,
            minHeight: 6,
            color: AppColors.primary,
            backgroundColor: AppColors.border,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Icon(cat.icon, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(cat.label, overflow: TextOverflow.ellipsis)),
            Text('Pitanje ${_match.questionIndex + 1}/${DuelMatch.questionsPerRound}',
                style: const TextStyle(color: AppColors.muted)),
          ],
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Text(q.text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                    child: OutlineCard(
                      key: ValueKey('odgovor-$i'),
                      onTap: () => _answer(i),
                      child: Center(
                        child: Text(q.answers[i],
                            textAlign: TextAlign.center, style: const TextStyle(fontSize: 17)),
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

  Widget _feedback() {
    final q = _match.current.questions[_match.questionIndex - 1];
    final correct = q.isCorrect(_chosen);
    final color = correct ? AppColors.green : AppColors.red;
    final title = _chosen == null
        ? 'Vreme je isteklo'
        : correct
            ? 'Tačan odgovor!'
            : 'Netačan odgovor';
    final last = _match.roundDone;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Icon(correct ? Icons.check_circle_outline : Icons.highlight_off, size: 110, color: color),
        const SizedBox(height: 16),
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        if (!correct) ...[
          const SizedBox(height: 12),
          Text('Tačan odgovor: ${q.answers[q.correctIndex]}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: AppColors.muted)),
        ],
        const Spacer(),
        FilledButton(onPressed: _next, child: Text(last ? 'Završi rundu' : 'Sljedeće pitanje')),
      ],
    );
  }

  Widget _waiting() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.hourglass_bottom, size: 90, color: AppColors.gold),
        const SizedBox(height: 16),
        const Text('Čeka se protivnik',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Tvoj odgovor je poslat.', style: TextStyle(color: AppColors.muted)),
        const Text('Protivnik je na potezu.', style: TextStyle(color: AppColors.muted)),
      ],
    );
  }
}

class _ScoreHeader extends StatelessWidget {
  const _ScoreHeader({required this.match, required this.opponent});

  final DuelMatch match;
  final Player opponent;

  @override
  Widget build(BuildContext context) {
    final completed = match.rounds.length - (match.roundDone ? 0 : 1);
    return OutlineCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Column(
            children: [
              Avatar(me.name, size: 40, color: AppColors.me),
              Text(me.name, style: const TextStyle(fontSize: 11, color: AppColors.me)),
            ],
          ),
          const SizedBox(width: 12),
          Text('${match.playerTotal}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.me)),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < DuelMatch.roundsTotal; i++)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < completed ? AppColors.primary : AppColors.border,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Text('${match.opponentTotal}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.opponent)),
          const SizedBox(width: 12),
          Column(
            children: [
              Avatar(opponent.name, size: 40, color: AppColors.opponent),
              Text(opponent.name, style: const TextStyle(fontSize: 11, color: AppColors.opponent)),
            ],
          ),
        ],
      ),
    );
  }
}
