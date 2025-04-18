import 'package:dio/dio.dart';
import 'package:fluttask/presentation/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api/todo_api.dart';
import '../../core/utils/shared_prefs.dart';
import '../../data/models/todo_model.dart';

class AddTaskDialog extends StatelessWidget {
  final WidgetRef ref;

  AddTaskDialog({required this.ref});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add New Task",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Task Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Task Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final description = descriptionController.text.trim();

                    if (title.isEmpty || description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            const Text("Title and Description cannot be empty"),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ));
                      return;
                    }

                    final apiKey = await SharedPrefs.getApiKey();
                    final api = ref.read(todoApiProvider);

                    // Use the TodoCreate model
                    final newTodo = TodoCreate(
                      title: title,
                      description: description,
                    );

                    await api.createTodo(apiKey, newTodo.toJson());
                    await ref.refresh(todoListProvider);
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Add"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
