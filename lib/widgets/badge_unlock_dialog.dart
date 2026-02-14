import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/badge.dart' as app_badge;
import '../utils/constants.dart';
import '../utils/philosopher_assets.dart';

class BadgeUnlockDialog extends StatelessWidget {
  final app_badge.Badge badge;
  final PhilosopherTheme? theme;

  const BadgeUnlockDialog({super.key, required this.badge, this.theme});

  static Future<void> show(BuildContext context, app_badge.Badge badge, {PhilosopherTheme? theme}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BadgeUnlockDialog(badge: badge, theme: theme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: theme?.surface ?? AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Badge icon with animation
            Text(
              badge.icon,
              style: const TextStyle(fontSize: 80),
            )
                .animate()
                .scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                )
                .then()
                .shake(hz: 2, duration: 400.ms),

            const SizedBox(height: AppSpacing.lg),

            // "Badge Unlocked!" text
            Text(
              'Badge Unlocked!',
              style: AppTextStyles.heading2.copyWith(
                color: theme?.primary ?? AppColors.primary,
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.3, end: 0),

            const SizedBox(height: AppSpacing.md),

            // Badge name
            Text(
              badge.name,
              style: AppTextStyles.heading3.copyWith(
                color: theme?.textPrimary ?? AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: AppSpacing.sm),

            // Badge description
            Text(
              badge.description,
              style: AppTextStyles.bodySecondary.copyWith(
                color: theme?.textSecondary ?? AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ).animate(delay: 400.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: AppSpacing.xl),

            // Close button
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme?.primary ?? AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Awesome!'),
            ).animate(delay: 600.ms).fadeIn(duration: 400.ms).scale(),
          ],
        ),
      ),
    );
  }
}
