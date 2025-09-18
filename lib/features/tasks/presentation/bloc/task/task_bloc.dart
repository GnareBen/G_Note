import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g_task/core/usecases/usecase.dart';
import 'package:g_task/features/tasks/domain/entities/task.dart';
import 'package:g_task/features/tasks/domain/usecases/create_task.dart';
import 'package:g_task/features/tasks/domain/usecases/delete_task.dart';
import 'package:g_task/features/tasks/domain/usecases/get_tasks.dart';
import 'package:g_task/features/tasks/domain/usecases/syn_tasks.dart';
import 'package:g_task/features/tasks/domain/usecases/update_task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final SyncTasks syncTasks;

  TaskBloc({
    required this.getTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.syncTasks,
  }) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<SyncTasksEvent>(_onSyncTasks);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());

    final result = await getTasks(NoParams());

    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (tasks) => emit(TaskLoaded(tasks: tasks)),
    );
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());

    final task = Task(
      id: '',
      title: event.title,
      description: event.description,
      is_completed: false,
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      is_synced: false,
    );

    final result = await createTask(CreateTaskParams(task: task));

    await result.fold(
      (failure) async => emit(TaskError(message: failure.message)),
      (_) async {
        emit(const TaskOperationSuccess(message: 'Tâche créée avec succès'));
        add(LoadTasksEvent());
      },
    );
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final result = await updateTask(UpdateTaskParams(task: event.task));

    await result.fold(
      (failure) async => emit(TaskError(message: failure.message)),
      (_) async {
        emit(const TaskOperationSuccess(message: 'Tâche mise à jour'));
        add(LoadTasksEvent());
      },
    );
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final result = await deleteTask(DeleteTaskParams(id: event.id));

    await result.fold(
      (failure) async => emit(TaskError(message: failure.message)),
      (_) async {
        emit(const TaskOperationSuccess(message: 'Tâche supprimée'));
        add(LoadTasksEvent());
      },
    );
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletionEvent event,
    Emitter<TaskState> emit,
  ) async {
    final updatedTask = event.task.copyWith(
      is_completed: !event.task.is_completed,
      updated_at: DateTime.now(),
      is_synced: false,
    );

    final result = await updateTask(UpdateTaskParams(task: updatedTask));

    await result.fold(
      (failure) async => emit(TaskError(message: failure.message)),
      (_) async {
        add(LoadTasksEvent());
      },
    );
  }

  Future<void> _onSyncTasks(
    SyncTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    final result = await syncTasks(NoParams());

    await result.fold(
      (failure) async => emit(TaskError(message: failure.message)),
      (_) async {
        emit(const TaskOperationSuccess(message: 'Synchronisation réussie'));
        add(LoadTasksEvent());
      },
    );
  }
}
