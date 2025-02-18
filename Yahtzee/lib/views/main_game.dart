import 'package:flutter/material.dart';
import '../models/dice.dart';
import '../models/scorecard.dart';
import 'dice_display.dart';
import 'scorecard_display.dart';

class MainGame extends StatefulWidget {
  @override
  _MainGameState createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> with SingleTickerProviderStateMixin {
  final Dice dice = Dice(5);
  final ScoreCard scoreCard = ScoreCard();
  int rollCount = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void rollDice() {
    if (rollCount < 3) {
      _controller.forward(from: 0.0);
      setState(() {
        dice.roll();
        rollCount++;
      });
    }
  }

  void toggleHold(int index) {
    setState(() {
      dice.toggleHold(index);
    });
  }

  void selectCategory(ScoreCategory category) {
    if (rollCount > 0) {
      setState(() {
        scoreCard.registerScore(category, dice.values);
        dice.clear();
        rollCount = 0;

        if (scoreCard.completed) {
          _showFinalScore();
        }
      });
    }
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over', style: TextStyle(color: Colors.blue[800])),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your final score is:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('${scoreCard.total}', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue[800])),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                scoreCard.clear();
                dice.clear();
                rollCount = 0;
              });
            },
            child: Text('Play Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[100]!, Colors.blue[50]!],
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          10 * _animation.value * (rollCount % 2 == 0 ? 1 : -1),
                          0,
                        ),
                        child: child,
                      );
                    },
                    child: DiceDisplay(dice: dice, onToggleHold: toggleHold),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: rollCount < 3 ? rollDice : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(
                    rollCount < 3 ? 'Roll Dice (${3 - rollCount} left)' : 'Select a category',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: rollCount < 3 ? Colors.blue[700] : Colors.grey[400],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
              SizedBox(height: 30),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ScorecardDisplay(scoreCard: scoreCard, onSelectCategory: selectCategory),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}