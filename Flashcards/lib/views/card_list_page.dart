import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import '../utils/database_helper.dart';
import 'card_editor_page.dart';
import 'quiz_page.dart'; // Import QuizPage

class CardListPage extends StatefulWidget {
  final Deck deck;

  CardListPage({required this.deck});

  @override
  _CardListPageState createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  bool _isAlphabetical = true;

  void _toggleSortOrder() {
    setState(() {
      _isAlphabetical = !_isAlphabetical;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<List<Flashcard>>(
          future: dbHelper.getCards(widget.deck.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('${widget.deck.title}'); // Title without count while loading
            } else if (snapshot.hasError) {
              return Text('${widget.deck.title}'); // Title without count if error occurs
            } else {
              int cardCount = snapshot.data?.length ?? 0;
              return Text('${widget.deck.title} ($cardCount cards)');
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_isAlphabetical ? Icons.sort_by_alpha : Icons.history),
            onPressed: _toggleSortOrder,
          ),
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              // Navigate to QuizPage when the quiz button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizPage(deckId: widget.deck.id!),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CardEditorPage(deckId: widget.deck.id!)),
          ).then((value) {
            setState(() {}); // Refresh page when a card is added/edited
          });
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Flashcard>>(
        future: _getSortedCards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cards available. Tap the + button to add one.'));
          } else {
            final cards = snapshot.data!;
            return ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return Card(
                  child: ListTile(
                    title: Text(card.question),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CardEditorPage(deckId: widget.deck.id!, card: card),
                              ),
                            ).then((value) {
                              setState(() {}); // Refresh page when card is edited
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool confirmDelete = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Confirm Delete'),
                                content: Text('Are you sure you want to delete this card?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text('No'),
                                  ),
                                ],
                              ),
                            );

                            if (confirmDelete == true) {
                              await dbHelper.deleteCard(card.id!);
                              setState(() {}); // Refresh page when card is deleted
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Card deleted successfully.')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Flashcard>> _getSortedCards() async {
    List<Flashcard> cards = await dbHelper.getCards(widget.deck.id!);
    if (_isAlphabetical) {
      cards.sort((a, b) => a.question.compareTo(b.question));
    }
    return cards;
  }
}
