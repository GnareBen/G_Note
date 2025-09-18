import 'package:dartz/dartz.dart' hide Task;
import 'package:g_task/core/errors/failures.dart';
import 'package:g_task/core/usecases/usecase.dart';
import 'package:g_task/features/tasks/domain/entities/task.dart';
import 'package:g_task/features/tasks/domain/repositories/task_repository.dart';

class GetTasks extends UseCase<List<Task>, NoParams> {
  final TaskRepository repository;

  GetTasks(this.repository);

  @override
  Future<Either<Failure, List<Task>>> call(NoParams params) {
    return repository.getTasks();
  }
}
