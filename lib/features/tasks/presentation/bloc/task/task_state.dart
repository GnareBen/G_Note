part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();
}

final class TaskInitial extends TaskState {
  @override
  List<Object> get props => [];
}

final class TaskLoading extends TaskState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class TaskLoaded extends TaskState {
  final List<Task> tasks;

  const TaskLoaded({required this.tasks});

  @override
  List<Object?> get props => [tasks];
}

final class TaskError extends TaskState {
  final String message;

  const TaskError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class TaskOperationSuccess extends TaskState {
  final String message;

  const TaskOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
