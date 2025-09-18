import 'package:dartz/dartz.dart' hide Task;
import 'package:g_task/core/errors/failures.dart';
import 'package:g_task/features/tasks/domain/entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks();

  Future<Either<Failure, Task>> createTask(Task task);

  Future<Either<Failure, Task>> updateTask(Task task);

  Future<Either<Failure, void>> deleteTask(String id);

  Future<Either<Failure, void>> syncTasks();
}
