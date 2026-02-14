import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import '../models/philosopher.dart';
import '../services/points_service.dart';
import '../services/widget_service.dart';
import '../utils/constants.dart';
import '../utils/philosopher_assets.dart';
import '../widgets/quiz_widget.dart';
import '../widgets/badge_unlock_dialog.dart';
import '../widgets/points_earned_overlay.dart';
import '../widgets/philosopher_image.dart';
import 'dashboard_screen.dart';

class PhilosopherProfileScreen extends StatefulWidget {
  final Philosopher philosopher;

  const PhilosopherProfileScreen({super.key, required this.philosopher});

  @override
  State<PhilosopherProfileScreen> createState() => _PhilosopherProfileScreenState();
}

class _PhilosopherProfileScreenState extends State<PhilosopherProfileScreen> {
  bool _hasCompleted = false;
  bool _showQuiz = false;
  int? _quizScore;
  bool _quizCompletedPreviously = false;

  PhilosopherTheme get theme => PhilosopherAssets.getTheme(widget.philosopher.name);

  @override
  void initState() {
    super.initState();
    _checkCompletion();
  }

  Future<void> _checkCompletion() async {
    final progress = await PointsService.instance.getUserProgress();
    setState(() {
      _hasCompleted = progress.completedPhilosopherIds.contains(widget.philosopher.id);
      _quizCompletedPreviously = progress.completedQuizPhilosopherIds.contains(widget.philosopher.id);
    });
  }

  Future<void> _launchWiki() async {
    if (widget.philosopher.wikipediaUrl.isNotEmpty) {
      final dbUrl = Uri.parse(widget.philosopher.wikipediaUrl);
      if (await canLaunchUrl(dbUrl)) {
        await launchUrl(dbUrl, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> _markAsCompleted() async {
    if (!_hasCompleted) {
      await PointsService.instance.completePhilosopherProfile(widget.philosopher.id);
      await WidgetService.instance.updateWidget();
      
      setState(() => _hasCompleted = true);

      final newBadges = await PointsService.instance.checkBadges();

      if (mounted) {
        if (newBadges.isNotEmpty) {
          for (var badge in newBadges) {
            await BadgeUnlockDialog.show(context, badge, theme: theme);
          }
        }
        
        PointsEarnedOverlay.show(
          context,
          points: AppConstants.philosopherProfilePoints,
          label: 'Wisdom',
          theme: theme,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: theme.surface.withOpacity(0.8),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Header Background (using SVG if available or gradient)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Opacity(
              opacity: 0.8,
              child: PhilosopherImage(
                philosopherName: widget.philosopher.name,
                fit: BoxFit.cover,
              )
                  .animate()
                  .fadeIn(duration: 800.ms),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.gradientStart.withOpacity(0.3),
                    theme.surface,
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      children: [
                        const SizedBox(height: 100), // Spacing for header
                        // Profile Icon
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.primary.withOpacity(0.5), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primary.withOpacity(0.1),
                                blurRadius: 20,
                                spreadRadius: 5,
                              )
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: theme.surface,
                            child: Icon(
                              Icons.person_outline,
                              size: 50,
                              color: theme.primary,
                            ),
                          ),
                        ).animate().scale(curve: Curves.easeOutBack, duration: 600.ms),
                        
                        const SizedBox(height: AppSpacing.md),
                        
                        Text(
                          widget.philosopher.name,
                          style: AppTextStyles.heading1.copyWith(
                            color: theme.textPrimary,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                        
                        const SizedBox(height: AppSpacing.xs),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${widget.philosopher.school} • ${widget.philosopher.era}',
                            style: AppTextStyles.caption.copyWith(
                              color: theme.primary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ).animate().fadeIn(delay: 300.ms),
                        
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Biography'),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: theme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.surface.withOpacity(0.5)),
                            boxShadow: AppShadows.card,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.philosopher.bio,
                                style: AppTextStyles.body.copyWith(
                                  height: 1.8, 
                                  color: theme.textSecondary
                                ),
                              ),
                              if (widget.philosopher.wikipediaUrl.isNotEmpty) ...[
                                const SizedBox(height: AppSpacing.md),
                                Divider(color: theme.textSecondary.withOpacity(0.1)),
                                const SizedBox(height: AppSpacing.xs),
                                InkWell(
                                  onTap: _launchWiki,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Icon(Icons.link, size: 16, color: theme.primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Read more on Wikipedia',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: theme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        Icon(Icons.arrow_forward_ios, size: 12, color: theme.textSecondary),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
                        
                        if (widget.philosopher.contemporaries.isNotEmpty || widget.philosopher.opponents.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xl),
                          _buildSectionHeader('Connections'),
                          const SizedBox(height: AppSpacing.sm),
                          if (widget.philosopher.contemporaries.isNotEmpty)
                            _buildRelationshipRow('Contemporaries', widget.philosopher.contemporaries, Icons.people_outline),
                          if (widget.philosopher.contemporaries.isNotEmpty && widget.philosopher.opponents.isNotEmpty)
                            const SizedBox(height: AppSpacing.md),
                          if (widget.philosopher.opponents.isNotEmpty)
                            _buildRelationshipRow('Opponents', widget.philosopher.opponents, Icons.compare_arrows),
                        ],

                        const SizedBox(height: AppSpacing.xl),
                        
                        _buildSectionHeader('Key Ideas'),
                        const SizedBox(height: AppSpacing.sm),
                        ...widget.philosopher.keyIdeas.asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: theme.surface,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: AppShadows.light,
                                border: Border.all(color: theme.surface),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.lightbulb_outline, color: theme.primary, size: 20),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: AppTextStyles.body.copyWith(color: theme.textPrimary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(delay: (500 + (entry.key * 100)).ms).slideX(begin: 0.1, end: 0);
                        }),
                        
                        const SizedBox(height: AppSpacing.xl),
                        
                        _buildSectionHeader('Wisdom Check'),
                        const SizedBox(height: AppSpacing.sm),
                        
                        _buildQuizSection(),
                        
                        const SizedBox(height: AppSpacing.xxxl),
                        const SizedBox(height: AppSpacing.xxxl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipRow(String title, List<String> items, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.textSecondary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: theme.textSecondary),
              const SizedBox(width: 8),
              Text(
                title, 
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold, 
                  color: theme.textSecondary
                )
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.textSecondary.withOpacity(0.2)),
              ),
              child: Text(item, style: AppTextStyles.caption.copyWith(color: theme.textPrimary)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(width: 4, height: 24, color: theme.primary, margin: const EdgeInsets.only(right: 8)),
        Text(
          title,
          style: AppTextStyles.heading3.copyWith(color: theme.textPrimary),
        ),
      ],
    );
  }

  Widget _buildQuizSection() {
    if (widget.philosopher.quizQuestions.isEmpty) return const SizedBox();

    if (_quizCompletedPreviously) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.primary.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.spa, color: theme.primary, size: 32),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Wisdom Attained',
              style: AppTextStyles.heading3.copyWith(color: theme.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You have absorbed the teachings of ${widget.philosopher.name}.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: theme.textSecondary),
            ),
          ],
        ),
      ).animate().fadeIn();
    }

    return Column(
      children: [
        if (!_showQuiz && _quizScore == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.textPrimary, theme.textPrimary.withOpacity(0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.secondary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.psychology_outlined, color: Colors.white, size: 48),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Test Your Understanding',
                  style: AppTextStyles.heading3.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Answer 3 questions to reflect on these teachings.',
                  style: AppTextStyles.body.copyWith(color: Colors.white.withOpacity(0.9)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () => setState(() => _showQuiz = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 2,
                  ),
                  child: const Text('Begin Reflection'),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 800.ms).scale(curve: Curves.easeOutBack),

        if (_showQuiz && _quizScore == null)
          QuizWidget(
            questions: widget.philosopher.quizQuestions,
            onComplete: (score) async {
              setState(() {
                _quizScore = score;
                _showQuiz = false;
              });
              
              if (score == widget.philosopher.quizQuestions.length) {
                await PointsService.instance.awardPoints(20);
                await PointsService.instance.completeQuiz(widget.philosopher.id);
                setState(() {
                   _quizCompletedPreviously = true;
                });
                // Check badges would go here
              }
            },
          ),
        
        if (_quizScore != null) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.primary.withOpacity(0.3)),
              boxShadow: AppShadows.light,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.primary.withOpacity(0.1),
                  child: Icon(Icons.check, color: theme.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reflection Complete',
                        style: AppTextStyles.heading3.copyWith(color: theme.primary),
                      ),
                      Text(
                        'Score: $_quizScore/${widget.philosopher.quizQuestions.length}',
                        style: AppTextStyles.body.copyWith(color: theme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.2, end: 0),
          
          const SizedBox(height: AppSpacing.lg),
          
          if (!_hasCompleted)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _markAsCompleted,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Complete Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
              ),
            ).animate().fadeIn(delay: 500.ms).shimmer()
          else
            Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DashboardScreen()),
                      );
                    },
                    icon: const Icon(Icons.dashboard_outlined),
                    label: const Text('Return to Garden'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.textPrimary,
                      side: BorderSide(color: theme.textSecondary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms),
              ],
            ),
        ],
      ],
    );
  }
}
