import 'quiz.dart';

class Philosopher {
  final int id;
  final String name;
  final int birthYear;
  final int deathYear;
  final String era;
  final String school;
  final String bio;
  final List<String> keyIdeas;
  final String imageUrl;
  final List<QuizQuestion> quizQuestions;
  final String wikipediaUrl;
  final List<String> contemporaries;
  final List<String> opponents;

  Philosopher({
    required this.id,
    required this.name,
    required this.birthYear,
    required this.deathYear,
    required this.era,
    required this.school,
    required this.bio,
    required this.keyIdeas,
    this.imageUrl = '',
    List<QuizQuestion>? quizQuestions,
    this.wikipediaUrl = '',
    this.contemporaries = const [],
    this.opponents = const [],
  }) : quizQuestions = quizQuestions ?? [];

  factory Philosopher.fromJson(Map<String, dynamic> json) {
    return Philosopher(
      id: json['id'],
      name: json['name'],
      birthYear: json['birth_year'],
      deathYear: json['death_year'],
      era: json['era'],
      school: json['school'],
      bio: json['bio'],
      keyIdeas: List<String>.from(json['key_ideas'] ?? []),
      imageUrl: json['image_url'] ?? '',
      quizQuestions: (json['quiz_questions'] as List<dynamic>?)
          ?.map((q) => QuizQuestion.fromJson(q))
          .toList() ?? [],
      wikipediaUrl: json['wikipedia_url'] ?? '',
      contemporaries: List<String>.from(json['contemporaries'] ?? []),
      opponents: List<String>.from(json['opponents'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birth_year': birthYear,
      'death_year': deathYear,
      'era': era,
      'school': school,
      'bio': bio,
      'key_ideas': keyIdeas,
      'image_url': imageUrl,
      'quiz_questions': quizQuestions.map((q) => q.toJson()).toList(),
      'wikipedia_url': wikipediaUrl,
      'contemporaries': contemporaries,
      'opponents': opponents,
    };
  }

  String get lifespan => '${birthYear < 0 ? '${birthYear.abs()} BC' : birthYear} - ${deathYear < 0 ? '${deathYear.abs()} BC' : deathYear}';
}
