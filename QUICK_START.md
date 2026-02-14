# Quick Start Guide

Get the Quotes App running in 5 minutes!

## Step 1: Verify Flutter Installation

```cmd
flutter doctor
```

Make sure you see:
- ✅ Flutter (Channel stable)
- ✅ Android toolchain
- ✅ Connected device or emulator

## Step 2: Get Dependencies

```cmd
cd quotes_app
flutter pub get
```

## Step 3: Start an Emulator (if needed)

### Android:
```cmd
# List available emulators
flutter emulators

# Launch one
flutter emulators --launch <emulator_id>
```

### Or use Android Studio:
- Open Android Studio
- Click "Device Manager"
- Click ▶️ on any device

## Step 4: Run the App

```cmd
flutter run
```

That's it! The app should launch on your device/emulator.

## What You'll See

1. **Home Screen** - Today's quote with "Deep Dive" button
2. **Tap Deep Dive** - Swipe through 3 cards (quote → context → meaning)
3. **Meet Philosopher** - Learn about the thinker behind the quote
4. **Dashboard Icon** (top right) - View your points, streaks, and badges

## Quick Test Flow

1. Launch app → See quote → Tap "Deep Dive" (+10 pts)
2. Swipe through all 3 cards (+30 pts)
3. Tap "Meet the Philosopher" button
4. Scroll to bottom → Tap "Complete Profile" (+50 pts)
5. Go back → Tap dashboard icon (top right)
6. See your 90 points, Level 1, and unlocked badges!

## Troubleshooting

### "No devices found"
```cmd
# Check connected devices
flutter devices

# If none, start an emulator or connect a phone
```

### "Build failed"
```cmd
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### "Hot reload not working"
- Press `r` in terminal for hot reload
- Press `R` for hot restart
- Or save the file in VS Code

## Development Tips

### Hot Reload
- Save any file to see changes instantly
- No need to restart the app

### Useful Commands
```cmd
# Hot reload
r

# Hot restart
R

# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

### VS Code Setup
1. Install "Flutter" extension
2. Press F5 to run with debugger
3. Use breakpoints for debugging

## Next Steps

- Read `README.md` for full feature list
- Check `DEVELOPMENT_PLAN.md` for roadmap
- See `REQUIREMENTS.md` for detailed setup

## Need Help?

Common issues:
- **App crashes on start**: Check `flutter doctor` output
- **Database errors**: Delete app and reinstall
- **Widget not showing**: Not implemented yet (Phase 2)

---

**Estimated Time:** 5 minutes  
**Difficulty:** Beginner-friendly  
**Result:** Working app with 10 quotes, 6 philosophers, and gamification!
