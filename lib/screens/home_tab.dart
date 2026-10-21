import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'category_select_screen.dart';
import 'find_opponent_screen.dart';
import 'new_game_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    void push(Widget w) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      children: [
        const SizedBox(height: 24),
        const Icon(Icons.workspace_premium, size: 64, color: AppColors.primary),
        const SizedBox(height: 8),
        const Text('Kvizomanija',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Znanje je igra.',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: AppColors.muted)),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: () => push(const NewGameScreen()),
          child: const Row(
            children: [
              Icon(Icons.play_arrow),
              Expanded(child: Text('Nova partija', textAlign: TextAlign.center)),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _MenuButton(
          icon: Icons.group_outlined,
          label: 'Igraj sa prijateljem',
          onTap: () => push(FindOpponentScreen(
            onPicked: (ctx, p) => Navigator.of(ctx).push(
              MaterialPageRoute(builder: (_) => CategorySelectScreen(opponent: p, deadlineHours: 48)),
            ),
          )),
        ),
        _MenuButton(
          icon: Icons.event_outlined,
          label: 'Dnevni izazov',
          onTap: () => push(CategorySelectScreen(opponent: randomOpponent, deadlineHours: 24)),
        ),
        _MenuButton(
          icon: Icons.format_list_bulleted,
          label: 'Moje partije',
          badge: 3,
          onTap: () => onOpenTab(1),
        ),
        _MenuButton(icon: Icons.emoji_events_outlined, label: 'Rang-lista', onTap: () => onOpenTab(2)),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.icon, required this.label, required this.onTap, this.badge});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: OutlineCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
            if (badge != null)
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primary,
                child: Text('$badge', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}
