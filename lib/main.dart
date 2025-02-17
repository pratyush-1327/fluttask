import 'package:fluttask/presentation/screens/api_key_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/screens/todo_screen.dart';
import 'core/utils/shared_prefs.dart';
import 'presentation/providers/todo_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiKey = await SharedPrefs.getApiKey();

  bool isValid =
      apiKey.isNotEmpty && await TodoApiProvider.validateApiKey(apiKey);

  runApp(ProviderScope(
      child: MyApp(initialRoute: isValid ? TodoScreen() : ApiKeyScreen())));
}

class MyApp extends StatelessWidget {
  final Widget initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ToDo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: initialRoute,
    );
  }
}
