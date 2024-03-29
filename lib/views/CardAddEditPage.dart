import 'package:flutter/material.dart';
import '/models/flashcard.dart';
//import '/utils/db_helper.dart';

class CardAddEditPage extends StatefulWidget {
  final Category category;
  final Flashcard? flashcard;
  final Function onFlashcardEdited;

  CardAddEditPage({
    required this.category,
    this.flashcard,
    required this.onFlashcardEdited,
  });

  @override
  _CardAddEditPageState createState() => _CardAddEditPageState();
}

class _CardAddEditPageState extends State<CardAddEditPage> {
  final questionController = TextEditingController();
  final answerController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    if (widget.flashcard != null) {
      isEditing = true;
      questionController.text = widget.flashcard!.question;
      answerController.text = widget.flashcard!.answer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        title: Text(isEditing ? 'Edit Flashcard' : 'Add Flashcard'),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: questionController,
                decoration: InputDecoration(labelText: 'Question'),
              ),
              TextField(
                controller: answerController,
                decoration: InputDecoration(labelText: 'Answer'),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(222, 93, 241, 197)),
                    ),
                    onPressed: () {
                      final question = questionController.text;
                      final answer = answerController.text;
                      final categoryId = widget.category.id ?? 0;

                      if (isEditing) {
                        final updatedFlashcard = Flashcard(
                          id: widget.flashcard!.id,
                          categoryId: categoryId,
                          question: question,
                          answer: answer,
                        );

                        updatedFlashcard.save().then((_) {
                          widget.onFlashcardEdited();
                          Navigator.of(context).pop(true);
                        });
                      } else {
                        final flashcard = Flashcard(
                          categoryId: categoryId,
                          question: question,
                          answer: answer,
                        );
                        flashcard.save().then((refresh) {
                          widget.onFlashcardEdited();
                          Navigator.of(context).pop(true);
                        });
                      }
                    },
                    child: Text('Save'),
                  ),
                  if (isEditing)
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(222, 93, 241, 197)),
                      ),
                      onPressed: () {
                        widget.flashcard!.delete().then((_) {
                          widget.onFlashcardEdited();
                          Navigator.of(context).pop(true);
                        });
                      },
                      child: Text('Delete'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
