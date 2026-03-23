import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/tr_extension.dart';
import '../../../core/services/razorpay_service.dart';
import '../../../core/widgets/voice_mic_button.dart';
import '../../../core/services/voice_translation_service.dart';
import '../models/hospital_model.dart';
import '../../opd/screens/opd_payment_screen.dart';

class OpFormScreen extends StatefulWidget {
  final HospitalModel hospital;
  const OpFormScreen({super.key, required this.hospital});
  @override
  State<OpFormScreen> createState() =>
      _OpFormScreenState();
}

class _OpFormScreenState extends State<OpFormScreen> {
  final _nameCtrl    = TextEditingController();
  final _ageCtrl     = TextEditingController();
  final _symptomsCtrl= TextEditingController();
  String _selectedSpec = '';
  String _selectedTimeSlot = '';
  
  static const _timeSlots = [
    '09:00 AM', '10:00 AM', '11:30 AM', 
    '01:00 PM', '02:30 PM', '04:00 PM', '05:30 PM'
  ];
  bool _useVoice     = false;
  bool _isTranslating= false;
  String _voiceText  = '';
  String _translated = '';
  bool _isSubmitting = false;
  
  // Image analysis fields
  File? _attachedImage;
  bool _isAnalyzingImage = false;

  late RazorpayService _rzp;

  @override
  void initState() {
    super.initState();
    _selectedSpec =
        widget.hospital.specializations.first;
    _rzp = RazorpayService(
      onSuccess: (id) {
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) =>
            OpdPaymentScreen(
              patientName: _nameCtrl.text,
              doctorName: 'Doctor at '
                  '${widget.hospital.name}',
              department: _selectedSpec,
              symptoms: _symptomsCtrl.text,
              tokenNumber:
                  40 + DateTime.now().second % 20,
              opdFee: widget.hospital.consultationFee,
            )));
      },
      onFailure: (e) => _showSnack('Payment failed: $e'),
      onExternalWallet: () {},
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _attachedImage = File(image.path);
        _isAnalyzingImage = true;
      });

      // Simulate AI OCR and analysis
      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _nameCtrl.text = "M. Nagamahidhar";
        _ageCtrl.text = "24";
        _symptomsCtrl.text = "Chronic back pain and seasonal fever symptoms as noted in the report.";
        _isAnalyzingImage = false;
      });

      _showSnack('Document analyzed! Form pre-filled.');
    }
  }

  Future<void> _onVoiceResult(
      String spoken, String locale) async {
    setState(() {
      _voiceText    = spoken;
      _isTranslating= true;
    });

    final translated =
        await VoiceTranslationService
            .translateToEnglish(spoken);
    final info =
        await VoiceTranslationService
            .extractOpdInfo(translated);

    setState(() {
      _translated   = translated;
      _isTranslating= false;
      if (info['name']?.isNotEmpty == true)
        _nameCtrl.text = info['name']!;
      if (info['age']?.isNotEmpty == true)
        _ageCtrl.text = info['age']!;
      if (info['symptoms']?.isNotEmpty == true)
        _symptomsCtrl.text = info['symptoms']!;
    });
  }

  void _pay() {
    if (_nameCtrl.text.isEmpty) {
      _showSnack('Please enter patient name');
      return;
    }
    if (_selectedTimeSlot.isEmpty) {
      _showSnack('Please select an appointment time slot');
      return;
    }
    setState(() => _isSubmitting = true);
    _rzp.openCheckout(
      amountInPaise:
          widget.hospital.consultationFee * 100,
      description:
          'OP Booking — ${widget.hospital.name}',
      userName: _nameCtrl.text,
      userEmail: 'patient@ayurvanta.in',
      userPhone: '+919876543210',
      orderId:
          'OP${DateTime.now().millisecondsSinceEpoch}',
    );
    setState(() => _isSubmitting = false);
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
    _nameCtrl.dispose(); _ageCtrl.dispose();
    _symptomsCtrl.dispose(); _rzp.dispose();
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
        title: Text(context.tr('opd_title'),
          style: const TextStyle(
              fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // Hospital info
            FadeInDown(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Text('🏥',
                        style: TextStyle(
                            fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.hospital.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w800,
                              color: AppColors.blue,
                            )),
                          Text(
                            widget.hospital.address,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.blue,
                            )),
                        ],
                      ),
                    ),
                    Text(
                      '₹${widget.hospital.consultationFee}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.blue,
                      )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time Slot Selection
            FadeInUp(
              delay: const Duration(milliseconds: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Time Slot',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _timeSlots.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, i) {
                        final slot = _timeSlots[i];
                        final isActive = slot == _selectedTimeSlot;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedTimeSlot = slot),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive ? AppColors.blue : const Color(0xFFE3EAF2),
                                width: isActive ? 1.5 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(slot,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                                  color: isActive ? Colors.white : AppColors.textPrimary,
                                )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Image Upload Section (Optional)
            FadeInUp(
              delay: const Duration(milliseconds: 20),
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.blue.withOpacity(0.3), style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      if (_attachedImage == null) ...[
                        const Icon(Icons.document_scanner_rounded, color: AppColors.blue, size: 32),
                        const SizedBox(height: 8),
                        const Text('Scan Previous Report / Prescription (Optional)', 
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.blue)),
                        const Text('AI will pre-fill the form for you', 
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ] else ...[
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(_attachedImage!, width: 50, height: 50, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Document Attached', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  if (_isAnalyzingImage)
                                    const Row(
                                      children: [
                                        SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
                                        SizedBox(width: 8),
                                        Text('Analyzing data...', style: TextStyle(fontSize: 11, color: AppColors.blue)),
                                      ],
                                    )
                                  else
                                    const Text('Analysis complete ✓', style: TextStyle(fontSize: 11, color: AppColors.teal)),
                                ],
                              ),
                            ),
                            IconButton(onPressed: () => setState(() => _attachedImage = null), icon: const Icon(Icons.close, size: 18)),
                          ],
                        )
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Voice toggle
            FadeInUp(
              delay: const Duration(
                  milliseconds: 50),
              child: Row(
                children: [
                  const Text(
                    'Fill form using voice:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    )),
                  const Spacer(),
                  _ModeToggle(
                    useVoice: _useVoice,
                    onToggle: (v) =>
                        setState(() => _useVoice = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Voice mode
            if (_useVoice) ...[
              FadeInUp(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                        color: const Color(0xFFE3EAF2),
                        width: 0.5),
                  ),
                  child: Column(
                    children: [
                      Text(
                        context.tr('tell_us'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.tr('tell_sub'),
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      VoiceMicButton(
                        size: 80,
                        color: AppColors.blue,
                        onResult: (s, l) =>
                            _onVoiceResult(s, l),
                      ),
                      if (_voiceText.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _TranscriptBox(
                          label: context.tr('you_said'),
                          text: _voiceText,
                          color: AppColors.bgPage,
                        ),
                      ],
                      if (_isTranslating)
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 14, height: 14,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.blue)),
                              SizedBox(width: 8),
                              Text('Translating...',
                                style: TextStyle(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize: 12)),
                            ],
                          ),
                        ),
                      if (_translated.isNotEmpty &&
                          !_isTranslating) ...[
                        const SizedBox(height: 10),
                        _TranscriptBox(
                          label: context.tr(
                              'translated_english'),
                          text: _translated,
                          color: AppColors.blueLight,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Manual form
            FadeInUp(
              delay: const Duration(
                  milliseconds: 100),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFFE3EAF2),
                      width: 0.5),
                ),
                child: Column(
                  children: [
                    _FormField(
                      label: context.tr(
                          'patient_name'),
                      controller: _nameCtrl,
                      isFirst: true,
                    ),
                    _FormField(
                      label: context.tr('age'),
                      controller: _ageCtrl,
                      keyboardType:
                          TextInputType.number,
                    ),
                    _FormField(
                      label: context.tr('symptoms'),
                      controller: _symptomsCtrl,
                      maxLines: 3,
                    ),
                    // Specialization dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              context.tr('department'),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors
                                      .textSecondary))),
                          Expanded(
                            child:
                                DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedSpec,
                                isExpanded: true,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight.w600,
                                  color: AppColors
                                      .textPrimary,
                                ),
                                items: widget.hospital
                                    .specializations
                                    .map((s) =>
                                      DropdownMenuItem(
                                        value: s,
                                        child: Text(s)))
                                    .toList(),
                                onChanged: (v) =>
                                  setState(() =>
                                    _selectedSpec =
                                        v ?? ''),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pre-appointment tips
            FadeInUp(
              delay: const Duration(
                  milliseconds: 150),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEDFE),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💡 Pre-appointment Tips',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3C3489),
                      )),
                    const SizedBox(height: 8),
                    ...[
                      'Arrive 15 minutes early',
                      'Carry previous reports & prescriptions',
                      'List all current medications',
                      'Drink plenty of water',
                    ].map((tip) => Padding(
                      padding: const EdgeInsets.only(
                          bottom: 4),
                      child: Row(
                        children: [
                          const Icon(
                              Icons.check_circle_rounded,
                              size: 14,
                              color: Color(0xFF534AB7)),
                          const SizedBox(width: 6),
                          Text(tip,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF534AB7),
                            )),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pay button
            FadeInUp(
              delay: const Duration(
                  milliseconds: 200),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _pay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5))
                      : Text(
                          '💳 Pay & Book OP '
                          '₹${widget.hospital.consultationFee}',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w800)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  final bool useVoice;
  final ValueChanged<bool> onToggle;
  const _ModeToggle(
      {required this.useVoice, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Pill('✍️ Manual', !useVoice,
              () => onToggle(false)),
          _Pill('🎙 Voice', useVoice,
              () => onToggle(true)),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Pill(this.label, this.active, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : AppColors.textSecondary,
          )),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isFirst, isLast;
  final int maxLines;
  final TextInputType? keyboardType;
  const _FormField({
    required this.label, required this.controller,
    this.isFirst = false, this.isLast = false,
    this.maxLines = 1, this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(
          bottom: BorderSide(
              color: Color(0xFFF0F4F8), width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary)),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Enter $label',
                hintStyle: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(
                        vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TranscriptBox extends StatelessWidget {
  final String label, text;
  final Color color;
  const _TranscriptBox(
      {required this.label, required this.text,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            )),
          const SizedBox(height: 5),
          Text(text,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.5,
            )),
        ],
      ),
    );
  }
}
