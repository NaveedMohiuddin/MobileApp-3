import '/utils/db_helper.dart';

class Category {
  int? id;
  final String title;

  Category({
    this.id,
    required this.title,
  });
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      title: map['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  Future<int> save() async {
    final dbHelper = DBHelper();
    id = await dbHelper.insert('categories', toMap());
    return id!;
  }

  Future<void> update() async {
    if (id != null) {
      final dbHelper = DBHelper();
      await dbHelper.update('categories', toMap());
    }
  }

  Future<void> delete() async {
    if (id != null) {
      final dbHelper = DBHelper();
      await dbHelper.delete('categories', id!);
    }
  }
}

class Flashcard {
  int? id;
  int categoryId;
  String question;
  String answer;

  Flashcard({
    this.id,
    required this.categoryId,
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'question': question,
      'answer': answer,
    };
  }

  int compareByQuestion(Flashcard other) {
    return question.compareTo(other.question);
  }

  Future<int> save() async {
    final dbHelper = DBHelper();
    id = await dbHelper.insert('flashcards', toMap());
    return id!;
  }

  Future<void> update() async {
    if (id != null) {
      final dbHelper = DBHelper();
      await dbHelper.update('flashcards', toMap());
    }
  }

  Future<void> delete() async {
    if (id != null) {
      final dbHelper = DBHelper();
      await dbHelper.delete('flashcards', id!);
    }
  }
}
