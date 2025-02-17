import 'package:shared_preferences/shared_preferences.dart';

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
}
