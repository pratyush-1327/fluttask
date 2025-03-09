import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo {
  final int id;
  final String title;
  final String description;
  final String status;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.createdAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}

@JsonSerializable()
class TodoCreate {
  final String title;
  final String description;

  TodoCreate({
    required this.title,
    required this.description,
  });

  factory TodoCreate.fromJson(Map<String, dynamic> json) =>
      _$TodoCreateFromJson(json);
  Map<String, dynamic> toJson() => _$TodoCreateToJson(this);
}

@JsonSerializable()
class TodoUpdate {
  final String? title;
  final String? description;
  final String? status;

  TodoUpdate({this.title, this.description, this.status});

  factory TodoUpdate.fromJson(Map<String, dynamic> json) =>
      _$TodoUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$TodoUpdateToJson(this);
}
