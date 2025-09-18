class ApiConstants {
  static const String baseUrl = "http://192.168.1.64:8000/api";
  static const String tasksEndpoint = "/tasks";
  static const Duration syncInterval = Duration(hours: 1);
}

class DatabaseConstants {
  static const String databaseName = 'tasks.db';
  static const int databaseVersion = 1;
  static const String tasksTable = 'tasks';
}
