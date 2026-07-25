import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:task_flow/data/local/isar_db.dart';
import 'package:task_flow/data/repositories/isar_task_repository.dart';
import 'package:task_flow/domain/repositories/task_repository.dart';

final isarProvider = Provider<Isar>((ref) {
  return IsarDb.instance;
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return IsarTaskRepository(isar);
});
