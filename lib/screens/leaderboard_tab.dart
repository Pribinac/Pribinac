import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../theme.dart';
import '../widgets/common.dart';

class LeaderboardTab extends StatefulWidget {
  const LeaderboardTab({super.key});

  @override
  State<LeaderboardTab> createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends State<LeaderboardTab> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    const filters = ['Ukupno', 'Prijatelji', 'Nedeljno'];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Rang-lista',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        Row(
          children: [
            for (var i = 0; i < filters.length; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: ChoiceChip(
                    showCheckmark: false,
                    label: SizedBox(width: double.infinity, child: Text(filters[i], textAlign: TextAlign.center)),
                    selected: _filter == i,
                    selectedColor: AppColors.primary,
                    onSelected: (_) => setState(() => _filter = i),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < leaderboard.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: i == 0
                      ? const Icon(Icons.workspace_premium, color: AppColors.gold)
                      : Text('${i + 1}', style: const TextStyle(color: AppColors.muted, fontSize: 16)),
                ),
                const SizedBox(width: 8),
                Avatar(leaderboard[i].$1, size: 36),
                const SizedBox(width: 12),
                Expanded(child: Text(leaderboard[i].$1, style: const TextStyle(fontSize: 16))),
                Text('${leaderboard[i].$2}', style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        const SizedBox(height: 8),
        const Text('Probni podaci.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
      ],
    );
  }
}
