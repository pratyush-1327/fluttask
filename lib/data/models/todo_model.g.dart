// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'created_at': instance.createdAt,
    };

TodoCreate _$TodoCreateFromJson(Map<String, dynamic> json) => TodoCreate(
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$TodoCreateToJson(TodoCreate instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };

TodoUpdate _$TodoUpdateFromJson(Map<String, dynamic> json) => TodoUpdate(
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$TodoUpdateToJson(TodoUpdate instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
    };
