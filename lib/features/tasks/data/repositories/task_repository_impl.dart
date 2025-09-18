import 'package:dartz/dartz.dart' hide Task;
import 'package:g_task/core/errors/exceptions.dart';
import 'package:g_task/core/errors/failures.dart';
import 'package:g_task/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:g_task/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:g_task/features/tasks/data/models/task_model.dart';
import 'package:g_task/features/tasks/domain/entities/task.dart';
import 'package:g_task/features/tasks/domain/repositories/task_repository.dart';
import 'package:uuid/uuid.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  final TaskRemoteDataSource remoteDataSource;
  final Uuid uuid;

  TaskRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.uuid,
  });

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final localTasks = await localDataSource.getTasks();
      return Right(localTasks);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Cache error'));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask(Task task) async {
    try {
      final taskModel = TaskModel(
        id: uuid.v4(),
        title: task.title,
        description: task.description,
        is_completed: false,
        created_at: DateTime.now(),
        updated_at: DateTime.now(),
        is_synced: false,
      );

      final createdTask = await localDataSource.createTask(taskModel);
      return Right(createdTask);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Failed to create task'));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        is_completed: task.is_completed,
        created_at: task.created_at,
        updated_at: DateTime.now(),
        is_synced: false,
      );

      final updatedTask = await localDataSource.updateTask(taskModel);
      return Right(updatedTask as Task);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Failed to update task'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await localDataSource.deleteTask(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Failed to delete task'));
    }
  }

  @override
  Future<Either<Failure, void>> syncTasks() async {
    try {
      // Get unsynced tasks
      final unsyncedTasks = await localDataSource.getUnsyncedTasks();

      if (unsyncedTasks.isEmpty) {
        return const Right(null);
      }

      // Sync with remote
      final syncedTasks = await remoteDataSource.syncTasks(unsyncedTasks);

      // Mark tasks as synced
      final syncedIds = syncedTasks.map((task) => task.id).toList();
      await localDataSource.markTasksAsSynced(syncedIds);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error'));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Cache error'));
    }
  }
}
