import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api/todo_api.dart';
import '../../data/models/todo_model.dart';
import '../../core/utils/shared_prefs.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider((ref) => Dio());

final todoApiProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return TodoApi(dio);
});

final todoApiProviderNotifier =
    NotifierProvider<TodoApiProvider, void>(TodoApiProvider.new);

final todoListProvider = FutureProvider<List<Todo>>((ref) async {
  final api = ref.watch(todoApiProvider);
  final apiKey = await SharedPrefs.getApiKey();

  if (apiKey.isEmpty) throw Exception("API Key not found");

  try {
    final todos = await api.getTodos(apiKey);
    return todos;
  } catch (e) {
    throw Exception("Failed to fetch todos: $e");
  }
});

final completedTodosProvider = Provider<AsyncValue<List<Todo>>>((ref) {
  final todos = ref.watch(todoListProvider);
  return todos.when(
    data: (list) => AsyncValue.data(
        list.where((todo) => todo.status == 'completed').toList()),
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});

final pendingTodosProvider = Provider<AsyncValue<List<Todo>>>((ref) {
  final todos = ref.watch(todoListProvider);
  return todos.when(
    data: (list) => AsyncValue.data(
        list.where((todo) => todo.status == 'pending').toList()),
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});

final addTodoProvider =
    FutureProvider.family<Todo, Map<String, String>>((ref, taskData) async {
  final apiKey = await SharedPrefs.getApiKey();
  if (apiKey.isEmpty) throw Exception("API Key not found");

  final title = taskData['title']?.trim() ?? "";
  final description = taskData['description']?.trim() ?? "";

  if (title.isEmpty || description.isEmpty) {
    throw Exception("Title and Description cannot be empty");
  }

  return await ref
      .read(todoApiProviderNotifier.notifier)
      .addTodo(apiKey, title, description);
});

class TodoApiProvider extends Notifier<void> {
  late final TodoApi api;

  @override
  void build() {
    api = ref.read(todoApiProvider);
  }

  Future<bool> validateApiKey(String apiKey) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        "https://todocrud.chiggydoes.tech/todos/",
        options: Options(headers: {"X-API-Key": apiKey}),
      );
      if (response.statusCode == 200) return true;
      if (response.statusCode == 401) return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print("Invalid API Key: \${e.response?.statusCode}");
        return false;
      }
      print("API Validation Error: \${e.response?.statusCode ?? e.message}");
    } catch (e) {
      print("Unexpected Error: $e");
    }
    return false;
  }

  Future<Todo> addTodo(String apiKey, String title, String description) async {
    if (title.isEmpty || description.isEmpty) {
      throw Exception("Title and description cannot be empty");
    }
    try {
      return await api.createTodo(apiKey, {
        'title': title,
        'description': description,
      });
    } catch (e) {
      print("Error adding Todo: \$e");
      throw Exception("Failed to add todo");
    }
  }
}
