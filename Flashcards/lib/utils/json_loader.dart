import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import 'database_helper.dart';
import '../views/quiz_page.dart'; // Assuming there is a quiz page for navigating

class JSONLoader {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> loadInitialData() async {
    try {
      // Check if the database already has decks
      List<Deck> existingDecks = await dbHelper.getDecks();
      if (existingDecks.isNotEmpty) {
        print('Database already populated, skipping initial data load.');
        return;
      }

      String jsonString = await rootBundle.loadString('assets/flashcards.json');
      List<dynamic> jsonData = json.decode(jsonString);

      for (var deckData in jsonData) {
        Deck deck = Deck(title: deckData['title']);
        int deckId = await dbHelper.insertDeck(deck);

        List<dynamic> flashcards = deckData['flashcards'];
        for (var cardData in flashcards) {
          Flashcard card = Flashcard(
            deckId: deckId,
            question: cardData['question'],
            answer: cardData['answer'],
          );
          await dbHelper.insertCard(card);
        }
      }
      print('Initial data loaded successfully.');
    } catch (e) {
      print('Error loading initial data: $e');
    }
  }
  Future<void> cloneExistingDecks() async {
    try {
      // Get all existing decks
      List<Deck> existingDecks = await dbHelper.getDecks();

      // Clone each deck
      for (Deck deck in existingDecks) {
        // Create a new deck with the same title
        Deck clonedDeck = Deck(title: deck.title);
        int clonedDeckId = await dbHelper.insertDeck(clonedDeck);

        // Get all flashcards from the original deck
        List<Flashcard> flashcards = await dbHelper.getCards(deck.id!);

        // Clone each flashcard to the new deck
        for (Flashcard flashcard in flashcards) {
          Flashcard clonedCard = Flashcard(
            deckId: clonedDeckId,
            question: flashcard.question,
            answer: flashcard.answer,
          );
          await dbHelper.insertCard(clonedCard);
        }
      }

      print('Decks cloned successfully with identical names.');
    } catch (e) {
      print('Error cloning decks: $e');
    }
  }

  Future<void> deleteDeck(int deckId) async {
    try {
      await dbHelper.deleteDeck(deckId);
      print('Deck with ID $deckId deleted successfully.');
    } catch (e) {
      print('Error deleting deck with ID $deckId: $e');
    }
  }
}

// Example button widget for deleting a deck
class DeleteDeckButton extends StatelessWidget {
  final int deckId;
  final JSONLoader jsonLoader;

  DeleteDeckButton({required this.deckId, required this.jsonLoader});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        bool confirmDelete = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this deck?'),
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
          await jsonLoader.deleteDeck(deckId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Deck deleted successfully.')),
          );
        }
      },
    );
  }
}

// Example button widget for starting a quiz for a specific deck
class StartQuizButton extends StatelessWidget {
  final int deckId;

  StartQuizButton({required this.deckId});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(deckId: deckId),
          ),
        );
      },
      child: Text('Start Quiz'),
    );
  }
}
