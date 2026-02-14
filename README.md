# Quotes App - Daily Philosophy Widget

A Flutter mobile app that delivers daily philosophy quotes via home screen widgets, with gamified learning through deep dives into philosophers and their ideas.

## Features

✅ **Home Screen Widget** - Daily quotes with progress tracking on your home screen 🎯
✅ **Deep Dive Learning** - 3-card swipeable interface with context and modern meaning
✅ **Philosopher Profiles** - Learn about great thinkers
✅ **Interactive Quizzes** - Test your knowledge with instant feedback
✅ **Gamification** - Points, streaks, levels, and 19 badges
✅ **Progress Dashboard** - Track your learning journey
✅ **Search & Categories** - Find quotes by philosopher or category
✅ **Share Quotes** - Share beautiful quote cards on social media
✅ **Onboarding Flow** - Smooth introduction for new users
✅ **Offline-First** - All content works without internet

## Current Status

### Phase 1: Foundation ✅ COMPLETE
- ✅ Project structure created
- ✅ Data models (Quote, Philosopher, UserProgress, Badge)
- ✅ SQLite database with sample content
- ✅ Points system with streak multipliers
- ✅ Home screen with daily quote
- ✅ Deep dive 3-card interface
- ✅ Philosopher profile screens
- ✅ Dashboard with stats and badges

### Phase 2: Deep Learning ✅ COMPLETE
- ✅ Audio playback (Text-to-Speech)
- ✅ Interactive quiz system (3 questions per philosopher)
- ✅ Expanded to 20 quotes (doubled!)
- ✅ Added 7th philosopher (Voltaire)
- ✅ Quiz scoring with bonus points
- ✅ Instant feedback and explanations

### Phase 3: Gamification ✅ COMPLETE
- ✅ Expanded badge system (19 badges total)
- ✅ Badge unlock animations
- ✅ Search screen with full-text search
- ✅ Category filters (7 categories)
- ✅ Category-specific tracking

### Phase 4: Polish ✅ COMPLETE
- ✅ Quote sharing functionality
- ✅ 3-screen onboarding flow
- ✅ Share dialog with preview
- ✅ Production-ready polish

### Phase 5: Widget Implementation ✅ COMPLETE
- ✅ Android home screen widget
- ✅ Real-time progress tracking on widget
- ✅ Daily quote display
- ✅ Streak and points counter
- ✅ Auto-updates when earning points
- ✅ Beautiful gradient design

### What Works Now
1. **Home Screen Widget** - Shows daily quote, streak, today's points, level, and total points 📱
2. **Daily Quote Display** - Shows a different quote each day
3. **Audio Playback** - Listen to quotes read aloud 🎵
4. **Points System** - Earn points for reading quotes (10 pts), deep dives (30 pts), and profiles (50 pts)
5. **Interactive Quizzes** - Test your knowledge with 3 questions per philosopher 🎯
6. **Bonus Points** - Perfect quiz score = +20 bonus points
7. **Streak Tracking** - Daily streaks with multipliers (up to 2x at 30 days)
8. **19 Badges** - Unlock achievements for various milestones
9. **Badge Animations** - Delightful unlock animations
10. **Progress Dashboard** - View points, level, streak, and unlocked badges
11. **Search & Filter** - Find quotes by text, philosopher, or category
12. **Share Quotes** - Create beautiful quote cards for social media
13. **Onboarding** - Smooth 3-screen introduction for new users
14. **20 Curated Quotes** - From 7 great philosophers
15. **21 Quiz Questions** - Learn and test your knowledge
16. **Widget Auto-Updates** - Widget refreshes when you earn points

### Next Steps (Phase 3-4)
- [ ] Home screen widget (Android/iOS)
- [ ] More badges (expand to 25 total)
- [ ] Widget customization (themes, fonts)
- [ ] Sharing functionality
- [ ] Onboarding flow
- [ ] Search and filters

## Getting Started

### Prerequisites
- Flutter SDK 3.19+
- Android Studio or Xcode
- Android/iOS emulator or physical device

### Installation

1. **Clone and navigate:**
```bash
cd quotes_app
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app:**
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── quote.dart
│   ├── philosopher.dart
│   ├── user_progress.dart
│   └── badge.dart
├── services/                 # Business logic
│   ├── database_service.dart
│   ├── points_service.dart
│   └── widget_service.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── deep_dive_screen.dart
│   ├── philosopher_profile_screen.dart
│   └── dashboard_screen.dart
├── widgets/                  # Reusable widgets
└── utils/                    # Constants and helpers
    └── constants.dart

assets/
├── quotes.json              # 10 sample quotes
└── philosophers.json        # 6 philosopher profiles
```

## How to Use

### Adding the Widget 📱
1. **Long press** on your Android home screen
2. Tap **Widgets** from the menu
3. Find and select **Quotes App**
4. **Drag** the widget to your home screen
5. **Tap the widget** to open the app

See `WIDGET_GUIDE.md` for detailed instructions and troubleshooting.

### Using the App
1. **Launch the app** - See today's quote on the home screen
2. **Tap "Deep Dive"** - Earn 10 points and explore the quote's meaning
3. **Swipe through cards** - Learn context and modern application (30 pts)
4. **Meet the Philosopher** - Read their biography and key ideas (50 pts)
5. **Take Quizzes** - Test your knowledge for bonus points
6. **Check Dashboard** - View your progress, streaks, and badges
7. **Search Quotes** - Find quotes by philosopher or category
8. **Share Quotes** - Create beautiful cards for social media
9. **Come back daily** - Build streaks for point multipliers!
10. **Watch your widget** - See your progress grow on your home screen

## Sample Data

### Philosophers Included:
- Socrates (Ancient Greece)
- Marcus Aurelius (Stoicism)
- Friedrich Nietzsche (Existentialism)
- Lao Tzu (Taoism)
- René Descartes (Rationalism)
- Jean-Paul Sartre (Existentialism)
- Voltaire (Enlightenment) 🆕

### Quote Categories:
- Ancient Philosophy
- Stoicism
- Existentialism
- Eastern Philosophy
- Modern Philosophy
- Enlightenment 🆕

## Gamification System

### Points
- Read quote: 10 pts
- Complete deep dive: 30 pts
- Complete philosopher profile: 50 pts
- Perfect quiz score (3/3): +20 pts 🆕
- Daily streak: 5 pts

### Streak Multipliers
- 3+ days: 1.2x
- 7+ days: 1.5x
- 14+ days: 1.8x
- 30+ days: 2.0x

### Badges (19 Available)
- 🌱 First Steps - Read your first quote
- 🔥 Committed - 3-day streak
- 💪 Disciplined - 7-day streak
- 👑 Master of Habit - 30-day streak
- 🗺️ Explorer - 5 philosophers
- 📚 Scholar - 10 philosophers
- ⭐ Seeker - 100 points
- 🎖️ Philosopher - 500 points
- 🏆 Sage - 1000 points
- 🛡️ Stoic Starter - 10 Stoic quotes
- 🧘 Eastern Explorer - 10 Eastern quotes
- 🤔 Existentialist - 10 Existentialism quotes
- 📖 Bookworm - 25 quotes read
- 🎓 Graduate - 50 quotes read
- 🌟 Enlightened - 100 quotes read
- 🎯 Quiz Master - Complete 5 quizzes
- 🏅 Perfect Score - Get 3/3 on a quiz
- 💎 Completionist - Complete all philosophers
- 🔮 Wisdom Seeker - 2000 points

## Testing

```bash
# Run tests
flutter test

# Check for issues
flutter analyze

# Run on specific device
flutter devices
flutter run -d <device_id>
```

## Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release
```

## Known Limitations

- Widget currently Android-only (iOS widget coming soon)
- Limited to 20 quotes (will expand to 50+ in future updates)
- Widget updates every 30 minutes (plus instant updates when earning points)

## Files & Documentation

- `README.md` - This file
- `WIDGET_GUIDE.md` - Detailed widget setup and troubleshooting
- `QUICK_START.md` - Quick start guide
- `APP_WALKTHROUGH.md` - Feature walkthrough
- `DEVELOPMENT_PLAN.md` - Full development roadmap
- `PROJECT_COMPLETE.md` - Project completion summary

## Contributing

This is an MVP in active development. See `DEVELOPMENT_PLAN.md` for the full roadmap.

## License

Private project - All rights reserved

---

**Version:** 1.0.0 (All Phases Complete + Widget)  
**Last Updated:** Feb 4, 2026  
**Status**: Production Ready ✅ 🎉
