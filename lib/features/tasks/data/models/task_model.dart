import 'package:g_task/features/tasks/domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    super.description,
    required super.is_completed,
    required super.created_at,
    required super.updated_at,
    required super.is_synced,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      is_completed: json['is_completed'] as bool? ?? false,
      created_at: DateTime.parse(json['created_at'] as String),
      updated_at: DateTime.parse(json['updated_at'] as String),
      is_synced: json['is_synced'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': is_completed ? 1 : 0,
      'created_at': created_at.toIso8601String(),
      'updated_at': updated_at.toIso8601String(),
      'is_synced': is_synced ? 1 : 0,
    };
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      is_completed: task.is_completed,
      created_at: task.created_at,
      updated_at: task.updated_at,
      is_synced: task.is_synced,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': is_completed ? 1 : 0,
      'created_at': created_at.millisecondsSinceEpoch,
      'updated_at': updated_at.millisecondsSinceEpoch,
      'is_synced': is_synced ? 1 : 0,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      is_completed: map['is_completed'] == 1,
      created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updated_at: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      is_synced: map['is_synced'] == 1,
    );
  }
}
