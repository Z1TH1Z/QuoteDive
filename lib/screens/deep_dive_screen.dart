import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../models/quote.dart';
import '../models/philosopher.dart';
import '../services/database_service.dart';
import '../services/points_service.dart';
import '../services/audio_service.dart';
import '../services/widget_service.dart';
import '../utils/constants.dart';
import '../widgets/badge_unlock_dialog.dart';
import '../widgets/share_quote_card.dart';
import '../widgets/points_earned_overlay.dart';
import '../utils/philosopher_assets.dart';
import '../widgets/philosopher_image.dart';
import 'philosopher_profile_screen.dart';

class DeepDiveScreen extends StatefulWidget {
  final Quote quote;

  const DeepDiveScreen({super.key, required this.quote});

  @override
  State<DeepDiveScreen> createState() => _DeepDiveScreenState();
}

class _DeepDiveScreenState extends State<DeepDiveScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _hasCompletedReading = false;
  bool _isPlayingAudio = false;
  Philosopher? _philosopher;

  PhilosopherTheme get theme => PhilosopherAssets.getTheme(widget.quote.author);

  @override
  void initState() {
    super.initState();
    _loadPhilosopher();
  }

  Future<void> _loadPhilosopher() async {
    final philosopher = await DatabaseService.instance.getPhilosopherById(
      widget.quote.philosopherId,
    );
    setState(() => _philosopher = philosopher);
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);

    // Award points when user reaches the last page
    if (page == 2 && !_hasCompletedReading) {
      _hasCompletedReading = true;
      _awardPoints();
    }
  }

  Future<void> _awardPoints() async {
    await PointsService.instance.completeDeepDive(widget.quote.id);
    await WidgetService.instance.updateWidget();
    final newBadges = await PointsService.instance.checkBadges();
    
    if (mounted) {
      if (newBadges.isNotEmpty) {
        for (var badge in newBadges) {
          await BadgeUnlockDialog.show(context, badge, theme: theme);
        }
      }
      
      PointsEarnedOverlay.show(
        context,
        points: AppConstants.deepDivePoints,
        label: 'Insight',
        theme: theme,
      );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Deep Dive', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.textPrimary),
            onPressed: () => ShareQuoteCard.showShareDialog(context, widget.quote),
            tooltip: 'Share quote',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: theme.backgroundGradient,
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  child: Row(
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: AnimatedContainer(
                          duration: 300.ms,
                          height: 6,
                          margin: EdgeInsets.only(
                            right: index < 2 ? AppSpacing.sm : 0,
                          ),
                          decoration: BoxDecoration(
                            color: index <= _currentPage
                                ? theme.primary
                                : theme.secondary.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                
                // Content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildPage(_buildQuoteContent()),
                      _buildPage(_buildContextContent()),
                      _buildPage(_buildMeaningContent()),
                    ],
                  ),
                ),

                // Navigation Controls
                _buildBottomControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(Widget content) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppShadows.medium,
        ),
        child: content,
      ),
    );
  }

  Widget _buildQuoteContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PhilosopherImage(
          philosopherName: widget.quote.author,
          useDeepDiveVariant: true,
          height: 120,
          placeholderBuilder: (context) => const Icon(Icons.nature, size: 64, color: AppColors.primary),
        ).animate().fadeIn(),
        const SizedBox(height: AppSpacing.xl),
        Icon(Icons.format_quote, size: 48, color: theme.quoteIcon)
            .animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
        const SizedBox(height: AppSpacing.md),
        Text(
          widget.quote.text,
          style: AppTextStyles.quote.copyWith(fontSize: 24, color: theme.textPrimary),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: AppSpacing.lg),
        Text(
          '— ${widget.quote.author}',
          style: AppTextStyles.author.copyWith(color: theme.textSecondary),
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: AppSpacing.sm),
        Chip(
          label: Text(widget.quote.category, style: AppTextStyles.caption.copyWith(color: theme.primary)),
          backgroundColor: theme.secondary,
          side: BorderSide.none,
        ).animate().fadeIn(delay: 500.ms),
        const SizedBox(height: AppSpacing.xl),
        
        // Audio Button
        ElevatedButton.icon(
          onPressed: () async {
            if (_isPlayingAudio) {
              await AudioService.instance.stop();
              setState(() => _isPlayingAudio = false);
            } else {
              await AudioService.instance.speakQuote(
                widget.quote.text,
                widget.quote.author,
              );
              setState(() => _isPlayingAudio = true);
              await Future.delayed(const Duration(seconds: 10));
              if (mounted) {
                setState(() => _isPlayingAudio = false);
              }
            }
          },
          icon: Icon(_isPlayingAudio ? Icons.stop : Icons.volume_up_rounded),
          label: Text(_isPlayingAudio ? 'Stop Reading' : 'Listen'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.textPrimary,
            foregroundColor: theme.surface,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ).animate().scale(delay: 600.ms),
      ],
    );
  }

  Widget _buildContextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.history_edu, color: AppColors.accent),
            ),
            const SizedBox(width: AppSpacing.md),
            Text('Historical Context', style: AppTextStyles.heading2),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Text(
              widget.quote.deepDive.context,
              style: AppTextStyles.body.copyWith(height: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMeaningContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.lightbulb_outline, color: AppColors.success),
            ),
            const SizedBox(width: AppSpacing.md),
            Text('Modern Meaning', style: AppTextStyles.heading2),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Text(
              widget.quote.deepDive.modernMeaning,
              style: AppTextStyles.body.copyWith(height: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _currentPage > 0
              ? TextButton.icon(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: 400.ms,
                      curve: Curves.easeOutCubic,
                    );
                  },
                  icon: Icon(Icons.arrow_back, color: theme.textSecondary),
                  label: Text('Back', style: AppTextStyles.button.copyWith(color: theme.textSecondary)),
                )
              : const SizedBox(width: 80),
          
          _currentPage < 2
              ? ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: 400.ms,
                      curve: Curves.easeOutCubic,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.textPrimary,
                    foregroundColor: theme.surface,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.arrow_forward),
                )
              : _philosopher != null
                  ? ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhilosopherProfileScreen(
                              philosopher: _philosopher!,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person),
                      label: const Text('View Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      ).animate().scale(delay: 500.ms, duration: 300.ms, begin: const Offset(1, 1), end: const Offset(1.1, 1.1)).then().scale(duration: 300.ms, end: const Offset(1, 1))
                  : const SizedBox(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    AudioService.instance.stop();
    super.dispose();
  }
}
