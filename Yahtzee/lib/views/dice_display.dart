import 'package:flutter/material.dart';
import '../models/dice.dart';
import 'dice_painter.dart';

class DiceDisplay extends StatelessWidget {
  final Dice dice;
  final void Function(int) onToggleHold;

  DiceDisplay({required this.dice, required this.onToggleHold});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: List.generate(dice.values.length, (index) {
        final value = dice.values[index];
        final isHeld = dice.isHeld(index);

        return GestureDetector(
          onTap: () => onToggleHold(index),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 70,
            height: 70,
            child: CustomPaint(
              painter: DicePainter(value: value, isHeld: isHeld),
            ),
          ),
        );
      }),
    );
  }
}