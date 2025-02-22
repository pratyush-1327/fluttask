import 'package:fluttask/data/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/todo_provider.dart';
import '../../core/utils/shared_prefs.dart';
import '../widgets/todo_list.dart';
import '../widgets/add_task_dialog.dart';
import '../screens/api_key_screen.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final completedTodos = ref.watch(completedTodosProvider);
    final pendingTodos = ref.watch(pendingTodosProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("FlutTask",
              style: Theme.of(context).textTheme.headlineMedium),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          actions: [
            IconButton(
              icon: Icon(Icons.logout,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () async {
                await SharedPrefs.removeApiKey(ref);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ApiKeyScreen()),
                );
              },
            ),
          ],
          bottom: TabBar(
            labelStyle: Theme.of(context).textTheme.bodyLarge,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Completed"),
              Tab(text: "Pending"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTodoList(context, todos, ref),
            _buildTodoList(context, completedTodos, ref),
            _buildTodoList(context, pendingTodos, ref),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AddTaskDialog(ref: ref),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child:
              Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary),
        ),
      ),
    );
  }

  Widget _buildTodoList(
      BuildContext context, AsyncValue<List<Todo>> todos, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(todoListProvider);
      },
      child: todos.when(
        data: (items) => TodoList(
          items: items,
          ref: ref,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child:
              Text("Error: $err", style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );
  }
}
