import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final bool is_completed;
  final DateTime created_at;
  final DateTime updated_at;
  final bool is_synced;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.is_completed,
    required this.created_at,
    required this.updated_at,
    required this.is_synced,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? is_completed,
    DateTime? created_at,
    DateTime? updated_at,
    bool? is_synced,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      is_completed: is_completed ?? this.is_completed,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_synced: is_synced ?? this.is_synced,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    is_completed,
    created_at,
    updated_at,
    is_synced,
  ];
}
