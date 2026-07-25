import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:task_flow/data/local/isar_db.dart';

class BackupService {
  static final BackupService _instance = BackupService._();
  factory BackupService() => _instance;
  BackupService._();

  /// Exports the Isar database to a user-selected directory
  Future<String?> exportDatabase() async {
    try {
      final isar = IsarDb.instance;

      // Let user pick a directory to save the backup
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        return null; // User canceled
      }

      final backupFileName =
          'taskflow_backup_${DateTime.now().millisecondsSinceEpoch}.isar';
      final backupPath =
          '$selectedDirectory${Platform.pathSeparator}$backupFileName';

      // Isar has a built-in copyToFile method
      await isar.copyToFile(backupPath);

      return backupPath;
    } catch (e) {
      throw Exception('Failed to export database: $e');
    }
  }

  /// Imports an Isar database from a user-selected file
  Future<bool> importDatabase() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType
            .any, // Wait, Isar files don't always have a recognized mime type
      );

      if (result != null && result.files.single.path != null) {
        final pickedFilePath = result.files.single.path!;

        // Ensure it's likely an Isar file by extension (optional check)
        if (!pickedFilePath.endsWith('.isar')) {
          throw Exception(
            'Invalid file type. Please select a .isar backup file.',
          );
        }

        final isar = IsarDb.instance;
        final currentDbPath = isar.path;

        // 1. Close current Isar instance safely
        await isar.close();

        // 2. Overwrite the database file
        final backupFile = File(pickedFilePath);
        await backupFile.copy(currentDbPath!);

        // 3. Re-initialize Isar
        await IsarDb.initialize();

        return true;
      }
      return false;
    } catch (e) {
      // Attempt to re-initialize just in case it crashed while closed
      if (!IsarDb.instance.isOpen) {
        await IsarDb.initialize();
      }
      throw Exception('Failed to restore database: $e');
    }
  }
}
