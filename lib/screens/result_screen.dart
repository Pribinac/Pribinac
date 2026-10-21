import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../game/duel.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'category_select_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.match, required this.opponent});

  final DuelMatch match;
  final Player opponent;

  @override
  Widget build(BuildContext context) {
    final p = match.playerTotal;
    final o = match.opponentTotal;
    final questions = DuelMatch.roundsTotal * DuelMatch.questionsPerRound;
    final title = p > o ? 'Pobjeda!' : p < o ? 'Poraz' : 'Neriješeno';
    final accuracy = (p * 100 / questions).round();
    return Scaffold(
      appBar: AppBar(title: const Text('Rezultat partije'), automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(Icons.emoji_events, size: 90, color: p >= o ? AppColors.gold : AppColors.muted),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _side(me.name, p, AppColors.me),
                  _side(opponent.name, o, AppColors.opponent),
                ],
              ),
              const SizedBox(height: 24),
              OutlineCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _stat('${DuelMatch.roundsTotal}', 'rundi'),
                    _stat('$questions', 'pitanja'),
                    _stat('$accuracy%', 'tačnih'),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Igraj ponovo'),
                onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => CategorySelectScreen(opponent: opponent, deadlineHours: 48),
                )),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  side: const BorderSide(color: AppColors.border),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Povratak na početnu'),
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _side(String name, int score, Color color) => Column(
        children: [
          Avatar(name, size: 64, color: color),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontSize: 15)),
          Text('$score', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: color)),
        ],
      );

  Widget _stat(String value, String label) => Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        ],
      );
}
