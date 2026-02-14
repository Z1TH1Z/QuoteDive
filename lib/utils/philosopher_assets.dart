import 'package:flutter/material.dart';

/// Holds theme colors for a specific philosopher, derived from their SVG image palette.
class PhilosopherTheme {
  final Color primary;        // Main accent (buttons, highlights)
  final Color secondary;      // Secondary accent (chips, badges)
  final Color gradientStart;  // Background gradient top
  final Color gradientEnd;    // Background gradient bottom
  final Color surface;        // Card/surface color 
  final Color textPrimary;    // Main text
  final Color textSecondary;  // Subtitle text
  final Color quoteIcon;      // Quote mark color

  const PhilosopherTheme({
    required this.primary,
    required this.secondary,
    required this.gradientStart,
    required this.gradientEnd,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.quoteIcon,
  });

  LinearGradient get backgroundGradient => LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// Maps philosopher names to their unique SVG asset paths and color themes.
class PhilosopherAssets {

  static const String _defaultImage = 'assets/images/japan_scene.svg';

  // ── Themes derived from each philosopher's SVG image palette ──

  // Socrates → Forest-amico.svg: deep greens, earthy browns, misty atmosphere
  static const _socratesTheme = PhilosopherTheme(
    primary: Color(0xFF2D6A4F),        // Deep forest green
    secondary: Color(0xFFB7E4C7),      // Light mint
    gradientStart: Color(0xFFD8F3DC),  // Misty green
    gradientEnd: Color(0xFF52B788),    // Forest canopy
    surface: Color(0xFFF0FFF4),        // Pale green white
    textPrimary: Color(0xFF1B4332),    // Dark forest
    textSecondary: Color(0xFF40916C),  // Moss green
    quoteIcon: Color(0xFF74C69D),      // Sage leaf
  );

  // Marcus Aurelius → Island-bro.svg: ocean blues, sandy warmth, tropical sky
  static const _marcusTheme = PhilosopherTheme(
    primary: Color(0xFF0077B6),        // Deep ocean blue
    secondary: Color(0xFFCAF0F8),      // Sky foam
    gradientStart: Color(0xFFE8F4F8),  // Pale sky
    gradientEnd: Color(0xFF48CAE4),    // Tropical water
    surface: Color(0xFFF0F9FF),        // Ice white
    textPrimary: Color(0xFF023047),    // Midnight navy
    textSecondary: Color(0xFF0096C7),  // Mid-ocean
    quoteIcon: Color(0xFF90E0EF),      // Wave crest
  );

  // Nietzsche → Sunset-cuate.svg: dramatic oranges, deep reds, twilight purple
  static const _nietzscheTheme = PhilosopherTheme(
    primary: Color(0xFFD62828),        // Bold crimson
    secondary: Color(0xFFFCBF49),      // Sunset gold
    gradientStart: Color(0xFFFFF1E6),  // Warm mist
    gradientEnd: Color(0xFFF77F00),    // Burning orange
    surface: Color(0xFFFFF8F0),        // Warm parchment
    textPrimary: Color(0xFF3D0814),    // Dark maroon
    textSecondary: Color(0xFFC1121F),  // Ember red
    quoteIcon: Color(0xFFEAE2B7),      // Golden glow
  );

  // Lao Tzu → Cherry Blossom-bro.svg: soft pinks, delicate petals, spring air
  static const _laoTzuTheme = PhilosopherTheme(
    primary: Color(0xFFE07A90),        // Cherry blossom pink
    secondary: Color(0xFFFCE4EC),      // Petal blush
    gradientStart: Color(0xFFFFF0F3),  // Soft rose mist
    gradientEnd: Color(0xFFF8BBD0),    // Pink bloom
    surface: Color(0xFFFFF5F7),        // Petal white
    textPrimary: Color(0xFF5C1A2A),    // Deep plum
    textSecondary: Color(0xFFC2185B),  // Rose
    quoteIcon: Color(0xFFF48FB1),      // Light sakura
  );

  // Descartes → Tree life-bro.svg: verdant greens, rich trunk brown, natural
  static const _descartesTheme = PhilosopherTheme(
    primary: Color(0xFF588157),        // Leaf green
    secondary: Color(0xFFDAD7CD),      // Bark beige
    gradientStart: Color(0xFFF5F5DC),  // Soft beige
    gradientEnd: Color(0xFFA3B18A),    // Sage
    surface: Color(0xFFFEFAE0),        // Warm cream
    textPrimary: Color(0xFF344E41),    // Deep green
    textSecondary: Color(0xFF6B705C),  // Stone olive
    quoteIcon: Color(0xFFBC6C25),      // Bark terracotta
  );

  // Sartre → Time flies-amico.svg: cool blues, purples, teal, contemplative
  static const _sartreTheme = PhilosopherTheme(
    primary: Color(0xFF5E60CE),        // Royal purple
    secondary: Color(0xFFE2EDFF),      // Lavender mist
    gradientStart: Color(0xFFF0EFFF),  // Pale violet
    gradientEnd: Color(0xFF7B7FD8),    // Soft indigo
    surface: Color(0xFFF8F7FF),        // Ghost white
    textPrimary: Color(0xFF2B2D42),    // Dark indigo
    textSecondary: Color(0xFF6C63FF),  // Vivid violet
    quoteIcon: Color(0xFF9FA0FF),      // Light periwinkle
  );

  // Voltaire → Forest-bro.svg: natural greens, earth tones, Enlightenment warmth
  static const _voltaireTheme = PhilosopherTheme(
    primary: Color(0xFF386641),        // Dark green
    secondary: Color(0xFFC7E8AC),      // Light lime
    gradientStart: Color(0xFFEDF6E5),  // Pale meadow
    gradientEnd: Color(0xFF6A994E),    // Meadow green
    surface: Color(0xFFF4FBF0),        // Mint cream
    textPrimary: Color(0xFF1A3A1A),    // Very dark green
    textSecondary: Color(0xFF43723A),  // Hunter green
    quoteIcon: Color(0xFFA7C957),      // Yellow-green
  );

  // Fallback theme (matches original Zen Garden palette)
  static const _defaultTheme = PhilosopherTheme(
    primary: Color(0xFFA3B18A),        // Sage Green
    secondary: Color(0xFFE9EDC9),      // Warm Sand
    gradientStart: Color(0xFFDAD7CD),  // Mist
    gradientEnd: Color(0xFFA3B18A),    // Sage
    surface: Color(0xFFFEFAE0),        // Cream
    textPrimary: Color(0xFF2F3E46),    // Dark Olive
    textSecondary: Color(0xFF52796F),  // Deep Moss
    quoteIcon: Color(0xFFBC6C25),      // Terracotta
  );

  static const Map<String, PhilosopherTheme> _themeMap = {
    'Socrates': _socratesTheme,
    'Marcus Aurelius': _marcusTheme,
    'Friedrich Nietzsche': _nietzscheTheme,
    'Lao Tzu': _laoTzuTheme,
    'René Descartes': _descartesTheme,
    'Jean-Paul Sartre': _sartreTheme,
    'Voltaire': _voltaireTheme,
    'Plato': _platoTheme,
    'Aristotle': _aristotleTheme,
    'Confucius': _confuciusTheme,
    'Albert Camus': _camusTheme,
  };

  // Plato → Reuse Marcus (Classical Blue) or similar. Let's use custom for now but map to default image if needed.
  // Actually, we can reuse existing SVGs that fit the "vibe" until new ones are added.
  // Plato: Academy -> Tree life-bro.svg (Descartes) or specialized?
  // Let's use existing ones as placeholders:
  // Plato -> Socrates image (Greek)
  // Aristotle -> Marcus image (Greek/Roman)
  // Confucius -> Lao Tzu image (Chinese)
  // Camus -> Sartre image (French Existentialist)
  
  static const Map<String, String> _imageMap = {
    'Socrates': 'assets/images/philosopher_socrates.svg',
    'Marcus Aurelius': 'assets/images/philosopher_marcus.svg',
    'Friedrich Nietzsche': 'assets/images/philosopher_nietzsche.svg',
    'Lao Tzu': 'assets/images/philosopher_laotzu.svg',
    'René Descartes': 'assets/images/philosopher_descartes.svg',
    'Jean-Paul Sartre': 'assets/images/philosopher_sartre.svg',
    'Voltaire': 'assets/images/philosopher_voltaire.svg',
    'Plato': _defaultImage,
    'Aristotle': _defaultImage,
    'Confucius': _defaultImage,
    'Albert Camus': _defaultImage,
  };

  // ... (Existing themes) ...

  // Plato Theme: Intellectual Blue & Marble White
  static const _platoTheme = PhilosopherTheme(
    primary: Color(0xFF0077B6),        // Greek sea blue
    secondary: Color(0xFFADE8F4),      // Pale sky
    gradientStart: Color(0xFFF0F8FF),  // Alice blue
    gradientEnd: Color(0xFF90E0EF),    // Light cyan
    surface: Color(0xFFFFFFFF),        // Marble white
    textPrimary: Color(0xFF023E8A),    // Deep royal blue
    textSecondary: Color(0xFF0096C7),  // Ocean
    quoteIcon: Color(0xFF48CAE4),      // Sky blue
  );

  // Aristotle Theme: Golden Mean & Earth
  static const _aristotleTheme = PhilosopherTheme(
    primary: Color(0xFFDAA520),        // Goldenrod
    secondary: Color(0xFFF4EDB9),      // Parchment
    gradientStart: Color(0xFFFFFDF0),  // Cream
    gradientEnd: Color(0xFFF0E68C),    // Khaki
    surface: Color(0xFFFFFFF0),        // Ivory
    textPrimary: Color(0xFF5D4037),    // Brown
    textSecondary: Color(0xFF8D6E63),  // Light brown
    quoteIcon: Color(0xFFFFD700),      // Gold
  );

  // Confucius Theme: Imperial Red & Gold
  static const _confuciusTheme = PhilosopherTheme(
    primary: Color(0xFFB71C1C),        // Red
    secondary: Color(0xFFFFD54F),      // Amber
    gradientStart: Color(0xFFFFF8E1),  // Pale amber
    gradientEnd: Color(0xFFFFECB3),    // Soft gold
    surface: Color(0xFFFFEBEE),        // Red tint white
    textPrimary: Color(0xFF3E2723),    // Dark brown
    textSecondary: Color(0xFFD32F2F),  // Red accent
    quoteIcon: Color(0xFFFFCA28),      // Gold
  );

  // Camus Theme: Mediterranean Teal & Sand (The Stranger/Sisyphus)
  static const _camusTheme = PhilosopherTheme(
    primary: Color(0xFF00897B),        // Teal
    secondary: Color(0xFFB2DFDB),      // Light teal
    gradientStart: Color(0xFFE0F2F1),  // Mint mist
    gradientEnd: Color(0xFF26A69A),    // Sea green
    surface: Color(0xFFFAFAFA),        // White
    textPrimary: Color(0xFF004D40),    // Dark teal
    textSecondary: Color(0xFF00695C),  // Teal
    quoteIcon: Color(0xFF4DB6AC),      // Soft teal
  );

  /// Returns the SVG asset path for a philosopher by name.
  static String getImage(String philosopherName) {
    final cleanName = philosopherName.trim();
    if (!_imageMap.containsKey(cleanName)) {
      debugPrint('PhilAssets: Image not found for "$cleanName" (original: "$philosopherName")');
    }
    return _imageMap[cleanName] ?? _defaultImage;
  }

  /// Returns the SVG asset path for the deep dive screen based on the quote's author.
  static String getDeepDiveImage(String authorName) {
    final cleanName = authorName.trim();
    return _imageMap[cleanName] ?? 'assets/images/zen_tree.svg';
  }

  /// Returns the dynamic color theme for a philosopher/author.
  static PhilosopherTheme getTheme(String name) {
    final cleanName = name.trim();
    if (!_themeMap.containsKey(cleanName)) {
      debugPrint('PhilAssets: Theme not found for "$cleanName" (original: "$name")');
    }
    return _themeMap[cleanName] ?? _defaultTheme;
  }
}
