import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:g_task/core/errors/failures.dart';
import 'package:g_task/core/usecases/usecase.dart';
import 'package:g_task/features/tasks/domain/repositories/task_repository.dart';

class DeleteTask extends UseCase<void, DeleteTaskParams> {
  final TaskRepository repository;

  DeleteTask(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteTaskParams params) {
    return repository.deleteTask(params.id);
  }
}

class DeleteTaskParams extends Equatable {
  final String id;

  const DeleteTaskParams({required this.id});

  @override
  List<Object> get props => [id];
}
