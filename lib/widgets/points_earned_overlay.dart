import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/constants.dart';
import '../utils/philosopher_assets.dart';

class PointsEarnedOverlay {
  static void show(BuildContext context, {required int points, String label = 'Wisdom', PhilosopherTheme? theme}) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    
    entry = OverlayEntry(
      builder: (context) => _PointsOverlayWidget(
        points: points,
        label: label,
        theme: theme,
        onDismiss: () => entry.remove(),
      ),
    );
    
    overlay.insert(entry);
  }
}

class _PointsOverlayWidget extends StatefulWidget {
  final int points;
  final String label;
  final PhilosopherTheme? theme;
  final VoidCallback onDismiss;

  const _PointsOverlayWidget({
    required this.points,
    required this.label,
    this.theme,
    required this.onDismiss,
  });

  @override
  State<_PointsOverlayWidget> createState() => _PointsOverlayWidgetState();
}

class _PointsOverlayWidgetState extends State<_PointsOverlayWidget> {
  
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 24,
      right: 24,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: theme?.surface ?? AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: (theme?.primary ?? AppColors.primary).withOpacity(0.4), width: 1),
            boxShadow: [
              BoxShadow(
                color: (theme?.primary ?? AppColors.primary).withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: (theme?.textPrimary ?? AppColors.textPrimary).withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (theme?.primary ?? AppColors.primary).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.spa,
                  color: theme?.primary ?? AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${widget.label} Earned',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme?.textSecondary ?? AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '+${widget.points} points',
                    style: AppTextStyles.heading3.copyWith(
                      color: theme?.primary ?? AppColors.primary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 24,
              ),
            ],
          ),
        )
            .animate()
            .slideY(begin: -1.5, end: 0, duration: 500.ms, curve: Curves.easeOutBack)
            .fadeIn(duration: 300.ms)
            .then(delay: 2000.ms)
            .fadeOut(duration: 400.ms)
            .slideY(begin: 0, end: -0.5),
      ),
    );
  }
}
