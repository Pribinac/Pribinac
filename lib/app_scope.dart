import 'package:flutter/widgets.dart';

import 'data/question_bank.dart';

/// Daje ekranima pristup učitanoj bazi pitanja.
class BankScope extends InheritedWidget {
  const BankScope({super.key, required this.bank, required super.child});

  final QuestionBank bank;

  static QuestionBank of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BankScope>()!.bank;

  @override
  bool updateShouldNotify(BankScope old) => bank != old.bank;
}
