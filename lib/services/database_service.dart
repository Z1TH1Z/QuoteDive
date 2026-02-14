import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/quote.dart';
import '../models/philosopher.dart';
import '../models/quiz.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quotes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5, // Incremented version to trigger recreation
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        // Drop old tables and recreate
        await db.execute('DROP TABLE IF EXISTS quotes');
        await db.execute('DROP TABLE IF EXISTS philosophers');
        await _createDB(db, newVersion);
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE quotes (
        id INTEGER PRIMARY KEY,
        text TEXT NOT NULL,
        author TEXT NOT NULL,
        category TEXT NOT NULL,
        context TEXT NOT NULL,
        modern_meaning TEXT NOT NULL,
        audio_url TEXT,
        philosopher_id INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE philosophers (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        birth_year INTEGER NOT NULL,
        death_year INTEGER NOT NULL,
        era TEXT NOT NULL,
        school TEXT NOT NULL,
        bio TEXT NOT NULL,
        key_ideas TEXT NOT NULL,
        image_url TEXT,
        quiz_questions TEXT,
        wikipedia_url TEXT,
        contemporaries TEXT,
        opponents TEXT
      )
    ''');

    // Load initial data from JSON
    await _loadInitialData(db);
  }

  Future<void> _loadInitialData(Database db) async {
    // Load quotes
    final quotesJson = await rootBundle.loadString('assets/quotes.json');
    final List<dynamic> quotesData = json.decode(quotesJson);

    for (var quoteData in quotesData) {
      final quote = Quote.fromJson(quoteData);
      await db.insert('quotes', {
        'id': quote.id,
        'text': quote.text,
        'author': quote.author,
        'category': quote.category,
        'context': quote.deepDive.context,
        'modern_meaning': quote.deepDive.modernMeaning,
        'audio_url': quote.deepDive.audioUrl,
        'philosopher_id': quote.philosopherId,
      });
    }

    // Load philosophers
    final philosophersJson = await rootBundle.loadString('assets/philosophers.json');
    final List<dynamic> philosophersData = json.decode(philosophersJson);

    for (var philosopherData in philosophersData) {
      final philosopher = Philosopher.fromJson(philosopherData);
      await db.insert('philosophers', {
        'id': philosopher.id,
        'name': philosopher.name,
        'birth_year': philosopher.birthYear,
        'death_year': philosopher.deathYear,
        'era': philosopher.era,
        'school': philosopher.school,
        'bio': philosopher.bio,
        'key_ideas': json.encode(philosopher.keyIdeas),
        'image_url': philosopher.imageUrl,
        'quiz_questions': json.encode(philosopher.quizQuestions.map((q) => q.toJson()).toList()),
        'wikipedia_url': philosopher.wikipediaUrl,
        'contemporaries': json.encode(philosopher.contemporaries),
        'opponents': json.encode(philosopher.opponents),
      });
    }
  }

  Future<List<Quote>> getAllQuotes() async {
    final db = await database;
    final result = await db.query('quotes');

    return result.map((json) => Quote(
      id: json['id'] as int,
      text: json['text'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      deepDive: DeepDive(
        context: json['context'] as String,
        modernMeaning: json['modern_meaning'] as String,
        audioUrl: json['audio_url'] as String? ?? '',
      ),
      philosopherId: json['philosopher_id'] as int,
    )).toList();
  }

  Future<Quote?> getQuoteById(int id) async {
    final db = await database;
    final result = await db.query(
      'quotes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    final json = result.first;
    return Quote(
      id: json['id'] as int,
      text: json['text'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      deepDive: DeepDive(
        context: json['context'] as String,
        modernMeaning: json['modern_meaning'] as String,
        audioUrl: json['audio_url'] as String? ?? '',
      ),
      philosopherId: json['philosopher_id'] as int,
    );
  }

  Future<List<Quote>> getQuotesByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      'quotes',
      where: 'category = ?',
      whereArgs: [category],
    );

    return result.map((json) => Quote(
      id: json['id'] as int,
      text: json['text'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      deepDive: DeepDive(
        context: json['context'] as String,
        modernMeaning: json['modern_meaning'] as String,
        audioUrl: json['audio_url'] as String? ?? '',
      ),
      philosopherId: json['philosopher_id'] as int,
    )).toList();
  }

  Future<Quote?> getRandomQuote() async {
    final db = await database;
    final result = await db.query(
      'quotes',
      orderBy: 'RANDOM()',
      limit: 1,
    );

    if (result.isEmpty) return null;

    final json = result.first;
    return Quote(
      id: json['id'] as int,
      text: json['text'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      deepDive: DeepDive(
        context: json['context'] as String,
        modernMeaning: json['modern_meaning'] as String,
        audioUrl: json['audio_url'] as String? ?? '',
      ),
      philosopherId: json['philosopher_id'] as int,
    );
  }

  Future<Quote?> getDailyQuote() async {
    final db = await database;
     // Get all quotes first (ORDER BY id for stability)
    final result = await db.query('quotes', orderBy: 'id');

    if (result.isEmpty) return null;

    // Use date as seed
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final random = Random(seed);
    
    final dailyIndex = random.nextInt(result.length);
    final json = result[dailyIndex];

    return Quote(
      id: json['id'] as int,
      text: json['text'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      deepDive: DeepDive(
        context: json['context'] as String,
        modernMeaning: json['modern_meaning'] as String,
        audioUrl: json['audio_url'] as String? ?? '',
      ),
      philosopherId: json['philosopher_id'] as int,
    );
  }

  Future<Philosopher?> getPhilosopherById(int id) async {
    final db = await database;
    final result = await db.query(
      'philosophers',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    final jsonData = result.first;
    final quizQuestionsJson = jsonData['quiz_questions'] as String?;
    List<dynamic> quizQuestionsData = [];
    if (quizQuestionsJson != null && quizQuestionsJson.isNotEmpty) {
      quizQuestionsData = jsonDecode(quizQuestionsJson);
    }

    return Philosopher(
      id: jsonData['id'] as int,
      name: jsonData['name'] as String,
      birthYear: jsonData['birth_year'] as int,
      deathYear: jsonData['death_year'] as int,
      era: jsonData['era'] as String,
      school: jsonData['school'] as String,
      bio: jsonData['bio'] as String,
      keyIdeas: List<String>.from(jsonDecode(jsonData['key_ideas'] as String)),
      imageUrl: jsonData['image_url'] as String? ?? '',
      quizQuestions: quizQuestionsData.map((q) => QuizQuestion.fromJson(q)).toList(),
      wikipediaUrl: jsonData['wikipedia_url'] as String? ?? '',
      contemporaries: jsonData['contemporaries'] != null ? List<String>.from(jsonDecode(jsonData['contemporaries'] as String)) : [],
      opponents: jsonData['opponents'] != null ? List<String>.from(jsonDecode(jsonData['opponents'] as String)) : [],
    );
  }

  Future<List<Philosopher>> getAllPhilosophers() async {
    final db = await database;
    final result = await db.query('philosophers');

    return result.map((jsonData) {
      final quizQuestionsJson = jsonData['quiz_questions'] as String?;
      List<dynamic> quizQuestionsData = [];
      if (quizQuestionsJson != null && quizQuestionsJson.isNotEmpty) {
        quizQuestionsData = jsonDecode(quizQuestionsJson);
      }

      return Philosopher(
        id: jsonData['id'] as int,
        name: jsonData['name'] as String,
        birthYear: jsonData['birth_year'] as int,
        deathYear: jsonData['death_year'] as int,
        era: jsonData['era'] as String,
        school: jsonData['school'] as String,
        bio: jsonData['bio'] as String,
        keyIdeas: List<String>.from(jsonDecode(jsonData['key_ideas'] as String)),
        imageUrl: jsonData['image_url'] as String? ?? '',
        quizQuestions: quizQuestionsData.map((q) => QuizQuestion.fromJson(q)).toList(),
        wikipediaUrl: jsonData['wikipedia_url'] as String? ?? '',
        contemporaries: jsonData['contemporaries'] != null ? List<String>.from(jsonDecode(jsonData['contemporaries'] as String)) : [],
        opponents: jsonData['opponents'] != null ? List<String>.from(jsonDecode(jsonData['opponents'] as String)) : [],
      );
    }).toList();
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
