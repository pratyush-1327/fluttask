import 'package:fluttask/core/theme/theme.dart';
import 'package:fluttask/core/theme/util.dart';
import 'package:fluttask/presentation/screens/api_key_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/screens/todo_screen.dart';
import 'core/utils/shared_prefs.dart';
import 'presentation/providers/todo_provider.dart';

final themeProvider = StateProvider<Brightness>((ref) => Brightness.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiKey = await SharedPrefs.getApiKey();
  final todoApiProvider = TodoApiProvider();

  bool isValid =
      apiKey.isNotEmpty && await todoApiProvider.validateApiKey(apiKey);

  runApp(ProviderScope(
      child: MyApp(initialRoute: isValid ? TodoScreen() : ApiKeyScreen())));
}

class MyApp extends ConsumerWidget {
  final Widget initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = ref.watch(themeProvider); // Watch the themeProvider
    TextTheme textTheme = createTextTheme(context, "Inter", "ABeeZee");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: initialRoute,
    );
  }
}
