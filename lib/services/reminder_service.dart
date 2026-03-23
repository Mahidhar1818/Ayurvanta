import 'dart:async';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';
import '../models/exercise_model.dart';
import '../core/services/api_service.dart';

class ReminderService {
  static const String reminderTask = "exercise_reminder_task";
  
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    
    await Workmanager().registerPeriodicTask(
      "exercise_reminder_check",
      reminderTask,
      frequency: Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
  
  static Future<void> scheduleRemindersForPatient(
    String patientId,
    List<AssignedExercise> exercises,
  ) async {
    for (var exercise in exercises) {
      await _scheduleDailyReminders(exercise);
    }
  }
  
  static Future<void> _scheduleDailyReminders(
    AssignedExercise exercise,
  ) async {
    final frequency = exercise.frequencyPerDay;
    final interval = 24 ~/ frequency; // Hours between reminders
    
    for (int i = 0; i < frequency; i++) {
      final reminderTime = DateTime.now()
          .add(Duration(hours: i * interval))
          .copyWith(minute: 0);
      
      await NotificationService.scheduleExerciseReminder(
        exerciseId: int.parse(exercise.id),
        exerciseName: exercise.exercise.name,
        time: reminderTime,
        patientPhone: await _getPatientPhone(),
      );
    }
  }
  
  static Future<String> _getPatientPhone() async {
    final apiService = ApiService();
    try {
      final response = await apiService.get('/user/profile/');
      return response.data['data']['phone_number'] ?? '';
    } catch (e) {
      return '';
    }
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case ReminderService.reminderTask:
        await _checkAndSendReminders();
        break;
    }
    return Future.value(true);
  });
}

Future<void> _checkAndSendReminders() async {
  final apiService = ApiService();
  try {
    final response = await apiService.get('/exercises/today-reminders/');
    if (response.data['success']) {
      final exercises = response.data['data'];
      for (var exercise in exercises) {
        await NotificationService.sendSMS(
          phoneNumber: exercise['patient_phone'],
          message: 'Reminder: Time to do ${exercise['exercise_name']}. '
                   'Stay consistent with your recovery!',
        );
        
        await NotificationService.makeVoiceCall(exercise['patient_phone']);
      }
    }
  } catch (e) {
    print('Error checking reminders: $e');
  }
}
