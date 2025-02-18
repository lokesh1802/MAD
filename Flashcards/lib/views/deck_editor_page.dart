import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../utils/database_helper.dart';

class DeckEditorPage extends StatefulWidget {
  final Deck? deck;

  DeckEditorPage({this.deck});

  @override
  _DeckEditorPageState createState() => _DeckEditorPageState();
}

class _DeckEditorPageState extends State<DeckEditorPage> {
  final TextEditingController _titleController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.deck != null) {
      _titleController.text = widget.deck!.title;  // Set text field value if editing an existing deck
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck == null ? 'Create Deck' : 'Edit Deck'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Deck Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (_titleController.text.isNotEmpty) {
                      if (widget.deck == null) {
                        await dbHelper.insertDeck(Deck(title: _titleController.text));
                      } else {
                        await dbHelper.updateDeck(
                          Deck(id: widget.deck!.id, title: _titleController.text),
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
                ),
                if (widget.deck != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      await dbHelper.deleteDeck(widget.deck!.id!);
                      Navigator.pop(context);
                    },
                    child: Text('Delete'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
