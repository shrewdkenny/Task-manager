import 'package:flutter/material.dart';
import 'package:to_do/constants/colors.dart';
import 'package:to_do/constants/texts.dart';
import 'package:to_do/enum/task_status.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  final MyTexts texts = MyTexts();
  final textController = TextEditingController();

  final List<Map<String, dynamic>> _todoItems = [];

  void addTasks() {
    if (textController.text.isNotEmpty) {
      setState(() {
        _todoItems.add({
          'task': textController.text,
          'status': TaskStatus.incomplete, // Use enum for initial status
        });
        textController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            texts.snackBarText,
            style: const TextStyle(
              color: MyColors.snackBarColor,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: MyColors.appBarColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void removeTask(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      _todoItems[index]['status'] =
          _todoItems[index]['status'] == TaskStatus.incomplete
              ? TaskStatus.complete
              : TaskStatus.incomplete;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          texts.title,
          style: const TextStyle(color: MyColors.titleColor),
        ),
        centerTitle: true,
        backgroundColor: MyColors.appBarColor,
        toolbarHeight: screenHeight * 0.06,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Stack(
              children: [
                TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: texts.hintText,
                    filled: true,
                    fillColor: MyColors.fillColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: MyColors.fillColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: MyColors.fillColor,
                      ),
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    addTasks();
                  },
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: addTasks,
                    icon: const Icon(
                      Icons.add,
                      size: 40,
                      color: MyColors.appBarColor,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Checkbox(
                          value: _todoItems[index]['status'] ==
                              TaskStatus.complete,
                          onChanged: (value) {
                            toggleTaskCompletion(index);
                          },
                          activeColor: MyColors.appBarColor,
                        ),
                        title: Text(
                          _todoItems[index]['task'],
                          style: TextStyle(
                            decoration: _todoItems[index]['status'] ==
                                    TaskStatus.complete
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () => removeTask(index),
                          icon: const Icon(
                            Icons.delete,
                            size: 30,
                          ),
                        ),
                        tileColor: MyColors.tileColor,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
