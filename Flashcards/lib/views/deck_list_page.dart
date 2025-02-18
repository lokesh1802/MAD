import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../utils/database_helper.dart';
import '../utils/json_loader.dart'; // Import JSONLoader to handle cloning
import 'card_list_page.dart';
import 'deck_editor_page.dart';

class DeckListPage extends StatefulWidget {
  @override
  _DeckListPageState createState() => _DeckListPageState();
}

class _DeckListPageState extends State<DeckListPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final JSONLoader jsonLoader = JSONLoader(); // Add an instance of JSONLoader
  bool _isAlphabetical = true;

  void _toggleSortOrder() {
    setState(() {
      _isAlphabetical = !_isAlphabetical;
    });
  }

  Future<void> _downloadDecks() async {
    // Function to clone current decks and add them to the database
    await jsonLoader.cloneExistingDecks(); // Add this function to JSONLoader
    setState(() {}); // Refresh page to show cloned decks
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard Decks'),
        actions: [
          IconButton(
            icon: Icon(_isAlphabetical ? Icons.sort_by_alpha : Icons.history),
            onPressed: _toggleSortOrder,
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "download",
            onPressed: _downloadDecks,
            child: Icon(Icons.download),
            tooltip: 'Download Decks (Clone)',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "add",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeckEditorPage()),
              ).then((value) {
                setState(() {}); // Refresh page when a deck is added/edited
              });
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<Deck>>(
        future: _isAlphabetical ? dbHelper.getDecksOrderedByTitle() : dbHelper.getDecks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No decks available. Tap the + button to add one.'));
          } else {
            final decks = snapshot.data!;
            return ListView.builder(
              itemCount: decks.length,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) {
                final deck = decks[index];
                return FutureBuilder<int>(
                  future: dbHelper.getFlashcardCount(deck.id!), // Get count of flashcards in the deck
                  builder: (context, snapshot) {
                    int cardCount = snapshot.data ?? 0; // Default to 0 if data is not available
                    return Card(
                      elevation: 4.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigate to CardListPage when the deck is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CardListPage(deck: deck),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                deck.title,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '$cardCount cards',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DeckEditorPage(deck: deck),
                                        ),
                                      ).then((value) {
                                        setState(() {}); // Refresh page when a deck is edited
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
