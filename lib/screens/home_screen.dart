import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../models/quote.dart';
import '../services/database_service.dart';
import '../services/points_service.dart';
import '../services/widget_service.dart';
import '../utils/constants.dart';
import '../utils/philosopher_assets.dart';
import '../widgets/badge_unlock_dialog.dart';
import 'deep_dive_screen.dart';
import 'dashboard_screen.dart';
import '../widgets/philosopher_image.dart';
import 'search_screen.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Quote? _todaysQuote;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodaysQuote();
    _updateStreak();
  }

  Future<void> _loadTodaysQuote() async {
    try {
      final quote = await DatabaseService.instance.getDailyQuote();
      
      if (mounted) {
        setState(() {
          _todaysQuote = quote;
          _isLoading = false;
        });

        // Update widget with the new quote
        if (quote != null) {
          await WidgetService.instance.updateWidget();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateStreak() async {
    await PointsService.instance.updateStreak();
    final newBadges = await PointsService.instance.checkBadges();
    
    // Update widget after streak update
    await WidgetService.instance.updateWidget();
    
    if (mounted && newBadges.isNotEmpty) {
      for (var badge in newBadges) {
        await BadgeUnlockDialog.show(context, badge);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppConstants.appName,
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 2.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_outlined, color: AppColors.textPrimary),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardScreen())),
          ),
          const SizedBox(width: 8),
        ],
        leading: IconButton(
           icon: const Icon(Icons.search, color: AppColors.textPrimary),
           onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
        ),
      ),
      body: Stack(
        children: [
          // Zen Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: _todaysQuote != null
                  ? PhilosopherAssets.getTheme(_todaysQuote!.author).backgroundGradient
                  : const BoxDecoration(gradient: AppColors.primaryGradient).gradient,
            ),
          ),
          
          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _todaysQuote == null
                    ? Center(child: Text('No quotes found', style: AppTextStyles.body))
                    : _buildZenContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildZenContent() {
    final theme = PhilosopherAssets.getTheme(_todaysQuote!.author);
    return Column(
      children: [
        // Top Illustration (Philosopher-specific)
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 20),
            child: PhilosopherImage(
              philosopherName: _todaysQuote!.author,
              useDeepDiveVariant: true,
              height: 200,
              placeholderBuilder: (context) => const Icon(Icons.park, size: 80, color: AppColors.textLight),
            ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.9, 0.9)),
          ),
        ),

        // Quote Section
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.format_quote, size: 32, color: theme.quoteIcon)
                    .animate()
                    .fadeIn(delay: 200.ms),
                const SizedBox(height: AppSpacing.md),
                
                Text(
                  _todaysQuote!.text,
                  style: AppTextStyles.quote.copyWith(color: theme.textPrimary),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms, duration: 800.ms),
                
                const SizedBox(height: AppSpacing.lg),
                
                Text(
                  '— ${_todaysQuote!.author}',
                  style: AppTextStyles.author.copyWith(color: theme.textSecondary),
                ).animate().fadeIn(delay: 600.ms),
              ],
            ),
          ),
        ),

        // Bottom Controls
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Deep Dive / Insight Button
              ElevatedButton.icon(
                onPressed: _handleDeepDive,
                icon: const Icon(Icons.spa_outlined, size: 18),
                label: const Text('DEEP DIVE INTO THIS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.textPrimary,
                  foregroundColor: theme.surface,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: AppSpacing.md),
              
              Text(
                'Unlock wisdom • Earn points',
                style: AppTextStyles.caption.copyWith(color: theme.textSecondary),
              ).animate().fadeIn(delay: 1000.ms),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleDeepDive() async {
    await PointsService.instance.markQuoteAsRead(_todaysQuote!.id);
    await WidgetService.instance.updateWidget();
    final newBadges = await PointsService.instance.checkBadges();
    
    if (mounted) {
      if (newBadges.isNotEmpty) {
        for (var badge in newBadges) {
          await BadgeUnlockDialog.show(context, badge);
        }
      }
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeepDiveScreen(quote: _todaysQuote!),
        ),
      );
    }
  }
}
