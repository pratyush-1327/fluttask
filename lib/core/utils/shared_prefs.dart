import 'package:fluttask/presentation/providers/todo_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SharedPrefs {
  static const _apiKey = "api_key";

  static Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKey, apiKey);
  }

  static Future<String> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKey) ?? "";
  }

  static Future<void> removeApiKey(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("api_key");
    await prefs.remove("_apiKey");
    ref.invalidate(todoListProvider);
  }
}
