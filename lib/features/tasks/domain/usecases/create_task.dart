import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:g_task/core/errors/failures.dart';
import 'package:g_task/core/usecases/usecase.dart';
import 'package:g_task/features/tasks/domain/entities/task.dart';
import 'package:g_task/features/tasks/domain/repositories/task_repository.dart';

class CreateTask extends UseCase<Task, CreateTaskParams> {
  final TaskRepository repository;

  CreateTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(CreateTaskParams params) {
    return repository.createTask(params.task);
  }
}

class CreateTaskParams extends Equatable {
  final Task task;

  const CreateTaskParams({required this.task});

  @override
  List<Object> get props => [task];
}
