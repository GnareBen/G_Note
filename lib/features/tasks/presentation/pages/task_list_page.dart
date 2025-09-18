import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g_task/features/tasks/domain/entities/task.dart';
import 'package:g_task/features/tasks/presentation/bloc/task/task_bloc.dart';
import 'package:g_task/features/tasks/presentation/pages/task_form_page.dart';
import 'package:g_task/features/tasks/presentation/widgets/task_item.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasksEvent());
  }

  void _navigateToTaskForm([Task? task]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskFormPage(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Tâches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              context.read<TaskBloc>().add(SyncTasksEvent());
            },
            tooltip: 'Synchroniser',
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TaskOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.task_alt, size: 100, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune tâche',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Appuyez sur + pour créer une tâche',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(LoadTasksEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return TaskItem(
                    task: task,
                    onTap: () => _navigateToTaskForm(task),
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Une erreur est survenue'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTaskForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
