import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const KvizDvobojApp());
}

class KvizDvobojApp extends StatelessWidget {
  const KvizDvobojApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kviz Dvoboj',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B2A86),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
