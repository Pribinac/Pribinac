import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'category_select_screen.dart';
import 'find_opponent_screen.dart';

enum _Mode { friend, random, daily }

class NewGameScreen extends StatefulWidget {
  const NewGameScreen({super.key});

  @override
  State<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  _Mode _mode = _Mode.random;
  int _hours = 48;

  void _start() {
    final nav = Navigator.of(context);
    void toCategories(Player p, int hours) => nav.push(MaterialPageRoute(
        builder: (_) => CategorySelectScreen(opponent: p, deadlineHours: hours)));
    switch (_mode) {
      case _Mode.friend:
        nav.push(MaterialPageRoute(
          builder: (_) => FindOpponentScreen(
            onPicked: (ctx, p) => Navigator.of(ctx).push(MaterialPageRoute(
                builder: (_) => CategorySelectScreen(opponent: p, deadlineHours: _hours))),
          ),
        ));
      case _Mode.random:
        toCategories(randomOpponent, _hours);
      case _Mode.daily:
        toCategories(randomOpponent, 24);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova partija')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _option(_Mode.friend, Icons.group_outlined, 'Izazovi prijatelja', 'Igraj sa nekim koga znaš'),
              _option(_Mode.random, Icons.shuffle, 'Nasumični protivnik', 'Pronađi protivnika sličnog nivoa'),
              _option(_Mode.daily, Icons.event_outlined, 'Dnevni izazov', 'Svaki dan novo takmičenje'),
              const SizedBox(height: 16),
              const Text('Rok za odigravanje', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (final h in const [24, 48, 72])
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: OutlineCard(
                          onTap: () => setState(() => _hours = h),
                          borderColor: _hours == h ? AppColors.primary : AppColors.border,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Column(
                            children: [
                              Icon(_hours == h ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: _hours == h ? AppColors.primary : AppColors.muted),
                              const SizedBox(height: 6),
                              Text('$h ${h == 24 ? 'sata' : 'sati'}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              FilledButton(onPressed: _start, child: const Text('Započni partiju')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _option(_Mode mode, IconData icon, String title, String subtitle) {
    final selected = _mode == mode;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OutlineCard(
        onTap: () => setState(() => _mode = mode),
        borderColor: selected ? AppColors.primary : AppColors.border,
        child: Row(
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}
