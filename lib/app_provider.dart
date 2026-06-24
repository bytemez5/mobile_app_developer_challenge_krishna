import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'quiz_model.dart';

enum AppState { idle, loading, playing, completed, error }

class AppProvider extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  
  AppState _currentState = AppState.idle;
  QuizModel? _quiz;
  String _errorMessage = '';
  bool _showQuiz = false;

  AppState get currentState => _currentState;
  QuizModel? get quiz => _quiz;
  String get errorMessage => _errorMessage;
  bool get showQuiz => _showQuiz;

  AppProvider() {
    _initTts();
    _loadQuizData();
  }

  void _loadQuizData() {
    final Map<String, dynamic> data = jsonDecode(jsonPayload);
    _quiz = QuizModel.fromJson(data);
    notifyListeners();
  }

  void _initTts() {
    _flutterTts.setStartHandler(() {
      _currentState = AppState.playing;
      notifyListeners();
    });

    _flutterTts.setCompletionHandler(() {
      _currentState = AppState.completed;
      _showQuiz = true; // This matches requirement: smoothly reveal quiz when audio ends!
      notifyListeners();
    });

    _flutterTts.setErrorHandler((msg) {
      _currentState = AppState.error;
      _errorMessage = "Oops! Pip's voice box is tired. Let's try again!";
      notifyListeners();
    });
  }

  Future<void> readStory(String text) async {
    _currentState = AppState.loading;
    notifyListeners();
    
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      _currentState = AppState.error;
      _errorMessage = "Failed to play audio. Check your speaker setup!";
      notifyListeners();
    }
  }
}