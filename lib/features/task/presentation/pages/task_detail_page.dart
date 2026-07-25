import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_flow/domain/models/task_model.dart';
import 'package:task_flow/features/task/presentation/providers/task_provider.dart';

class TaskDetailPage extends ConsumerWidget {
  final TaskModel task;

  const TaskDetailPage({super.key, required this.task});

  String _getPriorityString(int priority) {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'None';
    }
  }

  Color _getPriorityColor(int priority, ColorScheme scheme) {
    switch (priority) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return scheme.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              context.push('/task/edit/${task.id}', extra: task);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            onPressed: () {
              ref.read(taskListProvider.notifier).deleteTask(task.id);
              context.pop();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    ref
                        .read(taskListProvider.notifier)
                        .toggleTaskCompletion(task.id);
                    // Using context.pop() here is optional depending on if we want to stay on detail page or go back
                  },
                  child: Container(
                    width: 32,
                    height: 32,
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
                        ? const Icon(Icons.check, size: 20, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    task.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: task.isCompleted ? theme.disabledColor : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            if (task.notes != null && task.notes!.isNotEmpty) ...[
              Text('Notes', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(task.notes!, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 32),
            ],

            Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                if (task.category != null)
                  _buildDetailChip(
                    theme,
                    Icons.folder_outlined,
                    task.category!,
                  ),
                _buildDetailChip(
                  theme,
                  Icons.flag_outlined,
                  'Priority: ${_getPriorityString(task.priority)}',
                  color: _getPriorityColor(task.priority, theme.colorScheme),
                ),
                if (task.date != null)
                  _buildDetailChip(
                    theme,
                    Icons.calendar_today_rounded,
                    DateFormat.yMMMd().format(task.date!),
                  ),
                if (task.time != null)
                  _buildDetailChip(
                    theme,
                    Icons.access_time_rounded,
                    DateFormat.jm().format(task.time!),
                  ),
                if (task.reminderTime != null)
                  _buildDetailChip(
                    theme,
                    Icons.notifications_active_outlined,
                    'Reminder Set',
                  ),
                if (task.isRecurring)
                  _buildDetailChip(theme, Icons.repeat_rounded, 'Recurring'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(
    ThemeData theme,
    IconData icon,
    String label, {
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: (color ?? theme.colorScheme.primary).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color ?? theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color ?? theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
