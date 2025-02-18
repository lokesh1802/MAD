import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class CardTile extends StatelessWidget {
  final Flashcard card;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  CardTile({
    required this.card,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(card.question),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
