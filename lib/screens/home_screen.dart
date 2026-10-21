import 'package:flutter/material.dart';

import '../data/question_bank.dart';
import 'match_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.bankLoader});

  /// Omogućava testovima da podmetnu bazu pitanja.
  final Future<QuestionBank> Function()? bankLoader;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<QuestionBank> _bank = (widget.bankLoader ?? QuestionBank.load)();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FutureBuilder<QuestionBank>(
              future: _bank,
              builder: (context, snap) {
                if (snap.hasError) {
                  return Text('Greška pri učitavanju pitanja:\n${snap.error}',
                      textAlign: TextAlign.center);
                }
                final bank = snap.data;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.psychology_alt, size: 96, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text('Kviz Dvoboj',
                        style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      bank == null ? 'Učitavanje pitanja...' : '${bank.total} pitanja',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 40),
                    FilledButton.icon(
                      onPressed: bank == null
                          ? null
                          : () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => MatchScreen(bank: bank)),
                              ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        child: Text('Nova igra', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
