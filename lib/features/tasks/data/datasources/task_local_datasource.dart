import 'package:g_task/core/errors/exceptions.dart';
import 'package:g_task/core/utils/constants.dart';
import 'package:g_task/features/tasks/data/models/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();

  Future<TaskModel> createTask(TaskModel task);

  Future<TaskModel> updateTask(TaskModel task);

  Future<void> deleteTask(String id);

  Future<List<TaskModel>> getUnsyncedTasks();

  Future<void> markTasksAsSynced(List<String> ids);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DatabaseConstants.databaseName);

    return await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tasksTable} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        is_completed INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        is_synced INTEGER NOT NULL
      )
    ''');
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final db = await database;
      final maps = await db.query(
        DatabaseConstants.tasksTable,
        orderBy: 'created_at DESC',
      );

      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw CacheException('Failed to get tasks: $e');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final db = await database;
      await db.insert(
        DatabaseConstants.tasksTable,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return task;
    } catch (e) {
      throw CacheException('Failed to create task: $e');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final db = await database;
      await db.update(
        DatabaseConstants.tasksTable,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      return task;
    } catch (e) {
      throw CacheException('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final db = await database;
      await db.delete(
        DatabaseConstants.tasksTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw CacheException('Failed to delete task: $e');
    }
  }

  @override
  Future<List<TaskModel>> getUnsyncedTasks() async {
    try {
      final db = await database;
      final maps = await db.query(
        DatabaseConstants.tasksTable,
        where: 'is_synced = ?',
        whereArgs: [0],
      );

      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      throw CacheException('Failed to get unsynced tasks: $e');
    }
  }

  @override
  Future<void> markTasksAsSynced(List<String> ids) async {
    try {
      final db = await database;
      final batch = db.batch();

      for (final id in ids) {
        batch.update(
          DatabaseConstants.tasksTable,
          {'is_synced': 1},
          where: 'id = ?',
          whereArgs: [id],
        );
      }

      await batch.commit();
    } catch (e) {
      throw CacheException('Failed to mark tasks as synced: $e');
    }
  }
}
