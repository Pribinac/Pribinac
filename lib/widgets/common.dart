import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../theme.dart';

class Avatar extends StatelessWidget {
  const Avatar(this.name, {super.key, this.size = 44, this.color = AppColors.primary, this.online});

  final String name;
  final double size;
  final Color color;

  /// `null` = bez statusa, inače zelena/narandžasta tačkica.
  final bool? online;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            name.characters.first.toUpperCase(),
            style: TextStyle(fontSize: size * 0.42, fontWeight: FontWeight.bold, color: color),
          ),
        ),
        if (online != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.26,
              height: size * 0.26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: online! ? AppColors.green : AppColors.orange,
                border: Border.all(color: AppColors.bg, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

/// Zaobljena kartica sa tankim obrubom, kao u dizajnu.
class OutlineCard extends StatelessWidget {
  const OutlineCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderColor = AppColors.border,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color borderColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ),
    );
  }
}

class PlayerTile extends StatelessWidget {
  const PlayerTile(this.player, {super.key, required this.onChallenge});

  final Player player;
  final VoidCallback onChallenge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Avatar(player.name, online: player.online),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(player.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text('Nivo ${player.level} | ${player.wins} pobeda',
                    style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
          SizedBox(
            width: 92,
            height: 38,
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: Size.zero,
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              onPressed: onChallenge,
              child: const Text('Izazovi'),
            ),
          ),
        ],
      ),
    );
  }
}
