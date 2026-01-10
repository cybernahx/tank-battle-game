import 'package:flutter/material.dart';

class HealthBar extends StatelessWidget {
  final int health;
  final int maxHealth;

  const HealthBar({
    super.key,
    required this.health,
    this.maxHealth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxHealth, (index) {
        final isFilled = index < health;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            isFilled ? Icons.favorite : Icons.favorite_border,
            color: isFilled ? Colors.red : Colors.grey,
            size: 28,
            shadows: isFilled
                ? [const Shadow(color: Colors.redAccent, blurRadius: 8)]
                : null,
          ),
        );
      }),
    );
  }
}
