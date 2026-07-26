import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_flow/core/routing/app_router.dart';
import 'package:task_flow/core/theme/app_theme.dart';
import 'package:task_flow/data/local/isar_db.dart';
import 'package:task_flow/services/notifications/notification_service.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await IsarDb.initialize();
    await NotificationService().init();
    runApp(const ProviderScope(child: TaskFlowApp()));
  } catch (e, stackTrace) {
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'FATAL ERROR:\n$e\n\nSTACKTRACE:\n$stackTrace',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ),
      ),
    ));
  }
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TaskFlow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Supports Dark Mode dynamically
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
