import 'package:flutter/material.dart';

class MedicineReminder {
  final String id;
  final String name;
  final String dosage;
  final String notes;
  final List<String> times; // e.g. ['08:00', '14:00', '20:00']
  final List<bool> days;   // Mon-Sun
  bool isActive;
  List<String> takenLog;   // ISO timestamps

  MedicineReminder({
    required this.id,
    required this.name,
    required this.dosage,
    this.notes = '',
    required this.times,
    List<bool>? days,
    this.isActive = true,
    List<String>? takenLog,
  }) : days = days ?? List.filled(7, true),
       takenLog = takenLog ?? [];

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'dosage': dosage,
    'notes': notes, 'times': times, 'days': days,
    'isActive': isActive, 'takenLog': takenLog,
  };

  factory MedicineReminder.fromJson(Map<String, dynamic> j) =>
    MedicineReminder(
      id: j['id'], name: j['name'], dosage: j['dosage'],
      notes: j['notes'] ?? '',
      times: List<String>.from(j['times'] ?? ['08:00']),
      days: List<bool>.from(j['days'] ?? List.filled(7, true)),
      isActive: j['isActive'] ?? true,
      takenLog: List<String>.from(j['takenLog'] ?? []),
    );

  String get nextDoseTime {
    if (times.isEmpty) return '--';
    final now = TimeOfDay.now(); // We will use a workaround or dummy logic if TimeOfDay isn't resolved since we need Material import in the model
    for (final t in times) {
      final parts = t.split(':');
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      if (h > now.hour || (h == now.hour && m > now.minute)) {
        return t;
      }
    }
    return times.first; // tomorrow
  }

  bool isTakenToday() {
    final today = DateTime.now();
    return takenLog.any((log) {
      final dt = DateTime.parse(log);
      return dt.year == today.year &&
          dt.month == today.month &&
          dt.day == today.day;
    });
  }
}
