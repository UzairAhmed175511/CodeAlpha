import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:random_quote_generator_app/Services/hive_service.dart';
import '../model/quote_model.dart';

class QuoteViewModel extends ChangeNotifier {
  late QuoteModel _currentQuote;
  QuoteModel get currentQuote => _currentQuote;

  final _quotesBox = HiveService.getQuotesBox();

  QuoteViewModel() {
    _generateRandomQuote();
  }

  void _generateRandomQuote() {
    final quotes = _quotesBox.values.toList();
    final random = Random();
    _currentQuote = quotes[random.nextInt(quotes.length)];
    notifyListeners();
  }

  void newQuote() {
    _generateRandomQuote();
  }
}
