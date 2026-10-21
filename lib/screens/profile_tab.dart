import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../theme.dart';
import '../widgets/common.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    Widget stat(IconData icon, String value, String label, Color color) => Expanded(
          child: OutlineCard(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Column(
              children: [
                Icon(icon, color: color),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: AppColors.muted)),
              ],
            ),
          ),
        );
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Moj profil',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
        Row(
          children: [
            const Avatar('Marko85', size: 72, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(me.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Nivo ${me.level}', style: const TextStyle(color: AppColors.muted)),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 320 / 500,
                      minHeight: 6,
                      color: AppColors.primary,
                      backgroundColor: AppColors.border,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text('320 / 500 XP', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            stat(Icons.workspace_premium, '124', 'Pobede', AppColors.gold),
            const SizedBox(width: 8),
            stat(Icons.bar_chart, '87', 'Odigranih partija', AppColors.me),
            const SizedBox(width: 8),
            stat(Icons.gps_fixed, '78%', 'Uspešnost', AppColors.primary),
            const SizedBox(width: 8),
            stat(Icons.local_fire_department, '12', 'Serija pobeda', AppColors.orange),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Omiljene kategorije', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Row(
          children: [
            stat(Icons.sports_soccer, 'Sport', '', AppColors.muted),
            const SizedBox(width: 8),
            stat(Icons.public, 'Geografija', '', AppColors.muted),
            const SizedBox(width: 8),
            stat(Icons.account_balance_outlined, 'Istorija', '', AppColors.muted),
            const SizedBox(width: 8),
            stat(Icons.music_note_outlined, 'Muzika', '', AppColors.muted),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Probni podaci.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
      ],
    );
  }
}
