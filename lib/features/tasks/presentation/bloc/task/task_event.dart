part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();
}

final class LoadTasksEvent extends TaskEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class CreateTaskEvent extends TaskEvent {
  final String title;
  final String? description;

  const CreateTaskEvent({required this.title, this.description});

  @override
  List<Object?> get props => [title, description];
}

final class UpdateTaskEvent extends TaskEvent {
  final Task task;

  const UpdateTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

final class DeleteTaskEvent extends TaskEvent {
  final String id;

  const DeleteTaskEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

final class ToggleTaskCompletionEvent extends TaskEvent {
  final Task task;

  const ToggleTaskCompletionEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

final class SyncTasksEvent extends TaskEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
