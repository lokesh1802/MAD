import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'flashcards.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  Future<List<Deck>> getDecksOrderedByTitle() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'decks',
    orderBy: 'title ASC',
  );
  return List.generate(maps.length, (i) => Deck.fromMap(maps[i]));
}

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE decks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE flashcards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deckId INTEGER NOT NULL,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        FOREIGN KEY (deckId) REFERENCES decks (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertDeck(Deck deck) async {
    final db = await database;
    return db.insert('decks', deck.toMap());
  }

  Future<List<Deck>> getDecks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('decks');
    return List.generate(maps.length, (i) => Deck.fromMap(maps[i]));
  }

  Future<void> updateDeck(Deck deck) async {
    final db = await database;
    await db.update(
      'decks',
      deck.toMap(),
      where: 'id = ?',
      whereArgs: [deck.id],
    );
  }

  Future<void> deleteDeck(int id) async {
  final db = await database;
  await db.delete('flashcards', where: 'deckId = ?', whereArgs: [id]); // Delete related flashcards first
  await db.delete('decks', where: 'id = ?', whereArgs: [id]); // Delete the deck
}


  Future<int> insertCard(Flashcard card) async {
    final db = await database;
    return db.insert('flashcards', card.toMap());
  }

  Future<List<Flashcard>> getCards(int deckId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      where: 'deckId = ?',
      whereArgs: [deckId],
    );
    return List.generate(maps.length, (i) => Flashcard.fromMap(maps[i]));
  }
    Future<int> getFlashcardCount(int deckId) async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM flashcards WHERE deckId = ?', [deckId]),
    );
    return count ?? 0;
  }

  

  Future<void> updateCard(Flashcard card) async {
    final db = await database;
    await db.update(
      'flashcards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<void> deleteCard(int id) async {
    final db = await database;
    await db.delete(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
