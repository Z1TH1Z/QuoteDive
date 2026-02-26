# Quotes App — Philosophy Learning Platform with Native Widget and Gamification

![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Android-green.svg)
![Architecture](https://img.shields.io/badge/Architecture-Offline--First-orange.svg)
![Database](https://img.shields.io/badge/Database-SQLite-lightgrey.svg)
![Status](https://img.shields.io/badge/Status-Production%20Ready-success.svg)
![License](https://img.shields.io/badge/License-Private-red.svg)

A production-ready Flutter application that delivers daily philosophy quotes through a native Android home screen widget, combined with structured learning, gamification, and offline-first architecture.

Designed and built end-to-end with scalable architecture, real-time widget synchronization, and persistent local state.

---

# Why This Project Matters

Most portfolio apps demonstrate UI.

This project demonstrates real-world mobile engineering skills:

• Native Android widget integration with Flutter  
• Offline-first architecture using SQLite  
• Real-time synchronization between widget and app  
• Modular and scalable service-based architecture  
• Full gamification engine implementation  
• Production-ready performance and structure  

This reflects real engineering practices used in production mobile applications.

---

# Screenshots

Create a folder named `screenshots` in the root directory and add images.

Example structure:

```
quotes_app/
├── screenshots/
│   ├── home.png
│   ├── deep_dive.png
│   ├── dashboard.png
│   └── widget.png
└── README.md
```

Then display them like this:

```
## Home Screen
<img src="screenshots/home.png" width="250"/>

## Deep Dive Interface
<img src="screenshots/deep_dive.png" width="250"/>

## Dashboard
<img src="screenshots/dashboard.png" width="250"/>

## Home Screen Widget
<img src="screenshots/widget.png" width="250"/>
```

---

# Demo Overview

Core user flow:

1. User sees daily quote directly on home screen widget  
2. Opens app to explore structured learning interface  
3. Earns points, unlocks badges, and builds streak  
4. Widget updates instantly to reflect progress  
5. All functionality works fully offline  

---

# Tech Stack

Framework  
Flutter 3.19+

Language  
Dart

Database  
SQLite

Platform Integration  
Native Android Widget  
Flutter Platform Channels  

Architecture  
Service-based modular architecture  
Offline-first design  

Tools  
Flutter SDK  
Android Studio  
Dart Analyzer  

---

# Architecture Overview

```
Presentation Layer
├── Screens
├── Widgets
└── Navigation

Business Logic Layer
├── Points Service
├── Widget Sync Service
└── Progress Management

Data Layer
├── SQLite Database
├── Local Models
└── Repository Logic

Platform Layer
├── Native Android Widget
└── Platform Channels
```

---

# Project Structure

```
lib/
├── main.dart
│
├── models/
│   ├── quote.dart
│   ├── philosopher.dart
│   ├── user_progress.dart
│   └── badge.dart
│
├── services/
│   ├── database_service.dart
│   ├── points_service.dart
│   └── widget_service.dart
│
├── screens/
│   ├── home_screen.dart
│   ├── deep_dive_screen.dart
│   ├── philosopher_profile_screen.dart
│   └── dashboard_screen.dart
│
├── widgets/
│
└── utils/
    └── constants.dart

assets/
├── quotes.json
└── philosophers.json
```

---

# Core Features

## Native Home Screen Widget

• Displays daily quote  
• Shows streak, level, and points  
• Updates automatically  
• Launches app on tap  
• Native Android implementation  

---

## Offline-First Architecture

• Fully functional without internet  
• Instant load times  
• Persistent SQLite storage  
• Fast and reliable access  

---

## Gamification Engine

• Points system  
• Streak tracking  
• Achievement badges  
• Quiz scoring system  
• Level progression  

---

## Structured Learning System

• Deep dive interface  
• Philosopher profiles  
• Quiz system with feedback  
• Audio playback  
• Search and filtering  

---

# Engineering Challenges Solved

## Real-Time Widget Synchronization

Implemented real-time widget updates using:

Flutter Application  
↓  
SQLite Database  
↓  
Widget Sync Service  
↓  
Native Android Widget  

Ensures widget always reflects latest progress.

---

## Offline Persistence System

Designed SQLite-based persistence layer ensuring:

• Fast access  
• Persistent user progress  
• No network dependency  

---

## Native Platform Integration

Implemented communication between Flutter and native Android widget using platform channels.

---

# Performance

App Launch Time  
< 1 second  

Database Access  
Optimized SQLite queries  

Widget Update Speed  
Near real-time  

Memory Usage  
Low  

---

# Installation

Clone repository

```
git clone https://github.com/yourusername/quotes_app.git
cd quotes_app
```

Install dependencies

```
flutter pub get
```

Run application

```
flutter run
```

---

# Testing

Run tests

```
flutter test
```

Static analysis

```
flutter analyze
```

---

# Build for Production

Android APK

```
flutter build apk --release
```

Android App Bundle (recommended)

```
flutter build appbundle --release
```

iOS

```
flutter build ios --release
```

---

# Scalability

Architecture supports future integration with:

• Firebase  
• Supabase  
• User authentication  
• Cloud sync  
• Multi-device support  
• iOS widgets  

---

# What This Project Demonstrates

Mobile Engineering  
• Flutter expertise  
• Native platform integration  
• Performance optimization  

System Design  
• Layered architecture  
• Modular service design  
• Persistent state management  

Product Engineering  
• Full product lifecycle implementation  
• User engagement systems  
• Production-ready architecture  

---

# Status

Version: 1.0.0  
Status: Production Ready  
Last Updated: February 2026  

---

# License

Private Project — All Rights Reserved
