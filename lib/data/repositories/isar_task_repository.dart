import 'package:isar/isar.dart';
import 'package:task_flow/domain/models/task_model.dart';
import 'package:task_flow/domain/repositories/task_repository.dart';

class IsarTaskRepository implements TaskRepository {
  final Isar isar;

  IsarTaskRepository(this.isar);

  @override
  Future<List<TaskModel>> getTasks() async {
    return await isar.taskModels.where().findAll();
  }

  @override
  Future<List<TaskModel>> getTasksByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return await isar.taskModels
        .filter()
        .dateBetween(startOfDay, endOfDay)
        .findAll();
  }

  @override
  Future<List<TaskModel>> getCompletedTasks() async {
    return await isar.taskModels.filter().isCompletedEqualTo(true).findAll();
  }

  @override
  Future<List<TaskModel>> getUpcomingTasks() async {
    final now = DateTime.now();
    return await isar.taskModels
        .filter()
        .dateGreaterThan(now)
        .and()
        .isCompletedEqualTo(false)
        .findAll();
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    await isar.writeTxn(() async {
      await isar.taskModels.put(task);
    });
  }

  @override
  Future<void> deleteTask(int id) async {
    await isar.writeTxn(() async {
      await isar.taskModels.delete(id);
    });
  }

  @override
  Future<void> toggleTaskCompletion(int id) async {
    final task = await isar.taskModels.get(id);
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      await isar.writeTxn(() async {
        await isar.taskModels.put(task);
      });
    }
  }

  @override
  Future<TaskModel?> getTaskById(int id) async {
    return await isar.taskModels.get(id);
  }
}
