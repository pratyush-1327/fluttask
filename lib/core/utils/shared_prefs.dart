import 'package:fluttask/presentation/providers/todo_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SharedPrefs {
  static const _apiKeyKey = "api_key";

  static Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey);
  }

  static Future<String> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey) ?? "";
  }

  static Future<void> removeApiKey(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKeyKey);
    ref.invalidate(todoListProvider); // Clear cached todo list after logout
  }
}
