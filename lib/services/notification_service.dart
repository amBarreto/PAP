import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();

  // Inicializar o serviço de notificações
  Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Atlantic/Azores'));

    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = 
        InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Pedir permissões no Android 13+
    await _requestPermissions();
  }

  // Pedir permissões
  Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  // Quando o utilizador clica na notificação
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notificação clicada: ${response.payload}');
  }

  // Mostrar notificação imediata
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = 
        AndroidNotificationDetails(
      'medihora_channel',
      'Lembretes de Medicamentos',
      channelDescription: 'Notificações para lembrar de tomar medicamentos',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details = 
        NotificationDetails(android: androidDetails);

    await _notifications.show(id, title, body, details, payload: payload);
  }

  // Agendar alarme para hora específica
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    final scheduledTZ = tz.TZDateTime.from(scheduledTime, tz.local);

    const AndroidNotificationDetails androidDetails = 
        AndroidNotificationDetails(
      'medihora_channel',
      'Lembretes de Medicamentos',
      channelDescription: 'Notificações para lembrar de tomar medicamentos',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
    );

    const NotificationDetails details = 
        NotificationDetails(android: androidDetails);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTZ,
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Agendar alarme diário (mesma hora todos os dias)
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    String? payload,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Se a hora já passou hoje, agenda para amanhã
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidDetails = 
        AndroidNotificationDetails(
      'medihora_channel',
      'Lembretes de Medicamentos',
      channelDescription: 'Notificações para lembrar de tomar medicamentos',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details = 
        NotificationDetails(android: androidDetails);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Cancelar um alarme específico
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Cancelar todos os alarmes
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Listar alarmes agendados
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}