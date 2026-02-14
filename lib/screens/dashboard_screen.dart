import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../models/user_progress.dart';
import '../models/badge.dart' as app_badge;
import '../services/points_service.dart';
import '../utils/constants.dart';
import '../widgets/badge_unlock_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserProgress? _progress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await PointsService.instance.getUserProgress();
    setState(() {
      _progress = progress;
      _isLoading = false;
    });
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
        title: Text('Your Journey', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadProgress();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Zen Background
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),
          
          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderStats(),
                        const SizedBox(height: AppSpacing.xl),
                        _buildLevelProgress(),
                        const SizedBox(height: AppSpacing.xl),
                        Text('Badges Collection', style: AppTextStyles.heading2).animate().fadeIn(delay: 400.ms),
                        const SizedBox(height: AppSpacing.md),
                        _buildBadgeGrid(),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Points',
            '${_progress!.totalPoints}',
            Icons.spa, // Zen icon
            AppColors.accent,
            0,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatCard(
            'Streak',
            '${_progress!.currentStreak}',
            Icons.local_fire_department, // Keep fire for streak, or maybe a sun?
            AppColors.warning,
            200,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, int delay) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textPrimary.withOpacity(0.05)),
        boxShadow: AppShadows.light,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: AppTextStyles.heading1.copyWith(color: AppColors.textPrimary, fontSize: 36),
          ).animate().scale(delay: (delay + 200).ms, duration: 400.ms, curve: Curves.easeOutBack),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).slideX();
  }

  Widget _buildLevelProgress() {
    final progressToNext = (_progress!.totalPoints % 100) / 100.0;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Level ${_progress!.level}', style: AppTextStyles.heading2),
              Text('${(_progress!.totalPoints % 100)} / 100 XP', style: AppTextStyles.bodySecondary),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressToNext,
              backgroundColor: AppColors.background,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 12,
            ),
          ).animate().shimmer(duration: 2.seconds, delay: 1.seconds),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${100 - (_progress!.totalPoints % 100)} points to Level ${_progress!.level + 1}',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildBadgeGrid() {
    final allBadges = app_badge.BadgeDefinitions.allBadges;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.8,
      ),
      itemCount: allBadges.length,
      itemBuilder: (context, index) {
        final badge = allBadges[index];
        final isUnlocked = _progress!.unlockedBadges.contains(badge.id);
        
        return _buildBadgeItem(badge, isUnlocked, index);
      },
    );
  }

  Widget _buildBadgeItem(app_badge.Badge badge, bool isUnlocked, int index) {
    return Tooltip(
      message: '${badge.name}\n${badge.description}',
      triggerMode: TooltipTriggerMode.tap,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? AppColors.surface : AppColors.background.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: isUnlocked 
              ? Border.all(color: AppColors.primary.withOpacity(0.3)) 
              : Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: isUnlocked ? AppShadows.light : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              badge.icon,
              style: TextStyle(
                fontSize: 32,
                color: isUnlocked ? null : Colors.grey.withOpacity(0.3),
              ),
            ).animate(target: isUnlocked ? 1 : 0).scale(duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                badge.name,
                style: AppTextStyles.caption.copyWith(
                  color: isUnlocked ? AppColors.textPrimary : AppColors.textLight,
                  fontSize: 10,
                  fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (400 + (index * 50)).ms).scale(),
    );
  }
}
