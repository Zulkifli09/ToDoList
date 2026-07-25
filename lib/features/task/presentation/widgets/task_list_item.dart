import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_flow/domain/models/task_model.dart';
import 'package:task_flow/features/task/presentation/providers/task_provider.dart';

class TaskListItem extends ConsumerWidget {
  final TaskModel task;

  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final timeStr = task.time != null
        ? DateFormat.jm().format(task.time!)
        : (task.date != null
              ? DateFormat.MMMd().format(task.date!)
              : 'Anytime');

    return GestureDetector(
      onTap: () {
        context.push('/task/detail/${task.id}', extra: task);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                ref
                    .read(taskListProvider.notifier)
                    .toggleTaskCompletion(task.id);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: task.isCompleted
                        ? theme.colorScheme.primary
                        : theme.disabledColor,
                    width: 2,
                  ),
                  color: task.isCompleted
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style:
                        theme.textTheme.titleMedium?.copyWith(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? theme.disabledColor
                              : theme.textTheme.titleMedium?.color,
                        ) ??
                        const TextStyle(),
                    child: Text(task.title),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(timeStr, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
