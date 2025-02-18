import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo {
  final int id;
  final String title;
  final String description;
  final bool completed;
  final DateTime timestamp;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.timestamp,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Untitled',
      description: json['description'] as String? ?? 'No description',
      completed: (json['completed'] as bool?) ?? false,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
