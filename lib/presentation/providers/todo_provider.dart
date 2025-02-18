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

final addTodoProvider =
    FutureProvider.family<Todo, Map<String, String>>((ref, taskData) async {
  final apiKey = await SharedPrefs.getApiKey();

  if (apiKey.isEmpty) throw Exception("API Key not found");

  final title = taskData['title']?.trim() ?? "";
  final description = taskData['description']?.trim() ?? "";

  if (title.isEmpty || description.isEmpty) {
    throw Exception("Title and Description cannot be empty");
  }

  return await TodoApiProvider.addTodo(apiKey, title, description);
});

class TodoApiProvider {
  static Future<bool> validateApiKey(String apiKey) async {
    try {
      final dio = Dio();
      final api = TodoApi(dio);

      final response = await api.getTodos(apiKey);

      return response.isNotEmpty;
    } on DioException catch (e) {
      print(
          "API Key Validation Failed: ${e.response?.statusCode ?? e.message}");
      return false;
    } catch (e) {
      print("Unexpected Error: $e");
      return false;
    }
  }

  static Future<Todo> addTodo(
      String apiKey, String title, String description) async {
    if (title.isEmpty || description.isEmpty) {
      throw Exception("Title and description cannot be empty");
    }
    try {
      final dio = Dio();
      final api = TodoApi(dio);
      final newTodo = await api.createTodo(apiKey, {
        'title': title,
        'description': description,
      });
      return newTodo;
    } catch (e) {
      print("Error adding Todo: $e");
      throw Exception("Failed to add todo");
    }
  }
}
