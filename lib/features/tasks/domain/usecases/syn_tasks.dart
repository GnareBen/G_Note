import 'package:dartz/dartz.dart';
import 'package:g_task/core/errors/failures.dart';
import 'package:g_task/core/usecases/usecase.dart';
import 'package:g_task/features/tasks/domain/repositories/task_repository.dart';

class SyncTasks extends UseCase<void, NoParams> {
  final TaskRepository repository;

  SyncTasks(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.syncTasks();
  }
}
