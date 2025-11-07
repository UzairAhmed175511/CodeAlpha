import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard.dart';

class FlashcardViewModel extends ChangeNotifier {
  final List<Flashcard> _flashcards = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  List<Flashcard> get flashcards => _flashcards;
  int get currentIndex => _currentIndex;
  bool get showAnswer => _showAnswer;
  Flashcard get currentCard => _flashcards[_currentIndex];

  FlashcardViewModel() {
    _loadFlashcards();
  }

  // -------------------- Persistence --------------------
  Future<void> _saveFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = _flashcards
        .map((card) => card.toJson())
        .toList();
    await prefs.setStringList('flashcards', jsonList);
  }

  Future<void> _loadFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList('flashcards');
    if (jsonList != null) {
      _flashcards.clear();
      _flashcards.addAll(jsonList.map((e) => Flashcard.fromJson(e)));
      notifyListeners();
    } else {
      // If empty, load demo cards
      _flashcards.addAll([
        Flashcard(
          question: "What is Flutter?",
          answer: "A UI toolkit by Google.",
        ),
        Flashcard(question: "What is Dart?", answer: "A language for Flutter."),
      ]);
      await _saveFlashcards();
    }
  }

  // -------------------- Card Logic --------------------
  void nextCard() {
    if (_currentIndex < _flashcards.length - 1) {
      _currentIndex++;
      _showAnswer = false;
      notifyListeners();
    }
  }

  void previousCard() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _showAnswer = false;
      notifyListeners();
    }
  }

  void toggleAnswer() {
    _showAnswer = !_showAnswer;
    notifyListeners();
  }

  Future<void> addCard(String question, String answer) async {
    _flashcards.add(Flashcard(question: question, answer: answer));
    await _saveFlashcards();
    notifyListeners();
  }

  Future<void> editCard(int index, String question, String answer) async {
    _flashcards[index] = Flashcard(question: question, answer: answer);
    await _saveFlashcards();
    notifyListeners();
  }

  Future<void> deleteCard(int index) async {
    _flashcards.removeAt(index);
    if (_currentIndex >= _flashcards.length && _flashcards.isNotEmpty) {
      _currentIndex = _flashcards.length - 1;
    }
    await _saveFlashcards();
    notifyListeners();
  }
}
