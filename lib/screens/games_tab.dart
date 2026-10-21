import 'package:flutter/material.dart';

import '../theme.dart';

class GamesTab extends StatelessWidget {
  const GamesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_esports_outlined, size: 64, color: AppColors.muted),
            SizedBox(height: 16),
            Text('Moje partije', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              'Ovdje će biti tvoje aktivne partije sa pravim protivnicima. '
              'Za to je potreban server, koji dolazi u sljedećem koraku.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
