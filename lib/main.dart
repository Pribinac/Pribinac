import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'data/question_bank.dart';
import 'screens/shell.dart';
import 'theme.dart';

void main() {
  runApp(const KvizomanijaApp());
}

class KvizomanijaApp extends StatefulWidget {
  const KvizomanijaApp({super.key, this.bankLoader});

  /// Omogućava testovima da podmetnu bazu pitanja.
  final Future<QuestionBank> Function()? bankLoader;

  @override
  State<KvizomanijaApp> createState() => _KvizomanijaAppState();
}

class _KvizomanijaAppState extends State<KvizomanijaApp> {
  late final Future<QuestionBank> _bank = (widget.bankLoader ?? QuestionBank.load)();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuestionBank>(
      future: _bank,
      builder: (context, snap) {
        final bank = snap.data;
        return MaterialApp(
          title: 'Kvizomanija',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          // BankScope mora biti iznad Navigatora da bi ga videli i ekrani
          // koji se otvaraju preko Shell-a.
          builder: bank == null ? null : (context, child) => BankScope(bank: bank, child: child!),
          home: snap.hasError
              ? Scaffold(body: Center(child: Text('Greška pri učitavanju pitanja:\n${snap.error}')))
              : bank == null
                  ? const Scaffold(body: Center(child: CircularProgressIndicator()))
                  : const Shell(),
        );
      },
    );
  }
}
