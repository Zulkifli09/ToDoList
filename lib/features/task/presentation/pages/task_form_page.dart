import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_flow/domain/models/task_model.dart';
import 'package:task_flow/features/task/presentation/providers/task_provider.dart';
import 'package:task_flow/services/notifications/notification_service.dart';

class TaskFormPage extends ConsumerStatefulWidget {
  final TaskModel? existingTask;

  const TaskFormPage({super.key, this.existingTask});

  @override
  ConsumerState<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends ConsumerState<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _notesController;

  int _priority = 0;
  String? _category;
  DateTime? _date;
  DateTime? _time;
  DateTime? _reminderTime;
  bool _isRecurring = false;

  final List<String> _categories = [
    'Work',
    'Personal',
    'Shopping',
    'Health',
    'Finance',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingTask?.title ?? '',
    );
    _notesController = TextEditingController(
      text: widget.existingTask?.notes ?? '',
    );
    _priority = widget.existingTask?.priority ?? 0;
    _category = widget.existingTask?.category;
    _date = widget.existingTask?.date;
    _time = widget.existingTask?.time;
    _reminderTime = widget.existingTask?.reminderTime;
    _isRecurring = widget.existingTask?.isRecurring ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task = widget.existingTask ?? TaskModel();
      task.title = _titleController.text.trim();
      task.notes = _notesController.text.trim();
      task.priority = _priority;
      task.category = _category;
      task.date = _date;
      task.time = _time;
      task.reminderTime = _reminderTime;
      task.isRecurring = _isRecurring;

      if (widget.existingTask == null) {
        ref.read(taskListProvider.notifier).addTask(task);
      } else {
        ref.read(taskListProvider.notifier).updateTask(task);
      }

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditMode = widget.existingTask != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Task' : 'New Task'),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: Text(
              'Save',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              TextFormField(
                controller: _titleController,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                  hintStyle: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.disabledColor,
                  ),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                style: theme.textTheme.bodyLarge,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Add details, notes, or descriptions...',
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.disabledColor,
                  ),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.notes_rounded),
                ),
              ),
              const SizedBox(height: 32),

              // Priority Segmented Control
              Text('Priority', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('None')),
                  ButtonSegment(value: 1, label: Text('Low')),
                  ButtonSegment(value: 2, label: Text('Med')),
                  ButtonSegment(value: 3, label: Text('High')),
                ],
                selected: {_priority},
                onSelectionChanged: (Set<int> newSelection) {
                  setState(() {
                    _priority = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Category Choice Chips
              Text('Category', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _categories.map((cat) {
                  return ChoiceChip(
                    label: Text(cat),
                    selected: _category == cat,
                    onSelected: (selected) {
                      setState(() {
                        _category = selected ? cat : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Date and Time
              _buildListTile(
                theme,
                title: 'Due Date',
                subtitle: _date != null
                    ? DateFormat.yMMMd().format(_date!)
                    : 'Not set',
                icon: Icons.calendar_today_rounded,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _date ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _date = pickedDate;
                    });
                  }
                },
              ),

              _buildListTile(
                theme,
                title: 'Time',
                subtitle: _time != null
                    ? DateFormat.jm().format(_time!)
                    : 'Not set',
                icon: Icons.access_time_rounded,
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: _time != null
                        ? TimeOfDay.fromDateTime(_time!)
                        : TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      final now = DateTime.now();
                      _time = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                },
              ),

              _buildListTile(
                theme,
                title: 'Reminder',
                subtitle: _reminderTime != null
                    ? '${DateFormat.yMMMd().format(_reminderTime!)} at ${DateFormat.jm().format(_reminderTime!)}'
                    : 'Not set',
                icon: Icons.notifications_active_rounded,
                onTap: () async {
                  final hasPermission = await NotificationService()
                      .requestPermissions();
                  if (!hasPermission) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Notification permission is required for reminders.',
                          ),
                        ),
                      );
                    }
                    return;
                  }

                  if (!context.mounted) return;

                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _reminderTime ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null && context.mounted) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _reminderTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
              ),

              // Recurring Task
              SwitchListTile(
                title: const Text('Recurring Task'),
                subtitle: const Text('Repeat this task regularly'),
                secondary: const Icon(Icons.repeat_rounded),
                value: _isRecurring,
                activeThumbColor: theme.colorScheme.primary,
                onChanged: (value) {
                  setState(() {
                    _isRecurring = value;
                  });
                },
              ),

              const SizedBox(height: 48), // Padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: theme.textTheme.titleMedium),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: theme.colorScheme.primary),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
