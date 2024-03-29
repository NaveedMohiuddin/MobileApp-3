import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/models/flashcard.dart';
import '/utils/db_helper.dart';
import 'dart:convert';
import 'CardsPage.dart';
import 'CategoryEditPage.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final dbHelper = DBHelper();

  Future<void> _loadData() async {
    final jsonString = await rootBundle.loadString('assets/flashcards.json');
    final jsonData = json.decode(jsonString);

    for (var item in jsonData) {
      final category = Category(title: item['title']);
      final categoryId = await category.save();

      final flashcards = item['flashcards'];
      for (var flashcardData in flashcards) {
        final flashcard = Flashcard(
          categoryId: categoryId,
          question: flashcardData['question'] ?? '',
          answer: flashcardData['answer'] ?? '',
        );
        flashcard.save();
      }
    }

    setState(() {});
  }

  Future<void> _clearDatabase() async {
    await dbHelper.clearDatabase();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        title: Text("Flashcards App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              _loadData();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _clearDatabase();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 600;
          final fontSize = isLargeScreen ? 20.0 : 16.0;
          final screenWidth = constraints.maxWidth;
          int crossAxisCount = 2;

          if (screenWidth > 600) {
            crossAxisCount = 4;
          } else if (screenWidth > 400) {
            crossAxisCount = 2;
          }

          return FutureBuilder(
            future: dbHelper.queryCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final categories = snapshot.data as List<Map<String, dynamic>>;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = Category.fromMap(categories[index]);
                    return Card(
                      color: const Color.fromARGB(222, 93, 241, 197),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      margin: EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CardsPage(category: category),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment(1.0, -1.0),
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryEditPage(category: category),
                                    ),
                                  )
                                      .then((refresh) {
                                    if (refresh != null && refresh) {
                                      setState(() {});
                                    }
                                  });
                                },
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    category.title,
                                    style: TextStyle(fontSize: fontSize),
                                  ),
                                ),
                                FutureBuilder(
                                  future: dbHelper.queryFlashcards(
                                    where: 'categoryId = ?',
                                    whereArgs: [category.id],
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      final flashcards = snapshot.data
                                          as List<Map<String, dynamic>>;
                                      return Text(
                                          'Flashcards Count: ${flashcards.length}');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => CategoryEditPage(),
            ),
          )
              .then((refresh) {
            if (refresh != null && refresh) {
              setState(() {});
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
