import 'package:flutter/material.dart';

class PulseIndicator extends StatelessWidget {
  final int pulseTick;
  final bool isAccent;

  const PulseIndicator({
    super.key,
    required this.pulseTick,
    required this.isAccent,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final color = isAccent ? primary : primary.withOpacity(0.85);

    return TweenAnimationBuilder<double>(
      key: ValueKey(pulseTick),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final scale = 1.0 + (isAccent ? 0.12 : 0.07) * (1 - value);
        final glow = (isAccent ? 0.28 : 0.18) * (1 - value);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12 + glow),
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(glow),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
