import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/database_service.dart';
import 'services/widget_service.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseService.instance.database;
  
  // Initialize widget
  await WidgetService.instance.initialize();
  
  runApp(const QuotesApp());
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  Future<bool> _checkOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.secondary,
          onSecondary: AppColors.textPrimary,
          error: AppColors.accent,
          onError: Colors.white,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          background: AppColors.background,
          onBackground: AppColors.textPrimary,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: TextTheme(
          displayLarge: AppTextStyles.heading1,
          displayMedium: AppTextStyles.heading2,
          displaySmall: AppTextStyles.heading3,
          bodyLarge: AppTextStyles.body,
          bodyMedium: AppTextStyles.body,
          labelLarge: AppTextStyles.button,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 4,
          shadowColor: AppColors.shadow.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: AppTextStyles.button,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            shadowColor: AppColors.primary.withOpacity(0.4),
          ),
        ),
      ),
      home: FutureBuilder<bool>(
        future: _checkOnboardingComplete(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          final onboardingComplete = snapshot.data ?? false;
          return onboardingComplete ? const HomeScreen() : const OnboardingScreen();
        },
      ),
    );
  }
}
