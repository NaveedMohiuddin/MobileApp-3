import 'package:flutter/material.dart';
import '/models/flashcard.dart';
//import '/utils/db_helper.dart';

class CategoryEditPage extends StatefulWidget {
  final Category? category;

  CategoryEditPage({this.category});

  @override
  _CategoryEditPageState createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  final categoryController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      categoryController.text = widget.category!.title;
      isEditing = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        title: Text(isEditing ? "Edit Category" : "Add Category"),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category Name'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(222, 93, 241, 197)),
                ),
                onPressed: () async {
                  if (isEditing) {
                    final updatedCategory = Category(
                      id: widget.category!.id,
                      title: categoryController.text,
                    );
                    await updatedCategory.update();
                  } else {
                    final newCategory =
                        Category(title: categoryController.text);
                    await newCategory.save();
                  }

                  Navigator.pop(context, true);
                },
                child: Text(isEditing ? 'Save' : 'Add Category'),
              ),
              if (isEditing)
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(222, 93, 241, 197)),
                  ),
                  onPressed: () async {
                    await widget.category!.delete();
                    Navigator.pop(context, true);
                  },
                  child: Text('Delete'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
