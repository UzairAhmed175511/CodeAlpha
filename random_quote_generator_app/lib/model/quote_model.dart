import 'package:hive/hive.dart';

part 'quote_model.g.dart';

@HiveType(typeId: 0)
class QuoteModel extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  String author;

  @HiveField(2)
  String imageUrl;

  QuoteModel({
    required this.text,
    required this.author,
    required this.imageUrl,
  });
}
