import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../../core/theme/app_colors.dart';
import '../models/medicine_reminder_model.dart';

// Global notifications instance
final FlutterLocalNotificationsPlugin _notifications =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  tz.initializeTimeZones();
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  await _notifications.initialize(
    const InitializationSettings(android: android, iOS: ios),
    onDidReceiveNotificationResponse: (r) {
      // Handle tap on notification
    },
  );
}

class MedicineReminderScreen extends StatefulWidget {
  const MedicineReminderScreen({super.key});
  @override
  State<MedicineReminderScreen> createState() =>
      _MedicineReminderScreenState();
}

class _MedicineReminderScreenState extends State<MedicineReminderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  List<MedicineReminder> _reminders = [];
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _load();
    _initTts();
    initNotifications();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-IN');
    await _tts.setSpeechRate(0.45);
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getStringList('medicine_reminders') ?? [];
    setState(() {
      _reminders = raw
          .map((e) => MedicineReminder.fromJson(jsonDecode(e)))
          .toList();
    });
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList('medicine_reminders',
        _reminders.map((r) => jsonEncode(r.toJson())).toList());
  }

  Future<void> _scheduleNotification(
      MedicineReminder r, String timeStr) async {
    final parts = timeStr.split(':');
    final h = int.parse(parts[0]);
    final m = int.parse(parts[1]);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, h, m);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final id = '${r.id}_$timeStr'.hashCode.abs() % 100000;

    const androidDetails = AndroidNotificationDetails(
      'medicine_reminder_ch',
      'Medicine Reminders',
      channelDescription: 'Reminder to take your medicines',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _notifications.zonedSchedule(
      id,
      '💊 Time to take ${r.name}',
      '${r.dosage} — Tap to mark as taken',
      scheduled,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // Also speak the reminder via TTS
    // (works when app is open)
    await _tts.speak('Time to take ${r.name}, ${r.dosage}');
  }

  Future<void> _cancelNotifications(MedicineReminder r) async {
    for (final t in r.times) {
      final id = '${r.id}_$t'.hashCode.abs() % 100000;
      await _notifications.cancel(id);
    }
  }

  void _markTaken(MedicineReminder r) {
    setState(() {
      r.takenLog.add(DateTime.now().toIso8601String());
    });
    _save();
    _tts.speak('${r.name} marked as taken. Well done!');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('✅ ${r.name} marked as taken!'),
      backgroundColor: AppColors.teal,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildTopBar(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _buildTodayTab(),
                _buildAllRemindersTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReminderSheet(null),
        backgroundColor: AppColors.teal,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Medicine',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        bottom: 14,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Medicine Reminders 💊',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    )),
                Text('Never miss a dose',
                    style: TextStyle(color: AppColors.textHint, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('${_reminders.length} medicines',
                style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: AppColors.navyMid,
      child: TabBar(
        controller: _tabCtrl,
        indicator: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.teal, width: 2)),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.teal,
        unselectedLabelColor: Colors.white54,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        tabs: const [
          Tab(text: "Today's Schedule"),
          Tab(text: 'All Medicines'),
        ],
      ),
    );
  }

  Widget _buildTodayTab() {
    if (_reminders.isEmpty) return _buildEmpty();

    // Build today's schedule sorted by time
    final schedule = <_ScheduleItem>[];
    for (final r in _reminders.where((r) => r.isActive)) {
      for (final t in r.times) {
        schedule.add(_ScheduleItem(reminder: r, time: t));
      }
    }
    schedule.sort((a, b) => a.time.compareTo(b.time));

    if (schedule.isEmpty) return _buildEmpty();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: schedule.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: i * 60),
        child: _ScheduleCard(
          item: schedule[i],
          onTaken: () => _markTaken(schedule[i].reminder),
        ),
      ),
    );
  }

  Widget _buildAllRemindersTab() {
    if (_reminders.isEmpty) return _buildEmpty();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: _reminders.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: i * 60),
        child: _MedicineCard(
          reminder: _reminders[i],
          onEdit: () => _showAddReminderSheet(_reminders[i]),
          onDelete: () {
            _cancelNotifications(_reminders[i]);
            setState(() => _reminders.removeAt(i));
            _save();
          },
          onToggle: (v) {
            setState(() => _reminders[i].isActive = v);
            if (!v) _cancelNotifications(_reminders[i]);
            _save();
          },
          onTaken: () => _markTaken(_reminders[i]),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('💊', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          const Text('No medicines added yet',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('Tap the + button to add a medicine\nand set up reminders',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
        ],
      ),
    );
  }

  void _showAddReminderSheet(MedicineReminder? existing) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final dosageCtrl = TextEditingController(text: existing?.dosage ?? '');
    final notesCtrl = TextEditingController(text: existing?.notes ?? '');
    List<String> times = List.from(existing?.times ?? ['08:00']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          height: MediaQuery.of(ctx).size.height * 0.85,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3EAF2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                )),
                const SizedBox(height: 16),
                Text(
                    existing == null
                        ? '💊 Add Medicine Reminder'
                        : '✏️ Edit Reminder',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: 20),

                _SheetField2(
                    label: 'Medicine Name',
                    controller: nameCtrl,
                    hint: 'e.g. Amlodipine 5mg'),
                const SizedBox(height: 12),
                _SheetField2(
                    label: 'Dosage',
                    controller: dosageCtrl,
                    hint: 'e.g. 1 tablet after food'),
                const SizedBox(height: 12),
                _SheetField2(
                    label: 'Notes (optional)',
                    controller: notesCtrl,
                    hint: 'Any special instructions'),
                const SizedBox(height: 20),

                // Time picker
                const Text('Reminder Times',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                ...times.asMap().entries.map((e) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final parts = e.value.split(':');
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(
                                    hour: int.parse(parts[0]),
                                    minute: int.parse(parts[1]),
                                  ),
                                );
                                if (picked != null) {
                                  setS(() {
                                    times[e.key] =
                                        '${picked.hour.toString().padLeft(2, '0')}:'
                                        '${picked.minute.toString().padLeft(2, '0')}';
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.blueLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded,
                                        size: 16, color: AppColors.blue),
                                    const SizedBox(width: 8),
                                    Text(e.value,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.blue,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (times.length > 1)
                            GestureDetector(
                              onTap: () => setS(() => times.removeAt(e.key)),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFCEBEB),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.remove_rounded,
                                    color: AppColors.emergency, size: 18),
                              ),
                            ),
                        ],
                      ),
                    )),
                GestureDetector(
                  onTap: () => setS(() => times.add('12:00')),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.teal, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded,
                            color: AppColors.teal, size: 16),
                        SizedBox(width: 4),
                        Text('Add Another Time',
                            style: TextStyle(
                                color: AppColors.teal,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nameCtrl.text.isEmpty || dosageCtrl.text.isEmpty) {
                        return;
                      }

                      final r = MedicineReminder(
                        id: existing?.id ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameCtrl.text,
                        dosage: dosageCtrl.text,
                        notes: notesCtrl.text,
                        times: times,
                        takenLog: existing?.takenLog ?? [],
                      );

                      // Cancel old notifications
                      if (existing != null) {
                        await _cancelNotifications(existing);
                      }

                      // Schedule new notifications
                      for (final t in times) {
                        await _scheduleNotification(r, t);
                      }

                      setState(() {
                        if (existing != null) {
                          final i =
                              _reminders.indexWhere((x) => x.id == existing.id);
                          if (i != -1) _reminders[i] = r;
                        } else {
                          _reminders.add(r);
                        }
                      });
                      await _save();
                      if (mounted) Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('✅ Reminder set for ${r.name} '
                            'at ${times.join(', ')}'),
                        backgroundColor: AppColors.teal,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                        existing == null ? 'Set Reminder' : 'Update Reminder',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleItem {
  final MedicineReminder reminder;
  final String time;
  _ScheduleItem({required this.reminder, required this.time});
}

// ── Schedule Card (Today view) ────────────────────────────
class _ScheduleCard extends StatelessWidget {
  final _ScheduleItem item;
  final VoidCallback onTaken;
  const _ScheduleCard({required this.item, required this.onTaken});

  bool get _isPast {
    final parts = item.time.split(':');
    final h = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    final now = TimeOfDay.now();
    return h < now.hour || (h == now.hour && m <= now.minute);
  }

  bool get _isTakenToday => item.reminder.isTakenToday();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _isTakenToday ? const Color(0xFFEAF3DE) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isTakenToday
              ? AppColors.teal
              : _isPast
                  ? AppColors.emergency.withOpacity(0.3)
                  : const Color(0xFFE3EAF2),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Time indicator
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _isTakenToday
                  ? AppColors.teal
                  : _isPast
                      ? AppColors.emergency.withOpacity(0.1)
                      : AppColors.blueLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.time,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _isTakenToday
                          ? Colors.white
                          : _isPast
                              ? AppColors.emergency
                              : AppColors.blue,
                    )),
                Icon(
                  _isTakenToday
                      ? Icons.check_rounded
                      : _isPast
                          ? Icons.warning_rounded
                          : Icons.medication_rounded,
                  size: 14,
                  color: _isTakenToday
                      ? Colors.white
                      : _isPast
                          ? AppColors.emergency
                          : AppColors.blue,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.reminder.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
                Text(item.reminder.dosage,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                if (item.reminder.notes.isNotEmpty)
                  Text(item.reminder.notes,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ),
          if (!_isTakenToday)
            GestureDetector(
              onTap: onTaken,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _isPast ? AppColors.emergency : AppColors.teal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Taken ✓',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.check_circle_rounded,
                  color: AppColors.teal, size: 24),
            ),
        ],
      ),
    );
  }
}

// ── Medicine Card (All view) ──────────────────────────────
class _MedicineCard extends StatelessWidget {
  final MedicineReminder reminder;
  final VoidCallback onEdit, onDelete, onTaken;
  final ValueChanged<bool> onToggle;
  const _MedicineCard({
    required this.reminder,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    required this.onTaken,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                    child: Text('💊', style: TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reminder.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        )),
                    Text(reminder.dosage,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Switch(
                value: reminder.isActive,
                onChanged: onToggle,
                activeColor: AppColors.teal,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: AppColors.textHint, size: 18),
                onSelected: (v) {
                  if (v == 'edit') onEdit();
                  if (v == 'delete') onDelete();
                  if (v == 'taken') onTaken();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                      value: 'taken',
                      child: Row(children: [
                        Icon(Icons.check_circle_rounded,
                            size: 16, color: AppColors.teal),
                        SizedBox(width: 8),
                        Text('Mark as Taken'),
                      ])),
                  const PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [
                        Icon(Icons.edit_rounded,
                            size: 16, color: AppColors.blue),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ])),
                  const PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        Icon(Icons.delete_rounded,
                            size: 16, color: AppColors.emergency),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ])),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Times row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              ...reminder.times.map((t) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.blueLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.alarm_rounded,
                            size: 12, color: AppColors.blue),
                        const SizedBox(width: 4),
                        Text(t,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blue,
                            )),
                      ],
                    ),
                  )),
              if (reminder.isTakenToday())
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3DE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('✓ Taken today',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.teal,
                      )),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SheetField2 extends StatelessWidget {
  final String label, hint;
  final TextEditingController controller;
  const _SheetField2({
    required this.label,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 12),
            filled: true,
            fillColor: AppColors.bgPage,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}
