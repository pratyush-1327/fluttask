import 'package:dio/dio.dart';
import 'package:fluttask/presentation/providers/todo_provider.dart';
import 'package:fluttask/presentation/widgets/todo_bottom_sheet.dart';
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
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Card(
            elevation: 4,
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              title: Text(
                todo.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description: ${todo.description}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Time: ${todo.createdAt}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              trailing: StatefulBuilder(
                builder: (context, setState) {
                  return Switch(
                    value: todo.status == "completed",
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (newValue) async {
                      final apiKey = await SharedPrefs.getApiKey();
                      final api = TodoApi(Dio());
                      await api.updateTodo(apiKey, todo.id,
                          {"status": newValue ? "completed" : "pending"});
                      ref.refresh(todoListProvider);
                      setState(() {});
                    },
                  );
                },
              ),
              onTap: () => showTodoBottomSheet(context, todo, ref),
            ),
          ),
        );
      },
    );
  }
}
