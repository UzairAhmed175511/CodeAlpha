import 'package:hive_flutter/hive_flutter.dart';
import '../model/quote_model.dart';

class HiveService {
  static const String boxName = 'quotesBox';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(QuoteModelAdapter());
    await Hive.openBox<QuoteModel>(boxName);

    final box = Hive.box<QuoteModel>(boxName);

    // Add sample quotes only if box is empty
    if (box.isEmpty) {
      await box.addAll([
        QuoteModel(
          text: "Be yourself; everyone else is already taken.",
          author: "Oscar Wilde",
        ),
        QuoteModel(
          text: "The best way to predict the future is to invent it.",
          author: "Alan Kay",
        ),
        QuoteModel(
          text: "In the middle of every difficulty lies opportunity.",
          author: "Albert Einstein",
        ),
        QuoteModel(
          text:
              "Success is not final, failure is not fatal: it is the courage to continue that counts.",
          author: "Winston Churchill",
        ),
        QuoteModel(
          text: "Do what you can, with what you have, where you are.",
          author: "Theodore Roosevelt",
        ),
      ]);
    }
  }

  static Box<QuoteModel> getQuotesBox() => Hive.box<QuoteModel>(boxName);
}
