import 'package:flutter/material.dart';

class BeatIndicatorRow extends StatelessWidget {
  final int currentBeat;
  final int beatsPerBar;
  final int accentBeat;

  const BeatIndicatorRow({
    super.key,
    required this.currentBeat,
    required this.beatsPerBar,
    this.accentBeat = 1,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final inactive = const Color(0xFFD0D5DD);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(beatsPerBar, (index) {
        final beat = index + 1;
        final isAccent = beat == accentBeat;
        final isActive = beat == currentBeat;
        final color = isAccent ? primary : primary.withOpacity(0.8);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BeatDot(
                key: Key('beat-dot-$beat'),
                isActive: isActive,
                isAccent: isAccent,
                activeColor: color,
                inactiveColor: inactive,
              ),
              const SizedBox(height: 4),
              if (isAccent)
                const Text(
                  '强拍',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7380),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _BeatDot extends StatelessWidget {
  final bool isActive;
  final bool isAccent;
  final Color activeColor;
  final Color inactiveColor;

  const _BeatDot({
    super.key,
    required this.isActive,
    required this.isAccent,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = isAccent ? 14.0 : 12.0;
    final activeSize = isAccent ? 18.0 : 16.0;
    final dotSize = isActive ? activeSize : size;
    final fillColor = isActive ? activeColor : Colors.transparent;
    final borderColor = isActive ? activeColor : inactiveColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
    );
  }
}
