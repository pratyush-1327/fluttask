import 'package:flutter/material.dart';
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

  Future<void> _saveApiKey() async {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      setState(() => _error = 'API Key cannot be empty');
      return;
    }
    try {
      final todoApiProvider = TodoApiProvider();
      final isValid = await todoApiProvider.validateApiKey(apiKey);
      if (isValid) {
        await SharedPrefs.saveApiKey(apiKey);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TodoScreen()),
        );
      } else {
        setState(() => _error = 'Invalid API Key or API Error (Code 201)');
      }
    } catch (e) {
      setState(() => _error = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter API Key')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _apiKeyController,
              decoration: InputDecoration(
                labelText: 'API Key',
                errorText: _error,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveApiKey,
              child: Text('Save & Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
