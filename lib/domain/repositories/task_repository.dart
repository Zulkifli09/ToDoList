import 'package:task_flow/domain/models/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getTasks();
  Future<List<TaskModel>> getTasksByDate(DateTime date);
  Future<List<TaskModel>> getCompletedTasks();
  Future<List<TaskModel>> getUpcomingTasks();
  Future<void> saveTask(TaskModel task);
  Future<void> deleteTask(int id);
  Future<void> toggleTaskCompletion(int id);
  Future<TaskModel?> getTaskById(int id);
}
