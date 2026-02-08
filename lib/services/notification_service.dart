import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/care_task.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  Future<void> requestPermissions() async {
    // Android 13+ のパーミッションリクエスト
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    // iOS のパーミッションリクエスト
    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// ケアタスクの定期通知をスケジュール
  Future<void> scheduleTaskNotification(CareTask task, String surgeryName) async {
    if (!task.enabled) {
      await cancelTaskNotifications(task.id);
      return;
    }

    // 既存の通知をキャンセルしてから再登録
    await cancelTaskNotifications(task.id);

    final int notificationBaseId = task.id.hashCode.abs() % 100000;

    if (task.intervalHours > 0) {
      // N時間おきの通知
      await _plugin.periodicallyShow(
        notificationBaseId,
        '💊 $surgeryName - ${task.title}',
        '${task.frequencyLabel}のお知らせです',
        _intervalToRepeat(task.intervalHours),
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } else if (task.timesPerDay > 0) {
      // 1日N回の通知（均等間隔）
      final intervalHours = (24 / task.timesPerDay).round();
      await _plugin.periodicallyShow(
        notificationBaseId,
        '💊 $surgeryName - ${task.title}',
        '${task.frequencyLabel}のお知らせです',
        _intervalToRepeat(intervalHours),
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  RepeatInterval _intervalToRepeat(int hours) {
    if (hours <= 1) return RepeatInterval.hourly;
    if (hours <= 4) return RepeatInterval.everyMinute; // 最小間隔（デモ用）
    return RepeatInterval.daily;
  }

  /// タスクの通知をキャンセル
  Future<void> cancelTaskNotifications(String taskId) async {
    final int notificationBaseId = taskId.hashCode.abs() % 100000;
    await _plugin.cancel(notificationBaseId);
  }

  /// 全通知をキャンセル
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  /// 通知のテスト送信
  Future<void> showTestNotification(String title, String body) async {
    await _plugin.show(
      99999,
      title,
      body,
      _notificationDetails(),
    );
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'beauty_tracker_care',
        'ケアスケジュール',
        channelDescription: '術後ケアのリマインダー通知',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }
}
