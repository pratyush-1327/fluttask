import 'package:fluttask/data/models/todo_model.dart';
import 'package:fluttask/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/todo_provider.dart';
import '../../core/utils/shared_prefs.dart';
import '../widgets/todo_list.dart';
import '../widgets/add_task_dialog.dart';
import '../screens/api_key_screen.dart';
import '../../core/theme/theme.dart'; // Add this import

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  void _logout(WidgetRef ref, BuildContext context) async {
    await SharedPrefs.removeApiKey(ref);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ApiKeyScreen()),
    );
  }

  void _toggleTheme(BuildContext context, WidgetRef ref) {
    final currentTheme = Theme.of(context).brightness;
    final newTheme =
        currentTheme == Brightness.dark ? Brightness.light : Brightness.dark;
    ref.read(themeProvider.notifier).state = newTheme;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final completedTodos = ref.watch(completedTodosProvider);
    final pendingTodos = ref.watch(pendingTodosProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("FlutTask",
              style: Theme.of(context).textTheme.headlineMedium),
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          actions: [
            PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'logout') {
                  _logout(ref, context);
                } else if (result == 'theme') {
                  _toggleTheme(context, ref);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
                PopupMenuItem<String>(
                  value: 'theme',
                  child: Text(isDarkMode ? 'Light Mode' : 'Dark Mode'),
                ),
              ],
              icon: Icon(Icons.more_vert,
                  color: Theme.of(context).colorScheme.primary),
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
          // backgroundColor: Theme.of(context).colorScheme.secondary,
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
