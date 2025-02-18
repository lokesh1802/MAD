import 'package:flutter/material.dart';
import '../models/scorecard.dart';

class ScorecardDisplay extends StatelessWidget {
  final ScoreCard scoreCard;
  final void Function(ScoreCategory) onSelectCategory;

  ScorecardDisplay({required this.scoreCard, required this.onSelectCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ...ScoreCategory.values.map((category) {
            final score = scoreCard[category];
            return ListTile(
              title: Text(
                _formatCategoryName(category.name),
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Container(
                width: 50,
                height: 30,
                decoration: BoxDecoration(
                  color: score == null ? Colors.grey[200] : Colors.green[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    score?.toString() ?? '—',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: score == null ? Colors.grey[600] : Colors.green[800],
                    ),
                  ),
                ),
              ),
              onTap: score == null ? () => onSelectCategory(category) : null,
            );
          }).toList(),
          Divider(thickness: 2),
          ListTile(
            title: Text(
              'Total Score',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            trailing: Container(
              width: 70,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  scoreCard.total.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCategoryName(String name) {
    return name.split(RegExp(r'(?=[A-Z])')).map((word) => word.capitalize()).join(' ');
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}