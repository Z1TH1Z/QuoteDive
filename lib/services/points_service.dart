import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_progress.dart';
import '../models/badge.dart';
import 'database_service.dart';

class PointsService {
  static final PointsService instance = PointsService._init();
  PointsService._init();

  static const String _progressKey = 'user_progress';

  // Point values
  static const int readQuotePoints = 10;
  static const int deepDivePoints = 30;
  static const int philosopherProfilePoints = 50;
  static const int dailyStreakPoints = 5;

  Future<UserProgress> getUserProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString(_progressKey);

    if (progressJson == null) {
      return UserProgress();
    }

    return UserProgress.fromJson(json.decode(progressJson));
  }

  Future<void> saveUserProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey, json.encode(progress.toJson()));
    
    // Also save individual values for widget access
    await prefs.setInt('total_points', progress.totalPoints);
    await prefs.setInt('current_streak', progress.currentStreak);
    await prefs.setInt('current_level', progress.level);
  }

  Future<int> awardPoints(int basePoints, {bool applyMultiplier = true}) async {
    final progress = await getUserProgress();
    
    int points = basePoints;
    if (applyMultiplier) {
      points = (basePoints * progress.streakMultiplier).round();
    }

    progress.totalPoints += points;
    
    // Update level
    while (progress.totalPoints >= progress.pointsToNextLevel) {
      progress.level++;
    }

    await saveUserProgress(progress);
    
    // Track today's points for widget
    await _updateTodayPoints(points);
    
    return points;
  }

  Future<void> _updateTodayPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';
    final lastPointsDate = prefs.getString('last_points_date');
    
    if (lastPointsDate == todayStr) {
      // Same day, add to existing points
      final currentTodayPoints = prefs.getInt('today_points') ?? 0;
      await prefs.setInt('today_points', currentTodayPoints + points);
    } else {
      // New day, reset counter
      await prefs.setString('last_points_date', todayStr);
      await prefs.setInt('today_points', points);
    }
  }

  Future<void> markQuoteAsRead(int quoteId) async {
    final progress = await getUserProgress();
    
    if (!progress.readQuoteIds.contains(quoteId)) {
      progress.readQuoteIds.add(quoteId);
      
      // Track category
      final quote = await DatabaseService.instance.getQuoteById(quoteId);
      if (quote != null) {
        final category = quote.category;
        progress.categoryQuotesRead[category] = (progress.categoryQuotesRead[category] ?? 0) + 1;
      }
      
      await awardPoints(readQuotePoints);
      await saveUserProgress(progress);
      await checkBadges();
    }
  }

  Future<void> completeDeepDive(int quoteId) async {
    final progress = await getUserProgress();
    await awardPoints(deepDivePoints);
    await saveUserProgress(progress);
  }

  Future<void> completePhilosopherProfile(int philosopherId) async {
    final progress = await getUserProgress();
    
    if (!progress.completedPhilosopherIds.contains(philosopherId)) {
      progress.completedPhilosopherIds.add(philosopherId);
      await awardPoints(philosopherProfilePoints);
      await saveUserProgress(progress);
    }
  }

  Future<void> completeQuiz(int philosopherId) async {
    final progress = await getUserProgress();
    
    if (!progress.completedQuizPhilosopherIds.contains(philosopherId)) {
      progress.completedQuizPhilosopherIds.add(philosopherId);
      await saveUserProgress(progress);
    }
  }

  Future<void> updateStreak() async {
    final progress = await getUserProgress();
    final now = DateTime.now();
    final lastVisit = progress.lastVisitDate;

    // Check if it's a new day
    final daysDifference = now.difference(lastVisit).inDays;

    if (daysDifference == 0) {
      // Same day, no change
      return;
    } else if (daysDifference == 1) {
      // Consecutive day, increment streak
      progress.currentStreak++;
      await awardPoints(dailyStreakPoints);
    } else {
      // Streak broken, reset
      progress.currentStreak = 1;
    }

    progress.lastVisitDate = now;
    await saveUserProgress(progress);
    await checkBadges();
  }

  Future<List<Badge>> checkBadges() async {
    final progress = await getUserProgress();
    final newBadges = <Badge>[];

    for (var badge in BadgeDefinitions.allBadges) {
      if (progress.unlockedBadges.contains(badge.id)) {
        continue; // Already unlocked
      }

      bool shouldUnlock = false;

      switch (badge.type) {
        case BadgeType.streak:
          shouldUnlock = progress.currentStreak >= badge.requirement;
          break;
        case BadgeType.quotes:
          shouldUnlock = progress.readQuoteIds.length >= badge.requirement;
          break;
        case BadgeType.philosophers:
          shouldUnlock = progress.completedPhilosopherIds.length >= badge.requirement;
          break;
        case BadgeType.points:
          shouldUnlock = progress.totalPoints >= badge.requirement;
          break;
        case BadgeType.category:
          // Check specific categories
          if (badge.id.contains('stoic')) {
            shouldUnlock = (progress.categoryQuotesRead['Stoicism'] ?? 0) >= badge.requirement;
          } else if (badge.id.contains('existentialist')) {
            shouldUnlock = (progress.categoryQuotesRead['Existentialism'] ?? 0) >= badge.requirement;
          } else if (badge.id.contains('eastern')) {
            shouldUnlock = (progress.categoryQuotesRead['Eastern Philosophy'] ?? 0) >= badge.requirement;
          }
          break;
      }

      if (shouldUnlock) {
        progress.unlockedBadges.add(badge.id);
        newBadges.add(badge);
      }
    }

    if (newBadges.isNotEmpty) {
      await saveUserProgress(progress);
    }

    return newBadges;
  }

  Future<void> toggleFavoriteQuote(int quoteId) async {
    final progress = await getUserProgress();
    
    if (progress.favoriteQuoteIds.contains(quoteId)) {
      progress.favoriteQuoteIds.remove(quoteId);
    } else {
      progress.favoriteQuoteIds.add(quoteId);
    }

    await saveUserProgress(progress);
  }

  Future<void> toggleFavoritePhilosopher(int philosopherId) async {
    final progress = await getUserProgress();
    
    if (progress.favoritePhilosopherIds.contains(philosopherId)) {
      progress.favoritePhilosopherIds.remove(philosopherId);
    } else {
      progress.favoritePhilosopherIds.add(philosopherId);
    }

    await saveUserProgress(progress);
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
  }
}
