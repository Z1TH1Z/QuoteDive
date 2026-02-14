import 'package:home_widget/home_widget.dart';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_service.dart';
import '../models/quote.dart';
import '../models/user_progress.dart';

class WidgetService {
  static final WidgetService instance = WidgetService._init();
  WidgetService._init();

  static const String _widgetName = 'QuotesWidgetProvider';
  static const String _quoteTextKey = 'quote_text';
  static const String _quoteAuthorKey = 'quote_author';
  static const String _quoteIdKey = 'quote_id';
  static const String _streakKey = 'current_streak';
  static const String _pointsKey = 'total_points';
  static const String _levelKey = 'current_level';
  static const String _todayPointsKey = 'today_points';
  static const String _lastUpdateKey = 'last_update';

  Future<void> updateWidget({Quote? quote, bool keepCurrentQuote = false}) async {
    try {
      Quote? quoteToUse = quote;

      if (quoteToUse == null) {
        if (keepCurrentQuote) {
          final currentId = await getWidgetQuoteId();
          if (currentId != null) {
            quoteToUse = await DatabaseService.instance.getQuoteById(currentId);
          }
        }
        // If still null (not preserving or not found), get random
        quoteToUse ??= await _getTodaysQuote();
      }
      
      // Get user progress
      final progress = await _getUserProgress();
      
      // Get today's points
      final todayPoints = await _getTodayPoints();

      if (quoteToUse != null) {
        // Save quote data
        await HomeWidget.saveWidgetData<String>(_quoteTextKey, quoteToUse.text);
        await HomeWidget.saveWidgetData<String>(_quoteAuthorKey, quoteToUse.author); 
        await HomeWidget.saveWidgetData<int>(_quoteIdKey, quoteToUse.id);
        
        // Save progress data
        await HomeWidget.saveWidgetData<int>(_streakKey, progress.currentStreak);
        await HomeWidget.saveWidgetData<int>(_pointsKey, progress.totalPoints);
        await HomeWidget.saveWidgetData<int>(_levelKey, progress.level);
        await HomeWidget.saveWidgetData<int>(_todayPointsKey, todayPoints);
        await HomeWidget.saveWidgetData<String>(_lastUpdateKey, DateTime.now().toIso8601String());

        // Update standard widget
        await HomeWidget.updateWidget(
          name: _widgetName,
          iOSName: 'QuotesWidget',
        );

        // Update translucent widget
        await HomeWidget.updateWidget(
          name: 'TranslucentWidgetProvider',
          iOSName: 'QuotesWidgetTranslucent', // Placeholder, iOS not in scope but good practice
        );
      }
    } catch (e) {
      // Error updating widget
    }
  }

  Future<Quote?> _getTodaysQuote() async {
    try {
      return await DatabaseService.instance.getDailyQuote();
    } catch (e) {
      // Error getting today's quote
      return null;
    }
  }

  Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId('group.quotes.app');
      await updateWidget();
    } catch (e) {
      // Error initializing widget
    }
  }

  Future<int?> getWidgetQuoteId() async {
    try {
      return await HomeWidget.getWidgetData<int>(_quoteIdKey);
    } catch (e) {
      // Error getting widget quote ID
      return null;
    }
  }

  Future<UserProgress> _getUserProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString('user_progress');
      
      if (progressJson != null && progressJson.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(progressJson);
        return UserProgress.fromJson(decoded);
      }
      
      return UserProgress();
    } catch (e) {
      return UserProgress();
    }
  }

  Future<int> _getTodayPoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastPointsDate = prefs.getString('last_points_date');
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month}-${today.day}';
      
      if (lastPointsDate == todayStr) {
        return prefs.getInt('today_points') ?? 0;
      }
      
      return 0;
    } catch (e) {
      return 0;
    }
  }
}
