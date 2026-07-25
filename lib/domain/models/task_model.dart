import 'package:isar/isar.dart';

part 'task_model.g.dart';

@collection
class TaskModel {
  Id id = Isar.autoIncrement;

  String title = '';

  String? notes;

  bool isCompleted = false;

  bool isArchived = false;

  bool isFavorite = false;

  /// Priority level: 0 = None, 1 = Low, 2 = Medium, 3 = High
  short priority = 0;

  String? category;

  DateTime? date;

  DateTime? time;

  DateTime? deadline;

  DateTime? reminderTime;

  bool isRecurring = false;

  /// Hex color code for label
  String? colorLabel;

  DateTime createdAt = DateTime.now();
}
