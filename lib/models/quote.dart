class Quote {
  final int id;
  final String text;
  final String author;
  final String category;
  final DeepDive deepDive;
  final int philosopherId;

  Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
    required this.deepDive,
    required this.philosopherId,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      text: json['text'],
      author: json['author'],
      category: json['category'],
      deepDive: DeepDive.fromJson(json['deep_dive']),
      philosopherId: json['philosopher_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'category': category,
      'deep_dive': deepDive.toJson(),
      'philosopher_id': philosopherId,
    };
  }
}

class DeepDive {
  final String context;
  final String modernMeaning;
  final String audioUrl;

  DeepDive({
    required this.context,
    required this.modernMeaning,
    this.audioUrl = '',
  });

  factory DeepDive.fromJson(Map<String, dynamic> json) {
    return DeepDive(
      context: json['context'] ?? '',
      modernMeaning: json['modern_meaning'] ?? '',
      audioUrl: json['audio_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'context': context,
      'modern_meaning': modernMeaning,
      'audio_url': audioUrl,
    };
  }
}
