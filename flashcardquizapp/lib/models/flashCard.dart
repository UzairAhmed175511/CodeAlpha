import 'dart:convert';

class Flashcard {
  String question;
  String answer;

  Flashcard({required this.question, required this.answer});

  // Convert Flashcard → Map (for JSON encoding)
  Map<String, dynamic> toMap() {
    return {'question': question, 'answer': answer};
  }

  // Convert Map → Flashcard (for decoding)
  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
    );
  }

  // Convert Flashcard → JSON String
  String toJson() => json.encode(toMap());

  // Convert JSON String → Flashcard
  factory Flashcard.fromJson(String source) =>
      Flashcard.fromMap(json.decode(source));
}
