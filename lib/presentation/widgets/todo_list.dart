import 'package:dio/dio.dart';
import 'package:fluttask/presentation/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import '../../data/models/todo_model.dart';
import '../../data/api/todo_api.dart';
import '../../core/utils/shared_prefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoList extends StatelessWidget {
  final WidgetRef ref;
  final List<Todo> items;

  const TodoList({required this.items, required this.ref});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final todo = items[index];
        return Card(
          child: ListTile(
            title:
                Text(todo.title, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Description: ${todo.description}"),
              ],
            ),
            trailing: Switch(
              value: todo.completed,
              onChanged: (newValue) async {
                final apiKey = await SharedPrefs.getApiKey();
                final api = TodoApi(Dio());
                await api.updateTodo(apiKey, todo.id, {"completed": newValue});
                ref.refresh(todoListProvider);
              },
            ),
            onTap: () => _showTodoDetails(context, todo),
          ),
        );
      },
    );
  }

  void _showTodoDetails(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(todo.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Task ID: ${todo.id}"),
              Text("Description: ${todo.description}"),
              Text("Time: ${todo.timestamp}"),
              Text("Completed: ${todo.completed ? 'Yes' : 'No'}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final apiKey = await SharedPrefs.getApiKey();
                final api = TodoApi(Dio());
                await api.deleteTodo(apiKey, todo.id);
                ref.refresh(todoListProvider);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
