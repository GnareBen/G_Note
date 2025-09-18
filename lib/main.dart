import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g_task/features/tasks/presentation/pages/task_list_page.dart';
import 'package:workmanager/workmanager.dart';

import 'features/tasks/presentation/bloc/task/task_bloc.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

// Background task callback
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize dependencies for background task
    await di.init();

    // Sync tasks
    final taskBloc = sl<TaskBloc>();
    taskBloc.add(SyncTasksEvent());

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  // Register periodic task (every hour)
  await Workmanager().registerPeriodicTask(
    "sync-tasks",
    "syncTasksPeriodic",
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TaskBloc>(),
      child: MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          appBarTheme: const AppBarTheme(elevation: 2, centerTitle: false),
        ),
        home: const TasksListPage(),
      ),
    );
  }
}
