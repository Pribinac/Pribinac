import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../theme.dart';
import '../widgets/common.dart';

class FindOpponentScreen extends StatelessWidget {
  const FindOpponentScreen({super.key, required this.onPicked});

  /// Poziva se kad igrač pritisne "Izazovi"; dobija kontekst ovog ekrana.
  final void Function(BuildContext context, Player player) onPicked;

  @override
  Widget build(BuildContext context) {
    Widget header(String t) => Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 4),
          child: Text(t, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        );
    return Scaffold(
      appBar: AppBar(title: const Text('Pronađi protivnika')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Pretraži igrače po imenu...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            header('Predloženi igrači'),
            for (final p in suggestedPlayers.where((p) => p.name != me.name))
              PlayerTile(p, onChallenge: () => onPicked(context, p)),
            header('Tvoji prijatelji'),
            for (final p in friends) PlayerTile(p, onChallenge: () => onPicked(context, p)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('Igrači su probni podaci. Pravi protivnici dolaze uz server.',
                  style: TextStyle(color: AppColors.muted, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
