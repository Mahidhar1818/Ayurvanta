import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/voice_translation_service.dart';
import '../../../core/services/language_service.dart';
import '../../../core/widgets/voice_mic_button.dart';
import '../../../core/widgets/voice_wave_bars.dart';
import '../../body_map/screens/body_map_screen.dart';

class OpdRegistrationScreen extends StatefulWidget {
  const OpdRegistrationScreen({super.key});
  @override
  State<OpdRegistrationScreen> createState() =>
      _OpdRegistrationScreenState();
}

class _OpdRegistrationScreenState
    extends State<OpdRegistrationScreen> {
  // Form controllers
  final _nameCtrl    = TextEditingController();
  final _ageCtrl     = TextEditingController();
  final _symptomsCtrl= TextEditingController();
  final _durationCtrl= TextEditingController();
  final _deptCtrl    = TextEditingController();

  String _spokenText     = '';
  String _translatedText = '';
  bool   _isTranslating  = false;
  bool   _isListening    = false;
  bool   _isSubmitting   = false;
  bool   _submitted      = false;

  Future<void> _onVoiceResult(
      String spoken, String locale) async {
    if (spoken.trim().isEmpty) return;

    setState(() {
      _spokenText     = spoken;
      _isTranslating  = true;
      _isListening    = false;
    });

    // Translate to English
    final translated =
        await VoiceTranslationService.translateToEnglish(spoken);

    // Extract structured info
    final info =
        await VoiceTranslationService.extractOpdInfo(translated);

    setState(() {
      _translatedText = translated;
      _isTranslating  = false;

      // Auto-fill form fields from voice
      if (info['name']?.isNotEmpty == true) {
        _nameCtrl.text = info['name']!;
      }
      if (info['age']?.isNotEmpty == true) {
        _ageCtrl.text = info['age']!;
      }
      if (info['symptoms']?.isNotEmpty == true) {
        _symptomsCtrl.text = info['symptoms']!;
      }
      if (info['duration']?.isNotEmpty == true) {
        _durationCtrl.text = info['duration']!;
      }
      if (info['department']?.isNotEmpty == true) {
        _deptCtrl.text = info['department']!;
      }
    });
  }

  Future<void> _onFieldVoiceResult(
      String spoken, String field) async {
    if (spoken.trim().isEmpty) return;
    final translated =
        await VoiceTranslationService.translateToEnglish(spoken);
    setState(() {
      switch (field) {
        case 'name':     _nameCtrl.text     = translated; break;
        case 'age':      _ageCtrl.text      = translated; break;
        case 'symptoms': _symptomsCtrl.text = translated; break;
        case 'duration': _durationCtrl.text = translated; break;
        case 'dept':     _deptCtrl.text     = translated; break;
      }
    });
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.isEmpty || _symptomsCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Please fill name and symptoms at minimum'),
          backgroundColor: AppColors.navyMid,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isSubmitting = false;
      _submitted    = true;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();    _ageCtrl.dispose();
    _symptomsCtrl.dispose();_durationCtrl.dispose();
    _deptCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildTopBar(lang),
          Expanded(
            child: _submitted
                ? _buildSuccessView(lang)
                : _buildFormView(lang),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(LanguageService lang) {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 16,
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
              child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lang.translate('opd_title'),
                  style: const TextStyle(
                    color: Colors.white, fontSize: 17,
                    fontWeight: FontWeight.w800,
                  )),
                const SizedBox(height: 2),
                const Text(
                  'Speak in any language — we understand',
                  style: TextStyle(
                      color: AppColors.textHint, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.teal, width: 0.5),
            ),
            child: const Row(
              children: [
                Icon(Icons.mic_rounded,
                    color: AppColors.teal, size: 13),
                SizedBox(width: 4),
                Text('Voice',
                  style: TextStyle(
                    color: AppColors.teal, fontSize: 10,
                    fontWeight: FontWeight.w700,
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView(LanguageService lang) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main voice button
          FadeInDown(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFFE3EAF2), width: 0.5),
              ),
              child: Column(
                children: [
                  const Text(
                    'Tell us everything in your language',
                    style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Name, age, symptoms, how long — say it all',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  VoiceMicButton(
                    size: 80,
                    color: AppColors.blue,
                    onResult: (spoken, locale) {
                      setState(() => _isListening = false);
                      _onVoiceResult(spoken, locale);
                    },
                  ),

                  const SizedBox(height: 12),
                  VoiceWaveBars(
                    isActive: _isListening,
                    color: AppColors.blue,
                  ),

                  // Show transcript
                  if (_spokenText.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bgPage,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(lang.translate('you_said').toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.8,
                            )),
                          const SizedBox(height: 5),
                          Text(_spokenText,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            )),
                        ],
                      ),
                    ),
                  ],

                  // Show translation
                  if (_isTranslating)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 14, height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.blue,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Translating...',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            )),
                        ],
                      ),
                    ),

                  if (_translatedText.isNotEmpty &&
                      !_isTranslating) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.blueLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFB5D4F4),
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(lang.translate('translated').toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blue,
                              letterSpacing: 0.8,
                            )),
                          const SizedBox(height: 5),
                          Text(_translatedText,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF0C447C),
                              height: 1.5,
                            )),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Body Map Integration Button
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            child: GestureDetector(
              onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) =>
                  const BodyMapScreen(gender: 'male'))),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.blue, width: 0.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.accessibility_new_rounded,
                        color: AppColors.blue, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        lang.translate('tap_body'),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                        )),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: AppColors.blue),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Form fields
          const Text('Patient Details',
            style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            )),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color(0xFFE3EAF2), width: 0.5),
            ),
            child: Column(
              children: [
                _VoiceFormField(
                  label: lang.translate('patient_name'),
                  controller: _nameCtrl,
                  hint: 'Tap mic or type',
                  fieldKey: 'name',
                  isFirst: true,
                  onVoiceResult: _onFieldVoiceResult,
                ),
                _VoiceFormField(
                  label: lang.translate('age'),
                  controller: _ageCtrl,
                  hint: 'Tap mic or type',
                  fieldKey: 'age',
                  onVoiceResult: _onFieldVoiceResult,
                  keyboardType: TextInputType.number,
                ),
                _VoiceFormField(
                  label: lang.translate('symptoms'),
                  controller: _symptomsCtrl,
                  hint: 'Fever, headache...',
                  fieldKey: 'symptoms',
                  onVoiceResult: _onFieldVoiceResult,
                  maxLines: 2,
                ),
                _VoiceFormField(
                  label: lang.translate('duration'),
                  controller: _durationCtrl,
                  hint: '2 days, 1 week...',
                  fieldKey: 'duration',
                  onVoiceResult: _onFieldVoiceResult,
                ),
                _VoiceFormField(
                  label: lang.translate('department'),
                  controller: _deptCtrl,
                  hint: 'General, Cardiology...',
                  fieldKey: 'dept',
                  isLast: true,
                  onVoiceResult: _onFieldVoiceResult,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5))
                  : Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text(lang.translate('submit'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          )),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSuccessView(LanguageService lang) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomIn(
              child: Container(
                width: 90, height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF3DE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: AppColors.teal, size: 48),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: const Text(
                'Registration Submitted!',
                style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Text(
                'Your OPD registration for '
                '${_nameCtrl.text.isNotEmpty ? _nameCtrl.text : "Patient"}'
                ' has been sent to the doctor.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              delay: const Duration(milliseconds: 350),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                        lang.translate('patient_name'), _nameCtrl.text),
                    _SummaryRow(
                        lang.translate('symptoms'), _symptomsCtrl.text),
                    _SummaryRow(
                        lang.translate('duration'), _durationCtrl.text),
                    _SummaryRow(
                        lang.translate('department'), _deptCtrl.text),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Back to Home',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  const _SummaryRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ',
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.blue)),
          Expanded(
            child: Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF0C447C))),
          ),
        ],
      ),
    );
  }
}

// ── Voice Form Field ─────────────────────────────────────
class _VoiceFormField extends StatefulWidget {
  final String label, hint, fieldKey;
  final TextEditingController controller;
  final bool isFirst, isLast;
  final int maxLines;
  final TextInputType? keyboardType;
  final Function(String, String) onVoiceResult;

  const _VoiceFormField({
    required this.label,
    required this.hint,
    required this.fieldKey,
    required this.controller,
    required this.onVoiceResult,
    this.isFirst = false,
    this.isLast = false,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  State<_VoiceFormField> createState() =>
      _VoiceFormFieldState();
}

class _VoiceFormFieldState extends State<_VoiceFormField> {
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: widget.isLast
              ? BorderSide.none
              : const BorderSide(
                  color: Color(0xFFF0F4F8), width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Text(widget.label,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary)),
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          VoiceMicButton(
            size: 32,
            color: AppColors.blue,
            onResult: (spoken, locale) {
              setState(() => _isListening = false);
              widget.onVoiceResult(spoken, widget.fieldKey);
            },
          ),
        ],
      ),
    );
  }
}
