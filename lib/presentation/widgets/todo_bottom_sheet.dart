import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/todo_model.dart';
import '../../data/api/todo_api.dart';
import '../../core/utils/shared_prefs.dart';
import '../providers/todo_provider.dart';

void showTodoBottomSheet(BuildContext context, Todo todo, WidgetRef ref) {
  TextEditingController titleController =
      TextEditingController(text: todo.title);
  TextEditingController descriptionController =
      TextEditingController(text: todo.description);

  showModalBottomSheet(
    // backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 8),
            Text("Task ID: ${todo.id}",
                style: Theme.of(context).textTheme.bodyMedium),
            Text("Time: ${todo.createdAt}",
                style: Theme.of(context).textTheme.bodyMedium),
            Text("Status: ${todo.status}",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final apiKey = await SharedPrefs.getApiKey();
                    final api = ref.read(todoApiProvider);
                    await api.deleteTodo(apiKey, todo.id);
                    await ref.refresh(todoListProvider);
                    Navigator.pop(context);
                  },
                  child: Text("Delete",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final updatedTitle = titleController.text.trim();
                    final updatedDescription =
                        descriptionController.text.trim();
                    if (updatedTitle.isNotEmpty &&
                        updatedDescription.isNotEmpty) {
                      final apiKey = await SharedPrefs.getApiKey();
                      final api = ref.read(todoApiProvider);
                      await api.updateTodo(apiKey, todo.id, {
                        "title": updatedTitle,
                        "description": updatedDescription,
                      });
                      await ref.refresh(todoListProvider);
                    }
                    Navigator.pop(context);
                  },
                  child: Text("Update",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
