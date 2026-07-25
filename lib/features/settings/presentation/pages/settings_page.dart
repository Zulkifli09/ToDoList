import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_flow/services/backup/backup_service.dart';
import 'package:task_flow/features/task/presentation/providers/task_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text('Data Management', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildSettingsCard(
              theme,
              title: 'Backup Database',
              subtitle: 'Export your tasks to a secure local file',
              icon: Icons.upload_file_rounded,
              onTap: () async {
                try {
                  final path = await BackupService().exportDatabase();
                  if (path != null && context.mounted) {
                    _showSnackBar(context, 'Backup successful: $path');
                  }
                } catch (e) {
                  if (context.mounted) {
                    _showSnackBar(context, e.toString(), isError: true);
                  }
                }
              },
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(
              theme,
              title: 'Restore Database',
              subtitle: 'Import tasks from a previous backup',
              icon: Icons.restore_page_rounded,
              onTap: () async {
                try {
                  final success = await BackupService().importDatabase();
                  if (success && context.mounted) {
                    _showSnackBar(context, 'Database restored successfully!');
                    // Reload the tasks from the new database
                    ref.invalidate(taskListProvider);
                  }
                } catch (e) {
                  if (context.mounted) {
                    _showSnackBar(context, e.toString(), isError: true);
                  }
                }
              },
            ),
            const SizedBox(height: 32),
            Text('About', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildSettingsCard(
              theme,
              title: 'TaskFlow Premium',
              subtitle: 'Version 1.0.0',
              icon: Icons.info_outline_rounded,
              onTap: () {}, // No action for now
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.disabledColor),
          ],
        ),
      ),
    );
  }
}
