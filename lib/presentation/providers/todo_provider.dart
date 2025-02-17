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
    print("Fetched Todos: $todos"); // Debugging log
    return todos;
  } catch (e) {
    print("Error fetching Todos: $e");
    throw Exception("Failed to fetch todos");
  }
});

class TodoApiProvider {
  static Future<bool> validateApiKey(String apiKey) async {
    try {
      final dio = Dio();
      final api = TodoApi(dio);

      final response = await api.getTodos(apiKey);

      if (response != null && response.isNotEmpty) {
        print("API Key is valid ");
        return true;
      } else {
        print("API Key is invalid ");
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("API Key Validation Failed: ${e.response?.statusCode}");
      } else {
        print("API Key Validation Error: ${e.message}");
      }
      return false;
    } catch (e) {
      print("Unexpected Errror: $e");
      return false;
    }
  }
}
