class UserProgress {
  int totalPoints;
  int currentStreak;
  DateTime lastVisitDate;
  int level;
  List<int> readQuoteIds;
  List<int> completedPhilosopherIds;
  List<int> completedQuizPhilosopherIds;
  List<String> unlockedBadges;
  List<int> favoriteQuoteIds;
  List<int> favoritePhilosopherIds;
  Map<String, int> categoryQuotesRead;

  UserProgress({
    this.totalPoints = 0,
    this.currentStreak = 0,
    DateTime? lastVisitDate,
    this.level = 1,
    List<int>? readQuoteIds,
    List<int>? completedPhilosopherIds,
    List<int>? completedQuizPhilosopherIds,
    List<String>? unlockedBadges,
    List<int>? favoriteQuoteIds,
    List<int>? favoritePhilosopherIds,
    Map<String, int>? categoryQuotesRead,
  })  : lastVisitDate = lastVisitDate ?? DateTime.now(),
        readQuoteIds = readQuoteIds ?? [],
        completedPhilosopherIds = completedPhilosopherIds ?? [],
        completedQuizPhilosopherIds = completedQuizPhilosopherIds ?? [],
        unlockedBadges = unlockedBadges ?? [],
        favoriteQuoteIds = favoriteQuoteIds ?? [],
        favoritePhilosopherIds = favoritePhilosopherIds ?? [],
        categoryQuotesRead = categoryQuotesRead ?? {};

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      totalPoints: json['total_points'] ?? 0,
      currentStreak: json['current_streak'] ?? 0,
      lastVisitDate: DateTime.parse(json['last_visit_date'] ?? DateTime.now().toIso8601String()),
      level: json['level'] ?? 1,
      readQuoteIds: List<int>.from(json['read_quote_ids'] ?? []),
      completedPhilosopherIds: List<int>.from(json['completed_philosopher_ids'] ?? []),
      completedQuizPhilosopherIds: List<int>.from(json['completed_quiz_philosopher_ids'] ?? []),
      unlockedBadges: List<String>.from(json['unlocked_badges'] ?? []),
      favoriteQuoteIds: List<int>.from(json['favorite_quote_ids'] ?? []),
      favoritePhilosopherIds: List<int>.from(json['favorite_philosopher_ids'] ?? []),
      categoryQuotesRead: Map<String, int>.from(json['category_quotes_read'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_points': totalPoints,
      'current_streak': currentStreak,
      'last_visit_date': lastVisitDate.toIso8601String(),
      'level': level,
      'read_quote_ids': readQuoteIds,
      'completed_philosopher_ids': completedPhilosopherIds,
      'completed_quiz_philosopher_ids': completedQuizPhilosopherIds,
      'unlocked_badges': unlockedBadges,
      'favorite_quote_ids': favoriteQuoteIds,
      'favorite_philosopher_ids': favoritePhilosopherIds,
      'category_quotes_read': categoryQuotesRead,
    };
  }

  double get streakMultiplier {
    if (currentStreak >= 30) return 2.0;
    if (currentStreak >= 14) return 1.8;
    if (currentStreak >= 7) return 1.5;
    if (currentStreak >= 3) return 1.2;
    return 1.0;
  }

  int get pointsToNextLevel => level * 100;
}
