import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo {
  final int id;
  final String title;
  final String description;
  final String status;
  final DateTime timestamp;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.timestamp,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Untitled',
      description: json['description'] as String? ?? 'No description',
      status: json['status'] as String? ?? 'pending',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp']) ??
              DateTime.fromMillisecondsSinceEpoch(0)
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
