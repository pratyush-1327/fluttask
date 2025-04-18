import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/shared_prefs.dart';
import '../providers/todo_provider.dart';
import 'todo_screen.dart';

class ApiKeyScreen extends StatefulWidget {
  @override
  _ApiKeyScreenState createState() => _ApiKeyScreenState();
}

class _ApiKeyScreenState extends State<ApiKeyScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  String? _error;
  bool _isLoading = false;

  Future<void> _saveApiKey() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      setState(() {
        _error = 'API Key cannot be empty';
        _isLoading = false;
      });
      return;
    }
    try {
      final todoApiProvider = TodoApiProvider();
      final isValid = await todoApiProvider.validateApiKey(apiKey);
      if (isValid) {
        await SharedPrefs.saveApiKey(apiKey);
        // ref.invalidate(todoListProvider);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TodoScreen()),
        );
      } else {
        setState(() => _error = 'Invalid API Key or API Error (Code 201)');
      }
    } catch (e) {
      setState(() => _error = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(title: Text('Enter API Key')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/presentation/images/splant.png"),
            fit: BoxFit.none,
            alignment: Alignment(-3, 1.6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 40,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome !\nEnter your API Key \nto login",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              TextField(
                controller: _apiKeyController,
                decoration: InputDecoration(
                  labelText: 'API Key',
                  errorText: _error,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have one?",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () => launchUrl(Uri.parse(
                          'https://todocrud.chiggydoes.tech/register')),
                      child: Text(
                        "Click Here",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveApiKey,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Save & Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
