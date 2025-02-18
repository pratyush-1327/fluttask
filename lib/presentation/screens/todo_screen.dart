import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/todo_provider.dart';
import '../widgets/todo_list.dart';
import '../widgets/add_task_dialog.dart';

class TodoScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(title: Text("ToDo List")),
      body: todos.when(
        data: (items) => TodoList(
          items: items,
          ref: ref,
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddTaskDialog(ref: ref),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
