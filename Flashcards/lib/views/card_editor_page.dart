import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../utils/database_helper.dart';

class CardEditorPage extends StatefulWidget {
  final int deckId;
  final Flashcard? card;

  CardEditorPage({required this.deckId, this.card});

  @override
  _CardEditorPageState createState() => _CardEditorPageState();
}

class _CardEditorPageState extends State<CardEditorPage> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.card != null) {
      _questionController.text = widget.card!.question;
      _answerController.text = widget.card!.answer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card == null ? 'Create Card' : 'Edit Card'),
        actions: widget.card != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await dbHelper.deleteCard(widget.card!.id!);
                    Navigator.pop(context);
                  },
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Answer'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_questionController.text.isNotEmpty && _answerController.text.isNotEmpty) {
                  if (widget.card == null) {
                    await dbHelper.insertCard(
                      Flashcard(
                        deckId: widget.deckId,
                        question: _questionController.text,
                        answer: _answerController.text,
                      ),
                    );
                  } else {
                    await dbHelper.updateCard(
                      Flashcard(
                        id: widget.card!.id,
                        deckId: widget.deckId,
                        question: _questionController.text,
                        answer: _answerController.text,
                      ),
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
