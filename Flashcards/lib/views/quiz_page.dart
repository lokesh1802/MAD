import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../utils/database_helper.dart';
import 'dart:math';

class QuizPage extends StatefulWidget {
  final int deckId;

  QuizPage({required this.deckId});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Flashcard> _cards = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  Set<int> _seenCards = {};
  Set<int> _peekedAnswers = {};

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    List<Flashcard> cards = await dbHelper.getCards(widget.deckId);
    cards.shuffle(Random()); // Shuffle cards for random order
    setState(() {
      _cards = cards;
      _currentIndex = 0;
      _showAnswer = false;
      _seenCards = {}; // Clear seen cards set on reload
      _peekedAnswers = {}; // Clear peeked answers set on reload
    });
  }

  void _nextCard() {
    setState(() {
      if (_currentIndex < _cards.length - 1) {
        _currentIndex++;
        _showAnswer = false;
      }
    });
  }

  void _previousCard() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
        _showAnswer = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz Mode'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    _seenCards.add(_currentIndex); // Mark current card as seen

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.deckId} Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Card ${_currentIndex + 1} of ${_cards.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 4.0,
                child: Center(
                  child: Text(
                    _showAnswer
                        ? _cards[_currentIndex].answer
                        : _cards[_currentIndex].question,
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showAnswer = !_showAnswer;
                  if (_showAnswer) {
                    _peekedAnswers.add(_currentIndex); // Track answers viewed
                  }
                });
              },
              child: Text(_showAnswer ? 'Hide Answer' : 'Show Answer'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousCard,
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _nextCard,
                  child: Text('Next'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Seen ${_seenCards.length} of ${_cards.length} cards\n'
              'Peeked at ${_peekedAnswers.length} of ${_seenCards.length} answers',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
