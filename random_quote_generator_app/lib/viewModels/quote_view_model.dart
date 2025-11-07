import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:random_quote_generator_app/Services/hive_service.dart';
import '../model/quote_model.dart';

class QuoteViewModel extends ChangeNotifier {
  late QuoteModel _currentQuote;
  QuoteModel get currentQuote => _currentQuote;

  final _quotesBox = HiveService.getQuotesBox();
  final FlutterTts _flutterTts = FlutterTts();

  QuoteViewModel() {
    _initTTS();
    _generateRandomQuote();
  }

  // Public: replay current quote voice
  Future<void> replayVoice() async {
    try {
      await _flutterTts.stop();
      final textToSpeak = '"${_currentQuote.text}" by ${_currentQuote.author}';
      await _flutterTts.speak(textToSpeak);
    } catch (e) {
      // optional: handle/log errors
      if (kDebugMode) print("TTS replay error: $e");
    }
  }

  // 🗣 Initialize Text-to-Speech settings
  Future<void> _initTTS() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      if (kDebugMode) print("TTS init error: $e");
    }
  }

  // 🔀 Generate random quote from Hive box
  void _generateRandomQuote() {
    final quotes = _quotesBox.values.toList();
    if (quotes.isEmpty) {
      // fallback if Hive empty (avoid crash)
      _currentQuote = QuoteModel(
        text: "No quotes found",
        author: "uzair",
        imageUrl: 'image/uzair.jpg',
      );
    } else {
      final random = Random();
      _currentQuote = quotes[random.nextInt(quotes.length)];
    }
    notifyListeners();
  }

  // 🔁 Called when user taps "New Quote"
  Future<void> newQuote() async {
    _generateRandomQuote();
    await _speakQuote();
  }

  // 🗣 Speak the current quote aloud
  Future<void> _speakQuote() async {
    try {
      await _flutterTts.stop(); // stop previous voice if playing
      final textToSpeak = '"${_currentQuote.text}" by ${_currentQuote.author}';
      await _flutterTts.speak(textToSpeak);
    } catch (e) {
      if (kDebugMode) print("TTS speak error: $e");
    }
  }
}
