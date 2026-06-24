# Peblo AI Story Buddy - Mobile App Developer Challenge

An interactive, responsive Flutter application designed as an engaging storytelling companion for children. The app features dynamic story tracking, text-to-speech audio narration, and real-time comprehension quizzes.

## 🚀 Key Features Implemented

* **Dynamic Story Engine:** Manages a branchable, multi-page story layout smoothly using structural state updates.
* **Text-to-Speech (TTS):** Integrated native audio narration so children can listen along to the story text dynamically.
* **Comprehension Quiz System:** Fully functional quiz evaluation logic featuring interactive choices, instant feedback, and progress tracking.
* **State Management:** Handled cleanly using the `provider` architecture to maintain separation of UI and business logic.

## 🛠️ Tech Stack & Architecture

* **Framework:** Flutter (Dart)
* **State Management:** Provider
* **Packages Used:** `flutter_tts`, `provider`

## 📂 Project Structure Explainer

* `lib/main.dart` — Core app configuration, themes, and screen routing.
* `lib/app_provider.dart` — Global application state, story page progression, and text-to-speech control flows.
* `lib/quiz_model.dart` — Data models handling quiz structures, answer validation, and story content definitions.
* `pubspec.yaml` — Configured project dependencies and assets.
