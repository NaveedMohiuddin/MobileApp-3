import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final List<Map<String, dynamic>> flashcards;
  QuizPage({required this.flashcards});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  bool isAnswerRevealed = false;
  int questionsNavigatedCount = 1;
  int answersPeekedCount = 0;
  bool hasNavigatedCurrentQuestion = false;
  bool hasPeekedAnswerForCurrentCard = false;
  bool isFlipped = false;
  late List<bool> hasNavigatedQuestion;
  Set<int> visitedTiles = {};
  Set<int> flippedTiles = {};

  @override
  void initState() {
    super.initState();
    shuffleFlashcards();
    hasNavigatedQuestion =
        List.generate(widget.flashcards.length, (index) => false);
  }

  void shuffleFlashcards() {
    widget.flashcards.shuffle();
    currentQuestionIndex = 0;
    isAnswerRevealed = false;
    questionsNavigatedCount = 1;
    answersPeekedCount = 0;
    hasNavigatedCurrentQuestion = false;
    hasPeekedAnswerForCurrentCard = false;
    visitedTiles.add(currentQuestionIndex);
  }

  void showNextQuestion() {
    if (currentQuestionIndex < widget.flashcards.length - 1) {
      currentQuestionIndex++;
      if (!visitedTiles.contains(currentQuestionIndex)) {
        questionsNavigatedCount++;
        visitedTiles.add(currentQuestionIndex);
      }

      setState(() {
        visitedTiles.add(currentQuestionIndex);
        isAnswerRevealed = false;
        hasPeekedAnswerForCurrentCard = false;
        isFlipped = false; // Reset the flip state
      });
    }
  }

  void showPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      currentQuestionIndex--;
      if (!visitedTiles.contains(currentQuestionIndex)) {
        questionsNavigatedCount++;
        visitedTiles.add(currentQuestionIndex);
      }

      setState(() {
        visitedTiles.add(currentQuestionIndex);
        isAnswerRevealed = false;
        isFlipped = false; // Reset the flip state
      });
    }
  }

  void toggleAnswerVisibility() {
    if (isFlipped) {
      setState(() {
        isFlipped = false;
      });
    } else {
      setState(() {
        isFlipped = true;
        if (!flippedTiles.contains(currentQuestionIndex)) {
          answersPeekedCount++;
          flippedTiles.add(currentQuestionIndex);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        title: Text("Quiz Flashcards"),
      ),
      body: isLandscape
          ? Row(
              children: <Widget>[
                Container(
                  width: 300,
                  child: Card(
                    color: Colors.white,
                    elevation: 10.0,
                    margin: EdgeInsets.all(16.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.flashcards[currentQuestionIndex]['question'],
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (isFlipped)
                            Text(
                              widget.flashcards[currentQuestionIndex]['answer'],
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: showPreviousQuestion,
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: toggleAnswerVisibility,
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: showNextQuestion,
                    ),
                    SizedBox(width: 20),
                    Text(
                        "Questions Navigated: $questionsNavigatedCount \n\n Answers Peeked: $answersPeekedCount"),
                  ],
                ),
              ],
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 350,
                      height: 450,
                      child: Card(
                        elevation: 10.0,
                        margin: EdgeInsets.all(16.0),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.flashcards[currentQuestionIndex]
                                    ['question'],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (isFlipped)
                                Text(
                                  widget.flashcards[currentQuestionIndex]
                                      ['answer'],
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: showPreviousQuestion,
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: toggleAnswerVisibility,
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: showNextQuestion,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text(
                        "Questions Navigated: $questionsNavigatedCount of ${widget.flashcards.length}"),
                    SizedBox(height: 16.0),
                    Text(
                        "Answers Peeked: $answersPeekedCount of $questionsNavigatedCount"),
                  ],
                ),
              ),
            ),
    );
  }
}
