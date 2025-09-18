import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:g_task/core/errors/failures.dart';
import 'package:g_task/core/usecases/usecase.dart';
import 'package:g_task/features/tasks/domain/entities/task.dart';
import 'package:g_task/features/tasks/domain/repositories/task_repository.dart';

class UpdateTask extends UseCase<Task, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(UpdateTaskParams params) {
    return repository.updateTask(params.task);
  }
}

class UpdateTaskParams extends Equatable {
  final Task task;

  const UpdateTaskParams({required this.task});

  @override
  List<Object> get props => [task];
}
