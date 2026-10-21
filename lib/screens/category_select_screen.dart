import 'package:flutter/material.dart';

import '../data/categories.dart';
import '../data/demo_data.dart';
import '../game/duel.dart';
import '../theme.dart';
import 'match_screen.dart';

class CategorySelectScreen extends StatefulWidget {
  const CategorySelectScreen({super.key, required this.opponent, required this.deadlineHours});

  final Player opponent;
  final int deadlineHours;

  @override
  State<CategorySelectScreen> createState() => _CategorySelectScreenState();
}

class _CategorySelectScreenState extends State<CategorySelectScreen> {
  final List<String> _picked = [];

  void _toggle(QuizCategory c) {
    setState(() {
      if (!_picked.remove(c.key) && _picked.length < DuelMatch.roundsTotal) _picked.add(c.key);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ready = _picked.length == DuelMatch.roundsTotal;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izaberi kategorije'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(label: Text('${_picked.length}/${DuelMatch.roundsTotal}')),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('Izaberi 6 kategorija za ovu partiju',
                  style: TextStyle(color: AppColors.muted)),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (var i = 0; i < allCategories.length; i++) _tile(i, allCategories[i]),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  const Text('Kategorije sa oznakom "uskoro" još nemaju pitanja.',
                      style: TextStyle(color: AppColors.muted, fontSize: 12)),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: ready
                        ? () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => MatchScreen(
                                opponent: widget.opponent,
                                categories: List.of(_picked),
                              ),
                            ))
                        : null,
                    child: const Text('Počni partiju'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(int i, QuizCategory c) {
    final selected = _picked.contains(c.key);
    final enabled = c.hasQuestions;
    final color = !enabled
        ? AppColors.border
        : selected
            ? AppColors.primary
            : AppColors.orange;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Material(
        color: selected ? AppColors.primary.withValues(alpha: 0.25) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: enabled ? () => _toggle(c) : null,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: selected ? 2 : 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(c.icon, size: 28),
                const SizedBox(height: 6),
                Text('${i + 1}. ${c.label}',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12)),
                if (!enabled)
                  const Text('uskoro', style: TextStyle(fontSize: 10, color: AppColors.muted)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
