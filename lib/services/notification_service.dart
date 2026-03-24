import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/timezone.dart' as tz;
import '../core/services/api_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  static final Telephony _telephony = Telephony.instance;
  
  static Future<void> initialize() async {
    // Initialize local notifications
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(settings);
    
    // Request permissions
    await _requestPermissions();
    
    // Setup Firebase messaging
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    
    // Request permission for iOS
    NotificationSettings notificationSettings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    // Get token
    String? token = await messaging.getToken();
    print('FCM Token: $token');
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
      if (message.data['make_call'] == 'true') {
        _makeVoiceCall(message.data['phone_number'] ?? '');
      }
    });
    
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  
  static Future<void> _requestPermissions() async {
    await Permission.notification.request();
    await Permission.phone.request();
    await Permission.contacts.request();
  }
  
  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = 
        AndroidNotificationDetails(
      'ayurvanta_channel',
      'AyurVanta Notifications',
      channelDescription: 'Notifications for exercise reminders, appointments, and emergencies',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
    );
    
    const DarwinNotificationDetails iosDetails = 
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      DateTime.now().millisecond,
      message.notification?.title ?? 'AyurVanta',
      message.notification?.body ?? 'You have a new notification',
      details,
    );
  }
  
  static Future<void> scheduleExerciseReminder({
    required int exerciseId,
    required String exerciseName,
    required DateTime time,
    required String patientPhone,
  }) async {
    // Schedule local notification
    const AndroidNotificationDetails androidDetails = 
        AndroidNotificationDetails(
      'exercise_reminder',
      'Exercise Reminders',
      channelDescription: 'Daily exercise reminders',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );
    
    await _notifications.zonedSchedule(
      exerciseId,
      'Exercise Reminder',
      'Time to do: $exerciseName',
      tz.TZDateTime.from(time, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    
    // Schedule alarm for voice call
    await AndroidAlarmManager.oneShotAt(
      time,
      exerciseId,
      () => _makeVoiceCall(patientPhone),
      exact: true,
      wakeup: true,
    );
  }
  
  static Future<void> _makeVoiceCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    }
  }
  
  static Future<void> sendSMS({
    required String phoneNumber,
    required String message,
  }) async {
    bool? permissionsGranted = await _telephony.requestPhonePermissions;
    if (permissionsGranted ?? false) {
      await _telephony.sendSms(
        to: phoneNumber,
        message: message,
      );
    }
  }
  
  static Future<void> makeVoiceCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Handle background message
  if (message.data['make_call'] == 'true') {
    // Make call from background
    final phoneNumber = message.data['phone_number'];
    if (phoneNumber != null) {
      final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      }
    }
  }
}
