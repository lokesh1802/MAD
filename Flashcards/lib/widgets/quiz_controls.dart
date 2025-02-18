import 'package:flutter/material.dart';

class QuizControls extends StatelessWidget {
  final VoidCallback onShowAnswer;
  final VoidCallback onNextCard;
  final VoidCallback onPreviousCard;
  final bool showAnswer;

  QuizControls({
    required this.onShowAnswer,
    required this.onNextCard,
    required this.onPreviousCard,
    required this.showAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onShowAnswer,
          child: Text(showAnswer ? 'Hide Answer' : 'Show Answer'),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: onPreviousCard,
              child: Text('Previous'),
            ),
            ElevatedButton(
              onPressed: onNextCard,
              child: Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
