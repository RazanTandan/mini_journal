# Mini Journal

A simple journaling app built with Flutter and Firebase. Each journal entry is capped at 250 words.

## Features

- Add, view, and delete journal entries
- 250 word limit per entry with live word counter
- Data persists via Firebase Firestore
- Swipe left to delete an entry

## Tech Stack

- Flutter
- Firebase Firestore

## Getting Started

1. Clone the repo
2. Run `flutter pub get`
3. Set up Firebase and run `flutterfire configure`
4. Run the app with `flutter run`

## Project Structure

```
lib/
├── main.dart               # App entry point and home screen
├── add_entry_screen.dart   # New entry form
├── entry_detail_screen.dart # View a single entry
├── journal_service.dart    # All Firestore logic
└── firebase_options.dart   # Auto-generated Firebase config
```

## Status

Work in progress — built as a learning project.