import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_flow/core/providers/database_provider.dart';
import 'package:task_flow/domain/models/task_model.dart';
import 'package:task_flow/services/notifications/notification_service.dart';

final taskListProvider =
    AsyncNotifierProvider<TaskListNotifier, List<TaskModel>>(() {
      return TaskListNotifier();
    });

class TaskListNotifier extends AsyncNotifier<List<TaskModel>> {
  @override
  Future<List<TaskModel>> build() async {
    return _fetchTasks();
  }

  Future<List<TaskModel>> _fetchTasks() async {
    final repository = ref.read(taskRepositoryProvider);
    return repository.getTasks();
  }

  Future<void> addTask(TaskModel task) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(taskRepositoryProvider);
      await repository.saveTask(task);
      if (task.reminderTime != null) {
        await NotificationService().scheduleTaskReminder(task);
      }
      return _fetchTasks();
    });
  }

  Future<void> updateTask(TaskModel task) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(taskRepositoryProvider);
      await repository.saveTask(task);
      if (task.reminderTime != null) {
        await NotificationService().scheduleTaskReminder(task);
      } else {
        await NotificationService().cancelReminder(task.id);
      }
      return _fetchTasks();
    });
  }

  Future<void> toggleTaskCompletion(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(taskRepositoryProvider);
      await repository.toggleTaskCompletion(id);
      return _fetchTasks();
    });
  }

  Future<void> deleteTask(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(taskRepositoryProvider);
      await repository.deleteTask(id);
      return _fetchTasks();
    });
  }
}
