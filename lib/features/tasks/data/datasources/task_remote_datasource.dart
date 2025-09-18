import 'package:dio/dio.dart';
import 'package:g_task/core/errors/exceptions.dart';
import 'package:g_task/core/network/api_client.dart';
import 'package:g_task/core/utils/constants.dart';
import 'package:g_task/features/tasks/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future syncTasks(List<TaskModel> tasks);

  Future<List<TaskModel>> fetchTasks();
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiClient apiClient;

  TaskRemoteDataSourceImpl({required this.apiClient});

  @override
  Future syncTasks(List<TaskModel> tasks) async {
    try {
      await apiClient.dio.post(
        '${ApiConstants.tasksEndpoint}/syncs',
        data: {'tasks': tasks.map((task) => task.toJson()).toList()},
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      }
      throw ServerException('Server error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  /*  @override
  Future<List<TaskModel>> syncTasks(List<TaskModel> tasks) async {
    try {
      final response = await apiClient.dio.post(
        '${ApiConstants.tasksEndpoint}/syncs',
        data: {'tasks': tasks.map((task) => task.toJson()).toList()},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['tasks'];
        return jsonList.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to sync tasks');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      }
      throw ServerException('Server error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }*/

  @override
  Future<List<TaskModel>> fetchTasks() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.tasksEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['tasks'];
        return jsonList.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch tasks');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      }
      throw ServerException('Server error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
