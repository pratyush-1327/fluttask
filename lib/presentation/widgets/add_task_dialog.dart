import 'package:dio/dio.dart';
import 'package:fluttask/presentation/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api/todo_api.dart';
import '../../core/utils/shared_prefs.dart';

class AddTaskDialog extends StatelessWidget {
  final WidgetRef ref;

  AddTaskDialog({required this.ref});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return AlertDialog(
      title: Text("Add New Task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: "Task Title"),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: "Task Description"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final title = titleController.text.trim();
            final description = descriptionController.text.trim();

            if (title.isEmpty || description.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Title and Description cannot be empty")));
              return;
            }

            final apiKey = await SharedPrefs.getApiKey();
            final api = TodoApi(Dio());
            await api.createTodo(apiKey, {
              "title": title,
              "description": description,
              "completed": false
            });
            ref.refresh(todoListProvider);
            Navigator.pop(context);
          },
          child: Text("Add"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
      ],
    );
  }
}
