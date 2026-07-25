import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:task_flow/domain/models/task_model.dart';
import 'package:task_flow/data/local/isar_db.dart';

@pragma('vm:entry-point')
void notificationTapBackground(
  NotificationResponse notificationResponse,
) async {
  // Handle background actions (Done / Snooze)
  if (notificationResponse.actionId == 'action_done') {
    final payload = notificationResponse.payload;
    if (payload != null) {
      final taskId = int.tryParse(payload);
      if (taskId != null) {
        // Initialize Isar for the background isolate
        await IsarDb.initialize();
        final task = await IsarDb.instance.taskModels.get(taskId);
        if (task != null) {
          task.isCompleted = true;
          await IsarDb.instance.writeTxn(() async {
            await IsarDb.instance.taskModels.put(task);
          });
        }
      }
    }
  } else if (notificationResponse.actionId == 'action_snooze') {
    final payload = notificationResponse.payload;
    if (payload != null) {
      final taskId = int.tryParse(payload);
      if (taskId != null) {
        await IsarDb.initialize();
        final task = await IsarDb.instance.taskModels.get(taskId);
        if (task != null) {
          task.reminderTime = DateTime.now().add(const Duration(minutes: 10));
          await IsarDb.instance.writeTxn(() async {
            await IsarDb.instance.taskModels.put(task);
          });
          tz.initializeTimeZones();
          await NotificationService().scheduleTaskReminder(task);
        }
      }
    }
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle foreground tap
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<bool> requestPermissions() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      await Permission.scheduleExactAlarm.request();
      return true;
    }
    return false;
  }

  Future<void> scheduleTaskReminder(TaskModel task) async {
    if (task.reminderTime == null) return;

    // Don't schedule in the past
    if (task.reminderTime!.isBefore(DateTime.now())) return;

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_reminders',
      'Task Reminders',
      channelDescription: 'Notifications for upcoming tasks',
      importance: Importance.max,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'action_done',
          'Done',
          showsUserInterface: false,
        ),
        AndroidNotificationAction(
          'action_snooze',
          'Snooze 10m',
          showsUserInterface: false,
        ),
      ],
    );

    const iosPlatformChannelSpecifics = DarwinNotificationDetails();

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _notificationsPlugin.zonedSchedule(
      task.id,
      'Task Reminder: ${task.title}',
      task.notes ?? 'You have a task scheduled now!',
      tz.TZDateTime.from(task.reminderTime!, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: task.id.toString(),
    );
  }

  Future<void> cancelReminder(int taskId) async {
    await _notificationsPlugin.cancel(taskId);
  }
}
