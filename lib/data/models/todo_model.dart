import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo {
  final int id;
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int? ?? 0, // Defaults to 0 if null
      title: json['title'] as String? ?? 'Untitled', // Default title
      completed:
          (json['completed'] as bool?) ?? false, // Ensures a non-null bool
    );
  }

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
