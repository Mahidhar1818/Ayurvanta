import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/theme/app_colors.dart';
import '../models/solo_contact_model.dart';

class SoloSafetyScreen extends StatefulWidget {
  const SoloSafetyScreen({super.key});
  @override
  State<SoloSafetyScreen> createState() =>
      _SoloSafetyScreenState();
}

class _SoloSafetyScreenState extends State<SoloSafetyScreen>
    with SingleTickerProviderStateMixin {
  bool _soloEnabled   = false;
  bool _isListening   = false;
  bool _alertSent     = false;
  List<SoloContact> _contacts = [];
  String _listenStatus = 'Tap to start listening';
  String _lastHeard    = '';

  final FlutterTts _tts = FlutterTts();
  Timer? _listenTimer;

  // Platform channel for native speech recognition
  static const _channel = MethodChannel('ayurvanta/speech');

  @override
  void initState() {
    super.initState();
    _load();
    _setupChannel();
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-IN');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
  }

  void _setupChannel() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onSpeechResult') {
        final text = (call.arguments as String).toLowerCase();
        setState(() => _lastHeard = text);
        _checkForTrigger(text);
      }
    });
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    _soloEnabled = p.getBool('solo_safety') ?? false;
    final raw = p.getStringList('solo_contacts') ?? [];
    setState(() {
      _contacts = raw.map((e) =>
          SoloContact.fromJson(jsonDecode(e))).toList();
    });
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('solo_safety', _soloEnabled);
    await p.setStringList('solo_contacts',
        _contacts.map((c) => jsonEncode(c.toJson())).toList());
  }

  // Check if spoken text matches any contact's passphrase
  void _checkForTrigger(String spoken) {
    for (final contact in _contacts) {
      if (!contact.isActive) continue;
      final passphrase =
          contact.voicePassphrase.toLowerCase().trim();
      if (spoken.contains(passphrase)) {
        _triggerSOS(contact);
        return;
      }
    }
  }

  Future<void> _triggerSOS(SoloContact contact) async {
    HapticFeedback.heavyImpact();
    setState(() {
      _alertSent = true;
      _listenStatus = '🚨 ALERT SENT to ${contact.name}!';
    });

    // Get GPS location
    String locationUrl = 'Location unavailable';
    try {
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5));
      locationUrl = 'https://maps.google.com/?q='
          '${pos.latitude},${pos.longitude}';
    } catch (_) {}

    // Speak the voice message aloud (so nearby people hear)
    await _tts.speak(contact.voiceMessage);

    // Send SMS via platform channel
    final smsBody = '🚨 ${contact.voiceMessage}\n'
        'LOCATION: $locationUrl\n'
        'Sent via AyurVanta Solo Safety System';

    try {
      await _channel.invokeMethod('sendSMS', {
        'phone': contact.phone,
        'message': smsBody,
      });
    } catch (_) {}

    // Show alert dialog
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _SOSAlertDialog(
          contact: contact,
          locationUrl: locationUrl,
          onDismiss: () {
            setState(() => _alertSent = false);
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  Future<void> _startListening() async {
    setState(() {
      _isListening   = true;
      _listenStatus  = 'Listening for your voice passphrase...';
    });

    try {
      await _channel.invokeMethod('startListening');
    } catch (_) {
      setState(() {
        _isListening  = false;
        _listenStatus = 'Tap to start listening';
      });
    }
  }

  Future<void> _stopListening() async {
    setState(() {
      _isListening  = false;
      _listenStatus = 'Tap to start listening';
    });
    try {
      await _channel.invokeMethod('stopListening');
    } catch (_) {}
  }

  void _toggleSolo(bool v) {
    setState(() => _soloEnabled = v);
    _save();
    if (!v) _stopListening();
  }

  @override
  void dispose() {
    _listenTimer?.cancel();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Solo Safety System 🛡️',
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Master toggle
            FadeInDown(child: _buildMasterToggle()),
            const SizedBox(height: 16),

            if (_soloEnabled) ...[
              // Live listen button
              FadeInUp(
                delay: const Duration(milliseconds: 80),
                child: _buildListenButton(),
              ),
              const SizedBox(height: 16),

              // How it works
              FadeInUp(
                delay: const Duration(milliseconds: 120),
                child: _buildHowItWorks(),
              ),
              const SizedBox(height: 16),
            ],

            // Contacts with voice setup
            FadeInUp(
              delay: const Duration(milliseconds: 160),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Emergency Contacts',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
                  GestureDetector(
                    onTap: () => _showAddContactSheet(null),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.teal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.white,
                              size: 14),
                          SizedBox(width: 4),
                          Text('Add Contact',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            if (_contacts.isEmpty)
              FadeInUp(
                child: _buildEmptyContacts(),
              )
            else
              ..._contacts.asMap().entries.map((e) =>
                FadeInUp(
                  delay: Duration(milliseconds: e.key * 60),
                  child: _SoloContactCard(
                    contact: e.value,
                    onEdit: () => _showAddContactSheet(e.value),
                    onDelete: () => _deleteContact(e.value),
                    onToggle: (v) {
                      setState(() => e.value.isActive = v);
                      _save();
                    },
                    onTestVoice: () => _testVoiceMessage(e.value),
                  ),
                )),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMasterToggle() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _soloEnabled
            ? AppColors.teal.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _soloEnabled
              ? AppColors.teal
              : const Color(0xFFE3EAF2),
          width: _soloEnabled ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(
              color: _soloEnabled
                  ? AppColors.teal
                  : AppColors.bgMuted,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_rounded,
              color: _soloEnabled
                  ? Colors.white
                  : AppColors.textHint,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _soloEnabled
                      ? 'ACTIVE — Voice Detection ON'
                      : 'Solo Safety OFF',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _soloEnabled
                        ? AppColors.teal
                        : AppColors.textPrimary,
                  )),
                const SizedBox(height: 3),
                Text(
                  _soloEnabled
                      ? 'Say your passphrase to send SOS + GPS'
                      : 'Enable to activate voice-triggered SOS',
                  style: TextStyle(
                    fontSize: 11,
                    color: _soloEnabled
                        ? AppColors.teal
                        : AppColors.textSecondary,
                  )),
              ],
            ),
          ),
          Switch(
            value: _soloEnabled,
            onChanged: _toggleSolo,
            activeColor: AppColors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildListenButton() {
    return GestureDetector(
      onTap: _isListening ? _stopListening : _startListening,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _isListening
              ? AppColors.emergency.withOpacity(0.1)
              : AppColors.blueLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isListening
                ? AppColors.emergency
                : AppColors.blue,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: _isListening
                    ? AppColors.emergency
                    : AppColors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isListening
                    ? Icons.mic_rounded
                    : Icons.mic_none_rounded,
                color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isListening
                        ? 'LISTENING...'
                        : 'Start Listening',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _isListening
                          ? AppColors.emergency
                          : AppColors.blue,
                    )),
                  Text(
                    _lastHeard.isEmpty
                        ? _listenStatus
                        : 'Heard: "$_lastHeard"',
                    style: TextStyle(
                        fontSize: 11,
                        color: _isListening
                            ? AppColors.emergency
                            : AppColors.blue)),
                ],
              ),
            ),
            if (_isListening)
              Container(
                width: 10, height: 10,
                decoration: BoxDecoration(
                  color: AppColors.emergency,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorks() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F1FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📖 How Voice Trigger Works',
            style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: AppColors.blue,
            )),
          const SizedBox(height: 8),
          ...[
            '1. Add contacts below with a custom passphrase',
            '2. Example passphrase: "help me", "save me now"',
            '3. Enable Solo Safety toggle above',
            '4. Tap "Start Listening" to activate mic',
            '5. Say the passphrase → GPS + SMS sent instantly',
            '6. Your voice message is also played aloud',
          ].map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(s,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.blue,
                  height: 1.4)),
          )),
        ],
      ),
    );
  }

  Widget _buildEmptyContacts() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        children: [
          const Icon(Icons.contacts_outlined,
              size: 40, color: AppColors.textHint),
          const SizedBox(height: 12),
          const Text('No emergency contacts yet',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text(
            'Add contacts with custom voice phrases.\n'
            'When you say the phrase, SOS is sent.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12, color: AppColors.textSecondary,
                height: 1.5)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showAddContactSheet(null),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Add First Contact'),
          ),
        ],
      ),
    );
  }

  void _deleteContact(SoloContact c) {
    setState(() => _contacts.removeWhere((x) => x.id == c.id));
    _save();
  }

  Future<void> _testVoiceMessage(SoloContact c) async {
    await _tts.speak(c.voiceMessage);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Playing voice message for ${c.name}'),
      backgroundColor: AppColors.teal,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
    ));
  }

  void _showAddContactSheet(SoloContact? existing) {
    final nameCtrl =
        TextEditingController(text: existing?.name ?? '');
    final phoneCtrl =
        TextEditingController(text: existing?.phone ?? '');
    final phraseCtrl = TextEditingController(
        text: existing?.voicePassphrase ?? 'help me');
    final msgCtrl = TextEditingController(
        text: existing?.voiceMessage ??
            'Emergency! I need help. Please call me immediately.');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3EAF2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                )),
                const SizedBox(height: 16),
                Text(
                  existing == null
                      ? 'Add Emergency Contact'
                      : 'Edit Contact',
                  style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  )),
                const SizedBox(height: 20),

                // Contact name
                _SheetField(
                    label: 'Contact Name',
                    controller: nameCtrl,
                    hint: 'e.g. Priya Sharma'),
                const SizedBox(height: 12),

                // Phone
                _SheetField(
                    label: 'Phone Number',
                    controller: phoneCtrl,
                    hint: '+91 98765 XXXXX',
                    keyboard: TextInputType.phone),
                const SizedBox(height: 16),

                // Voice Passphrase section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3DE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(children: [
                        Icon(Icons.record_voice_over_rounded,
                            color: AppColors.teal, size: 16),
                        SizedBox(width: 6),
                        Text('Voice Trigger Phrase',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.teal,
                          )),
                      ]),
                      const SizedBox(height: 4),
                      const Text(
                        'When you say this phrase, SOS is triggered',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.teal)),
                      const SizedBox(height: 10),
                      _SheetField(
                          label: 'Passphrase',
                          controller: phraseCtrl,
                          hint: 'e.g. "help me", "save me now"'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Voice Message section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.blueLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(children: [
                        Icon(Icons.volume_up_rounded,
                            color: AppColors.blue, size: 16),
                        SizedBox(width: 6),
                        Text('Voice Message to Contact',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blue,
                          )),
                      ]),
                      const SizedBox(height: 4),
                      const Text(
                        'This message is spoken aloud + sent as SMS',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.blue)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: msgCtrl,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Emergency message...',
                          hintStyle: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: 12),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.all(10),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _tts.speak(msgCtrl.text),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_circle_rounded,
                                  color: Colors.white, size: 14),
                              SizedBox(width: 5),
                              Text('Preview Voice',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.isEmpty ||
                          phoneCtrl.text.isEmpty ||
                          phraseCtrl.text.isEmpty) return;

                      final contact = SoloContact(
                        id: existing?.id ??
                            DateTime.now().millisecondsSinceEpoch
                                .toString(),
                        name: nameCtrl.text,
                        phone: phoneCtrl.text,
                        voicePassphrase: phraseCtrl.text
                            .toLowerCase().trim(),
                        voiceMessage: msgCtrl.text,
                      );

                      setState(() {
                        if (existing != null) {
                          final i = _contacts.indexWhere(
                              (c) => c.id == existing.id);
                          if (i != -1) _contacts[i] = contact;
                        } else {
                          _contacts.add(contact);
                        }
                      });
                      _save();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      existing == null
                          ? 'Add Contact'
                          : 'Save Changes',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Solo Contact Card ─────────────────────────────────────
class _SoloContactCard extends StatelessWidget {
  final SoloContact contact;
  final VoidCallback onEdit, onDelete, onTestVoice;
  final ValueChanged<bool> onToggle;
  const _SoloContactCard({
    required this.contact, required this.onEdit,
    required this.onDelete, required this.onToggle,
    required this.onTestVoice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: contact.isActive
                ? AppColors.teal.withOpacity(0.3)
                : const Color(0xFFE3EAF2),
            width: contact.isActive ? 1 : 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.teal.withOpacity(0.1),
                child: Text(
                  contact.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      )),
                    Text(contact.phone,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Switch(
                value: contact.isActive,
                onChanged: onToggle,
                activeColor: AppColors.teal,
                materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: AppColors.textHint, size: 18),
                onSelected: (v) {
                  if (v == 'edit') onEdit();
                  if (v == 'delete') onDelete();
                  if (v == 'test') onTestVoice();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'test',
                      child: Row(children: [
                        Icon(Icons.play_circle_rounded,
                            size: 16, color: AppColors.teal),
                        SizedBox(width: 8),
                        Text('Test Voice'),
                      ])),
                  const PopupMenuItem(value: 'edit',
                      child: Row(children: [
                        Icon(Icons.edit_rounded,
                            size: 16, color: AppColors.blue),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ])),
                  const PopupMenuItem(value: 'delete',
                      child: Row(children: [
                        Icon(Icons.delete_rounded,
                            size: 16, color: AppColors.emergency),
                        SizedBox(width: 8),
                        Text('Remove',
                            style: TextStyle(
                                color: AppColors.emergency)),
                      ])),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Passphrase chip
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3DE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mic_rounded,
                        size: 12, color: AppColors.teal),
                    const SizedBox(width: 4),
                    Text(
                      '"${contact.voicePassphrase}"',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.teal,
                      )),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.blueLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    contact.voiceMessage,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.blue),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── SOS Alert Dialog ──────────────────────────────────────
class _SOSAlertDialog extends StatelessWidget {
  final SoloContact contact;
  final String locationUrl;
  final VoidCallback onDismiss;
  const _SOSAlertDialog({
    required this.contact,
    required this.locationUrl,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFF0B1A2C),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              color: AppColors.emergency.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
                Icons.emergency_share_rounded,
                color: AppColors.emergency, size: 38),
          ),
          const SizedBox(height: 16),
          const Text('SOS SENT!',
            style: TextStyle(
              color: Colors.white, fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            )),
          const SizedBox(height: 8),
          Text('Alert sent to ${contact.name}',
            style: const TextStyle(
                color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text('"${contact.voiceMessage}"',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(locationUrl,
                  style: const TextStyle(
                      color: AppColors.teal, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('I\'m Safe — Dismiss'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final String label, hint;
  final TextEditingController controller;
  final TextInputType? keyboard;
  const _SheetField({
    required this.label, required this.controller,
    required this.hint, this.keyboard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.5)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          style: const TextStyle(fontSize: 14,
              color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                color: AppColors.textHint, fontSize: 13),
            filled: true,
            fillColor: AppColors.bgPage,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}