import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/app_colors.dart';
import '../widgets/sos_pulse_button.dart';
import '../widgets/emergency_type_grid.dart';
import '../widgets/dispatch_status_card.dart';
import '../../../core/services/voice_translation_service.dart';
import '../../../core/widgets/voice_mic_button.dart';
import '../../../core/widgets/voice_wave_bars.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});
  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  String _selectedType   = 'Ambulance';
  String _description    = '';
  bool   _alertSent      = false;
  bool   _isLoading      = false;

  // Voice fields
  String _voiceSpoken     = '';
  String _voiceTranslated = '';
  bool   _isVoiceActive   = false;
  bool   _isTranslating   = false;

  // Image submission fields
  File? _evidenceImage;
  bool _isAnalyzingImage = false;

  final _descController = TextEditingController();

  void _sendAlert() {
    HapticFeedback.heavyImpact();
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() { _isLoading = false; _alertSent = true; });
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _evidenceImage = File(image.path);
        _isAnalyzingImage = true;
      });

      // Simulate AI Visual Analysis
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isAnalyzingImage = false;
        _selectedType = 'Accident'; // Auto-detected
        if (_descController.text.isEmpty) {
          _descController.text = "Visual evidence of emergency captured. Nearest responders alerted with high priority.";
        }
      });
      
      _showSnack('Image analyzed! Emergency type updated to Accident.');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg),
        backgroundColor: AppColors.navyMid,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12))));
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0507),
      body: Column(
        children: [
          _TopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Pulsing SOS button
                  FadeInDown(
                    child: SosPulseButton(activated: _alertSent),
                  ),
                  const SizedBox(height: 24),

                  // Heading
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      _alertSent
                          ? 'Help is on the way!'
                          : 'Request Emergency Help',
                      style: const TextStyle(
                        color: Colors.white, fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeInUp(
                    delay: const Duration(milliseconds: 150),
                    child: Text(
                      _alertSent
                          ? 'Ambulance dispatched. Hospitals alerted\nalong your Ayur ID medical summary.'
                          : 'Fill the form below. Hospitals &\nambulances will be notified instantly.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54, fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  if (!_alertSent) ...[
                    // Location field
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: _FormGroup(
                        label: 'YOUR LOCATION',
                        child: _DarkField(
                          prefixIcon: Icons.location_on_rounded,
                          value: 'Jubilee Hills, Hyderabad — 500033',
                          readOnly: true,
                          suffixIcon: Icons.my_location_rounded,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Image Section (Optional)
                    FadeInUp(
                      delay: const Duration(milliseconds: 210),
                      child: _FormGroup(
                        label: 'PHOTO OF EMERGENCY (OPTIONAL)',
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.emergency.withOpacity(0.3), style: BorderStyle.solid),
                            ),
                            child: Column(
                              children: [
                                if (_evidenceImage == null) ...[
                                  const Icon(Icons.add_a_photo_rounded, color: AppColors.emergency, size: 28),
                                  const SizedBox(height: 8),
                                  const Text('Capture/Upload Incident Photo', 
                                    style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                                  const Text('Helps responders prepare better', 
                                    style: TextStyle(color: Colors.white30, fontSize: 10)),
                                ] else ...[
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(_evidenceImage!, width: 50, height: 50, fit: BoxFit.cover),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Evidence Attached', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                            if (_isAnalyzingImage)
                                              const Row(
                                                children: [
                                                  SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.emergency)),
                                                  SizedBox(width: 8),
                                                  Text('AI Scanning...', style: TextStyle(fontSize: 11, color: AppColors.emergency)),
                                                ],
                                              )
                                            else
                                              const Text('Visual context saved ✓', style: TextStyle(fontSize: 11, color: AppColors.teal)),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => setState(() => _evidenceImage = null), 
                                        icon: const Icon(Icons.close, color: Colors.white54, size: 18)
                                      ),
                                    ],
                                  )
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Voice input section
                    FadeInUp(
                      delay: const Duration(milliseconds: 220),
                      child: _FormGroup(
                        label: 'SPEAK YOUR EMERGENCY',
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Speak in any language.\n'
                                      'We will translate and alert hospitals.',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                  VoiceMicButton(
                                    size: 64,
                                    color: AppColors.emergency,
                                    onResult: (spoken, locale) async {
                                      setState(() {
                                        _voiceSpoken    = spoken;
                                        _isTranslating  = true;
                                        _isVoiceActive  = false;
                                      });

                                      // Translate
                                      final translated =
                                        await VoiceTranslationService
                                            .translateToEnglish(spoken);

                                      // Generate emergency summary
                                      final summary =
                                        await VoiceTranslationService
                                            .generateEmergencySummary(translated);

                                      setState(() {
                                        _voiceTranslated = summary;
                                        _isTranslating   = false;
                                        // Auto-fill description
                                        _descController.text = summary;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              VoiceWaveBars(
                                isActive: _isVoiceActive,
                                color: AppColors.emergency,
                              ),
                              if (_voiceSpoken.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('YOU SAID',
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.8,
                                        )),
                                      const SizedBox(height: 4),
                                      Text(_voiceSpoken,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          height: 1.4,
                                        )),
                                    ],
                                  ),
                                ),
                              ],
                              if (_isTranslating)
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 14, height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.emergency,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text('Translating & summarizing...',
                                        style: TextStyle(
                                          color: Colors.white54, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              if (_voiceTranslated.isNotEmpty &&
                                  !_isTranslating) ...[
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.teal.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.teal.withOpacity(0.3),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('SENT TO HOSPITALS (ENGLISH)',
                                        style: TextStyle(
                                          color: AppColors.teal,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.8,
                                        )),
                                      const SizedBox(height: 4),
                                      Text(_voiceTranslated,
                                        style: const TextStyle(
                                          color: Color(0xFF9FE1CB),
                                          fontSize: 12,
                                          height: 1.4,
                                        )),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Emergency type
                    FadeInUp(
                      delay: const Duration(milliseconds: 250),
                      child: _FormGroup(
                        label: 'EMERGENCY TYPE',
                        child: EmergencyTypeGrid(
                          selected: _selectedType,
                          onSelected: (t) =>
                              setState(() => _selectedType = t),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: _FormGroup(
                        label: 'BRIEF DESCRIPTION',
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                              width: 0.5,
                            ),
                          ),
                          child: TextField(
                            controller: _descController,
                            onChanged: (v) =>
                                setState(() => _description = v),
                            maxLines: 3,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText:
                                  'Describe the emergency briefly…',
                              hintStyle: TextStyle(
                                  color: Colors.white24, fontSize: 13),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Send button
                    FadeInUp(
                      delay: const Duration(milliseconds: 350),
                      child: SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendAlert,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emergency,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24, height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.emergency_share_rounded,
                                        size: 22),
                                    SizedBox(width: 10),
                                    Text('SEND EMERGENCY ALERT',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],

                  if (_alertSent) ...[
                    // Dispatch status
                    FadeInUp(
                      child: const DispatchStatusCard(),
                    ),
                    const SizedBox(height: 16),

                    // Cancel/Track button
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.white.withOpacity(0.1),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('Track Ambulance Live',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // No payment notice
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lock_outline_rounded,
                              color: Colors.white38, size: 16),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'No payment required at emergency stage.'
                              ' Settlement handled post-care.',
                              style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 12, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Top Bar ──────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A0A0A),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 14,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36, height: 36,
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
            child: Text('Emergency SOS',
              style: TextStyle(color: Colors.white,
                  fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.emergency.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('LIVE',
              style: TextStyle(color: AppColors.emergency,
                  fontSize: 11, fontWeight: FontWeight.w800,
                  letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Form Group ───────────────────────────────────────────
class _FormGroup extends StatelessWidget {
  final String label;
  final Widget child;
  const _FormGroup({required this.label, required this.child});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: const TextStyle(
            color: Colors.white54, fontSize: 11,
            fontWeight: FontWeight.w700, letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

// ── Dark Input Field ─────────────────────────────────────
class _DarkField extends StatelessWidget {
  final IconData prefixIcon;
  final String value;
  final bool readOnly;
  final IconData? suffixIcon;
  const _DarkField({
    required this.prefixIcon,
    required this.value,
    this.readOnly = false,
    this.suffixIcon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Colors.white.withOpacity(0.12), width: 0.5),
      ),
      child: Row(
        children: [
          Icon(prefixIcon, color: AppColors.emergency, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 13)),
          ),
          if (suffixIcon != null)
            Icon(suffixIcon, color: Colors.white38, size: 18),
        ],
      ),
    );
  }
}
