import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Zen Garden Palette
  static const primary = Color(0xFFA3B18A); // Sage Green
  static const secondary = Color(0xFFE9EDC9); // Warm Sand
  static const accent = Color(0xFFBC6C25); // Muted Terracotta
  static const background = Color(0xFFF1FAEE); // Soft Parchment / Mist
  static const surface = Color(0xFFFEFAE0); // Off-white / Cream
  
  static const textPrimary = Color(0xFF2F3E46); // Dark Olive / Charcoal
  static const textSecondary = Color(0xFF52796F); // Deep Moss
  static const textLight = Color(0xFF84A98C); // Muted Green
  
  static const success = Color(0xFF10B981); // Emerald 500
  static const warning = Color(0xFFF59E0B); // Amber 500
  static const error = Color(0xFFEF4444); // Red 500
  static const shadow = Color(0xFF2F3E46); // Same as textPrimary, used for shadows

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFFDAD7CD), Color(0xFFA3B18A)], // Mist to Sage
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const surfaceGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFFEFAE0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTextStyles {
  static final heading1 = GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final heading2 = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final heading3 = GoogleFonts.playfairDisplay(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final body = GoogleFonts.lato(
    fontSize: 16,
    color: AppColors.textPrimary,
    height: 1.6, // Relaxed line height
  );

  static final bodySecondary = GoogleFonts.lato(
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static final caption = GoogleFonts.lato(
    fontSize: 12,
    color: AppColors.textLight,
    letterSpacing: 0.5,
  );

  static final quote = GoogleFonts.playfairDisplay(
    fontSize: 30, // Slightly larger
    fontWeight: FontWeight.w500, // Medium
    fontStyle: FontStyle.italic,
    color: AppColors.textPrimary,
    height: 1.6, // More breathing room
  );
  
  static final author = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: AppColors.textSecondary,
  );
  
  static final bodySmall = GoogleFonts.lato(
    fontSize: 13,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static final button = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1.0,
  );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

class AppShadows {
  static final light = [
    BoxShadow(
      color: AppColors.textPrimary.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  static final medium = [
    BoxShadow(
      color: AppColors.textPrimary.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  static final glow = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.2),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static final card = [
    BoxShadow(
      color: AppColors.textPrimary.withOpacity(0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}

class AppConstants {
  static const String appName = 'QuoteDive';
  static const String appTagline = 'Daily wisdom for modern life';
  
  // Point values
  static const int readQuotePoints = 10;
  static const int deepDivePoints = 30;
  static const int philosopherProfilePoints = 50;
  static const int dailyStreakPoints = 5;
}
