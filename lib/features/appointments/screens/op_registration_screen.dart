import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ── Colors ────────────────────────────────────────────────
class _C {
  static const navy     = Color(0xFF0B1A2C);
  static const navyMid  = Color(0xFF1A2E44);
  static const teal     = Color(0xFF1D9E75);
  static const tealL    = Color(0xFFEAF3DE);
  static const blue     = Color(0xFF185FA5);
  static const blueL    = Color(0xFFE6F1FB);
  static const bg       = Color(0xFFF4F7FB);
  static const card     = Color(0xFFFFFFFF);
  static const muted    = Color(0xFFE3EAF2);
  static const text     = Color(0xFF1A2E44);
  static const textSec  = Color(0xFF6B8099);
  static const textHint = Color(0xFF8BAED4);
  static const danger   = Color(0xFFE8243A);
  static const orange   = Color(0xFFBA7517);
  static const orangeL  = Color(0xFFFAEEDA);
  static const purple   = Color(0xFF534AB7);
  static const purpleL  = Color(0xFFEEEDFE);
}

// ── Models ────────────────────────────────────────────────
class Doctor {
  final String id, name, initials, specialization, hospital, qualification;
  final double rating, consultFee;
  final int experience, reviews;
  final Color color;
  final List<String> availableDays;
  final Map<String, List<TimeSlot>> schedule; // date → slots

  const Doctor({
    required this.id,
    required this.name,
    required this.initials,
    required this.specialization,
    required this.hospital,
    required this.qualification,
    required this.rating,
    required this.consultFee,
    required this.experience,
    required this.reviews,
    required this.color,
    required this.availableDays,
    required this.schedule,
  });
}

class TimeSlot {
  final String time, period;
  bool isBooked;
  TimeSlot({required this.time, required this.period, this.isBooked = false});
}

class SymptomCategory {
  final String id, label, emoji, hint;
  const SymptomCategory({
    required this.id,
    required this.label,
    required this.emoji,
    required this.hint,
  });
}

// ── Mock Doctors ──────────────────────────────────────────
List<Doctor> _buildDoctors() {
  TimeSlot s(String t, String p, {bool booked = false}) =>
      TimeSlot(time: t, period: p, isBooked: booked);

  final today = DateTime.now();
  String fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  final d0 = fmtDate(today);
  final d1 = fmtDate(today.add(const Duration(days: 1)));
  final d2 = fmtDate(today.add(const Duration(days: 2)));
  final d3 = fmtDate(today.add(const Duration(days: 3)));

  return [
    Doctor(
      id: 'dr1',
      name: 'Dr. Ramesh Babu',
      initials: 'RB',
      specialization: 'General Medicine',
      hospital: 'AyurVanta Hospital',
      qualification: 'MBBS, MD (Internal Medicine)',
      rating: 4.8,
      consultFee: 300,
      experience: 14,
      reviews: 428,
      color: _C.blue,
      availableDays: ['Mon', 'Wed', 'Fri', 'Sat'],
      schedule: {
        d0: [
          s('09:00 AM', 'Morning', booked: true),
          s('09:30 AM', 'Morning'),
          s('10:00 AM', 'Morning'),
          s('10:30 AM', 'Morning', booked: true),
          s('11:00 AM', 'Morning'),
          s('11:30 AM', 'Morning'),
          s('02:00 PM', 'Afternoon'),
          s('02:30 PM', 'Afternoon', booked: true),
          s('03:00 PM', 'Afternoon'),
          s('03:30 PM', 'Afternoon'),
          s('04:00 PM', 'Afternoon'),
          s('05:00 PM', 'Evening'),
          s('05:30 PM', 'Evening', booked: true),
          s('06:00 PM', 'Evening'),
        ],
        d1: [
          s('09:00 AM', 'Morning'),
          s('09:30 AM', 'Morning'),
          s('10:00 AM', 'Morning', booked: true),
          s('10:30 AM', 'Morning'),
          s('11:00 AM', 'Morning'),
          s('03:00 PM', 'Afternoon'),
          s('03:30 PM', 'Afternoon'),
          s('04:00 PM', 'Afternoon'),
          s('06:00 PM', 'Evening'),
        ],
        d2: [
          s('09:30 AM', 'Morning'),
          s('10:00 AM', 'Morning'),
          s('11:00 AM', 'Morning', booked: true),
          s('04:00 PM', 'Afternoon'),
          s('04:30 PM', 'Afternoon'),
        ],
        d3: [
          s('10:00 AM', 'Morning'),
          s('10:30 AM', 'Morning'),
          s('11:00 AM', 'Morning'),
          s('02:00 PM', 'Afternoon'),
          s('05:00 PM', 'Evening'),
        ],
      },
    ),
    Doctor(
      id: 'dr2',
      name: 'Dr. Kavitha Reddy',
      initials: 'KR',
      specialization: 'Paediatrics',
      hospital: 'AyurVanta Hospital',
      qualification: 'MBBS, DCH, MD (Paediatrics)',
      rating: 4.9,
      consultFee: 350,
      experience: 11,
      reviews: 312,
      color: _C.teal,
      availableDays: ['Mon', 'Tue', 'Thu', 'Sat'],
      schedule: {
        d0: [
          s('09:00 AM', 'Morning'),
          s('09:30 AM', 'Morning', booked: true),
          s('10:00 AM', 'Morning'),
          s('10:30 AM', 'Morning'),
          s('11:00 AM', 'Morning', booked: true),
          s('11:30 AM', 'Morning'),
          s('02:00 PM', 'Afternoon', booked: true),
          s('02:30 PM', 'Afternoon'),
          s('03:00 PM', 'Afternoon'),
          s('05:30 PM', 'Evening'),
          s('06:00 PM', 'Evening'),
        ],
        d1: [
          s('09:00 AM', 'Morning', booked: true),
          s('09:30 AM', 'Morning'),
          s('10:30 AM', 'Morning'),
          s('11:00 AM', 'Morning'),
          s('04:00 PM', 'Afternoon'),
          s('04:30 PM', 'Afternoon'),
          s('06:00 PM', 'Evening'),
        ],
        d2: [
          s('10:00 AM', 'Morning'),
          s('10:30 AM', 'Morning'),
          s('03:00 PM', 'Afternoon'),
          s('05:00 PM', 'Evening'),
          s('05:30 PM', 'Evening'),
        ],
        d3: [
          s('09:00 AM', 'Morning'),
          s('10:00 AM', 'Morning', booked: true),
          s('11:00 AM', 'Morning'),
          s('03:00 PM', 'Afternoon'),
        ],
      },
    ),
    Doctor(
      id: 'dr3',
      name: 'Dr. Suresh Kumar',
      initials: 'SK',
      specialization: 'Cardiology',
      hospital: 'AyurVanta Hospital',
      qualification: 'MBBS, MD, DM (Cardiology)',
      rating: 4.7,
      consultFee: 500,
      experience: 19,
      reviews: 216,
      color: _C.danger,
      availableDays: ['Tue', 'Wed', 'Fri'],
      schedule: {
        d0: [
          s('10:00 AM', 'Morning', booked: true),
          s('10:30 AM', 'Morning'),
          s('11:00 AM', 'Morning'),
          s('11:30 AM', 'Morning', booked: true),
          s('03:00 PM', 'Afternoon'),
          s('03:30 PM', 'Afternoon'),
          s('04:00 PM', 'Afternoon', booked: true),
        ],
        d1: [
          s('09:30 AM', 'Morning'),
          s('10:00 AM', 'Morning'),
          s('11:00 AM', 'Morning'),
          s('02:30 PM', 'Afternoon'),
          s('03:00 PM', 'Afternoon', booked: true),
        ],
        d2: [
          s('10:00 AM', 'Morning'),
          s('10:30 AM', 'Morning', booked: true),
          s('11:30 AM', 'Morning'),
          s('04:00 PM', 'Afternoon'),
        ],
        d3: [
          s('09:00 AM', 'Morning'),
          s('10:00 AM', 'Morning'),
          s('03:00 PM', 'Afternoon'),
          s('05:00 PM', 'Evening'),
        ],
      },
    ),
    Doctor(
      id: 'dr4',
      name: 'Dr. Anitha Varma',
      initials: 'AV',
      specialization: 'Gynaecology',
      hospital: 'AyurVanta Hospital',
      qualification: 'MBBS, MS (Obstetrics & Gynaecology)',
      rating: 4.8,
      consultFee: 400,
      experience: 16,
      reviews: 387,
      color: const Color(0xFFD4537E),
      availableDays: ['Mon', 'Wed', 'Thu', 'Sat'],
      schedule: {
        d0: [
          s('09:00 AM', 'Morning'),
          s('09:30 AM', 'Morning', booked: true),
          s('10:00 AM', 'Morning'),
          s('10:30 AM', 'Morning'),
          s('02:00 PM', 'Afternoon'),
          s('02:30 PM', 'Afternoon', booked: true),
          s('03:00 PM', 'Afternoon'),
          s('05:00 PM', 'Evening'),
          s('05:30 PM', 'Evening'),
        ],
        d1: [
          s('09:00 AM', 'Morning'),
          s('10:00 AM', 'Morning'),
          s('11:00 AM', 'Morning', booked: true),
          s('03:00 PM', 'Afternoon'),
          s('04:00 PM', 'Afternoon'),
        ],
        d2: [
          s('09:30 AM', 'Morning'),
          s('10:30 AM', 'Morning', booked: true),
          s('11:00 AM', 'Morning'),
          s('05:00 PM', 'Evening'),
        ],
        d3: [
          s('10:00 AM', 'Morning'),
          s('10:30 AM', 'Morning'),
          s('03:00 PM', 'Afternoon'),
          s('03:30 PM', 'Afternoon'),
          s('06:00 PM', 'Evening'),
        ],
      },
    ),
    Doctor(
      id: 'dr5',
      name: 'Dr. Venkat Rao',
      initials: 'VR',
      specialization: 'Orthopaedics',
      hospital: 'AyurVanta Hospital',
      qualification: 'MBBS, MS (Orthopaedics)',
      rating: 4.6,
      consultFee: 450,
      experience: 13,
      reviews: 198,
      color: _C.orange,
      availableDays: ['Mon', 'Tue', 'Thu', 'Fri'],
      schedule: {
        d0: [
          s('09:00 AM', 'Morning', booked: true),
          s('09:30 AM', 'Morning'),
          s('10:00 AM', 'Morning'),
          s('10:30 AM', 'Morning', booked: true),
          s('11:30 AM', 'Morning'),
          s('02:00 PM', 'Afternoon'),
          s('03:00 PM', 'Afternoon', booked: true),
          s('04:00 PM', 'Afternoon'),
        ],
        d1: [
          s('09:30 AM', 'Morning'),
          s('10:00 AM', 'Morning'),
          s('10:30 AM', 'Morning', booked: true),
          s('02:00 PM', 'Afternoon'),
          s('03:30 PM', 'Afternoon'),
        ],
        d2: [
          s('09:00 AM', 'Morning'),
          s('10:00 AM', 'Morning'),
          s('11:00 AM', 'Morning', booked: true),
          s('04:00 PM', 'Afternoon'),
        ],
        d3: [
          s('10:00 AM', 'Morning'),
          s('11:00 AM', 'Morning'),
          s('02:30 PM', 'Afternoon'),
          s('05:00 PM', 'Evening'),
        ],
      },
    ),
  ];
}

// ── Symptom Categories ─────────────────────────────────────
const _symptomCategories = [
  SymptomCategory(id: 'fever', label: 'Fever / Cold', emoji: '🤒', hint: 'High temperature, chills, runny nose, body ache'),
  SymptomCategory(id: 'chest', label: 'Chest Pain', emoji: '💔', hint: 'Tightness, pressure, pain in chest or left arm'),
  SymptomCategory(id: 'headache', label: 'Headache', emoji: '🤕', hint: 'Migraine, tension headache, dizziness'),
  SymptomCategory(id: 'stomach', label: 'Stomach / GI', emoji: '🫃', hint: 'Nausea, vomiting, diarrhoea, abdominal pain'),
  SymptomCategory(id: 'breathing', label: 'Breathing', emoji: '🫁', hint: 'Shortness of breath, wheezing, cough'),
  SymptomCategory(id: 'injury', label: 'Injury / Wound', emoji: '🩹', hint: 'Cut, bruise, sprain, fracture, burn'),
  SymptomCategory(id: 'skin', label: 'Skin Issue', emoji: '🧴', hint: 'Rash, itching, redness, swelling'),
  SymptomCategory(id: 'bones', label: 'Joint / Bone', emoji: '🦴', hint: 'Joint pain, back pain, stiffness'),
  SymptomCategory(id: 'eye', label: 'Eye / Ear', emoji: '👁️', hint: 'Vision change, ear pain, discharge'),
  SymptomCategory(id: 'child', label: 'Child Health', emoji: '👶', hint: 'Paediatric concern, growth, vaccination'),
  SymptomCategory(id: 'women', label: "Women's Health", emoji: '🌸', hint: 'Gynaecology, pregnancy, menstrual issues'),
  SymptomCategory(id: 'general', label: 'General / Other', emoji: '💊', hint: 'Other health concern not listed above'),
];

// ════════════════════════════════════════════════════════════
// MAIN SCREEN — STEP CONTROLLER
// ════════════════════════════════════════════════════════════
class OPRegistrationScreen extends StatefulWidget {
  const OPRegistrationScreen({super.key});

  @override
  State<OPRegistrationScreen> createState() => _OPRegistrationScreenState();
}

class _OPRegistrationScreenState extends State<OPRegistrationScreen> {
  int _step = 0; // 0=Patient, 1=Symptom, 2=Doctor, 3=Schedule, 4=Payment, 5=FirstAid

  // Patient form
  final _nameCtrl    = TextEditingController();
  final _ageCtrl     = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _ayurCtrl    = TextEditingController();
  String _gender     = 'Male';
  String _bloodGroup = 'B+';

  // Symptom
  SymptomCategory? _symptomCat;
  final _symptomDescCtrl = TextEditingController();

  // Doctor & Schedule
  final List<Doctor> _doctors = _buildDoctors();
  Doctor? _selectedDoctor;
  int _selectedDayIdx = 0;
  TimeSlot? _selectedSlot;

  // Payment
  String _payMethod = 'upi';
  final _upiCtrl = TextEditingController();

  // First Aid
  String _firstAidContent = '';
  bool _firstAidLoading = false;

  // Token
  String _tokenNumber = '';

  @override
  void dispose() {
    _nameCtrl.dispose(); _ageCtrl.dispose(); _phoneCtrl.dispose();
    _ayurCtrl.dispose(); _symptomDescCtrl.dispose(); _upiCtrl.dispose();
    super.dispose();
  }

  // ── Gemini API call for First Aid ─────────────────────
  static const _geminiKey = 'AIzaSyCn6Fe17Pd1ipAeGv8oM0rcOyEdmtFtlWw';
  static const _geminiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<void> _fetchFirstAid() async {
    setState(() { _firstAidLoading = true; });
    final symptom = _symptomCat?.label ?? 'general';
    final desc    = _symptomDescCtrl.text.trim();

    try {
      final res = await http.post(
        Uri.parse('$_geminiUrl?key=$_geminiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'role': 'user',
            'parts': [{
              'text': '''You are a medical first aid assistant. 
A patient has just registered for an OP appointment. 
Their symptom category is: $symptom
Their description: ${desc.isEmpty ? "Not specified" : desc}
Doctor specialization: ${_selectedDoctor?.specialization ?? "General"}

Provide clear, simple first aid / home care advice they should follow BEFORE seeing the doctor.
Format your response as:
⚡ IMMEDIATE STEPS (3-4 bullet points — what to do right now)
🚫 AVOID (2-3 things NOT to do)
⏰ WHEN TO GO TO EMERGENCY (1-2 warning signs)
🌿 HOME CARE TIPS (2-3 simple tips)

Keep it concise, safe and practical. No diagnoses. Always say "consult your doctor" where relevant.
Use plain language, avoid medical jargon.'''
            }]
          }],
          'generationConfig': {'temperature': 0.4, 'maxOutputTokens': 400},
        }),
      ).timeout(const Duration(seconds: 20));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String? ?? '';
        setState(() { _firstAidContent = text.trim(); });
      } else {
        setState(() { _firstAidContent = _fallbackFirstAid(); });
      }
    } catch (_) {
      setState(() { _firstAidContent = _fallbackFirstAid(); });
    }
    setState(() { _firstAidLoading = false; });
  }

  String _fallbackFirstAid() {
    final s = _symptomCat?.id ?? 'general';
    switch (s) {
      case 'fever':
        return '''⚡ IMMEDIATE STEPS
• Take paracetamol (650mg) if fever > 38.5°C
• Rest and avoid physical activity
• Stay hydrated — drink plenty of water/ORS
• Apply a cool damp cloth on forehead

🚫 AVOID
• Do not take aspirin without doctor advice
• Avoid cold showers during high fever

⏰ WHEN TO GO TO EMERGENCY
• Fever above 104°F (40°C) or convulsions
• Difficulty breathing or severe headache

🌿 HOME CARE TIPS
• Drink coconut water or electrolyte drinks
• Light diet — khichdi, soups, fruits
• Monitor temperature every 4 hours''';

      case 'chest':
        return '''⚡ IMMEDIATE STEPS
• Sit or lie down in a comfortable position
• Loosen tight clothing around chest
• If prescribed, take nitroglycerin as advised
• Call someone to stay with you

🚫 AVOID
• Do not ignore chest pain — take it seriously
• Avoid physical exertion or walking fast

⏰ WHEN TO GO TO EMERGENCY
• Pain radiating to arm, jaw, or back
• Shortness of breath + sweating = CALL 108 NOW

🌿 HOME CARE TIPS
• Keep calm and breathe slowly and deeply
• Chew one aspirin 325mg if not allergic and available''';

      case 'stomach':
        return '''⚡ IMMEDIATE STEPS
• Drink small sips of water or ORS frequently
• Rest your stomach — avoid solid food for 2 hours
• Take ORS if you have diarrhoea or vomiting
• Lie on your left side if nauseous

🚫 AVOID
• Do not take painkillers on empty stomach
• Avoid spicy, oily or fried food

⏰ WHEN TO GO TO EMERGENCY
• Blood in vomit or stool
• Severe pain with high fever or rigid abdomen

🌿 HOME CARE TIPS
• Sip ginger tea or cumin water
• Eat BRAT diet: Bananas, Rice, Applesauce, Toast''';

      default:
        return '''⚡ IMMEDIATE STEPS
• Rest and avoid strenuous activity
• Stay hydrated — drink adequate water
• Monitor your symptoms and note any changes
• Take any regular medications as prescribed

🚫 AVOID
• Do not self-medicate without doctor advice
• Avoid stress and exposure to extreme temperatures

⏰ WHEN TO GO TO EMERGENCY
• Severe pain, high fever above 103°F
• Difficulty breathing or loss of consciousness

🌿 HOME CARE TIPS
• Light, easily digestible food
• Get adequate rest and sleep
• Document your symptoms to tell the doctor''';
    }
  }

  void _next() {
    if (_step == 4) {
      // Payment → fetch first aid + show token
      _tokenNumber = 'OP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      _step = 5;
      _fetchFirstAid();
    } else {
      setState(() => _step++);
    }
    setState(() {});
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: Column(
        children: [
          _buildTopBar(),
          _buildStepIndicator(),
          Expanded(child: _buildStep()),
          if (_step < 5) _buildBottomBar(),
        ],
      ),
    );
  }

  // ── Top Bar ──────────────────────────────────────────────
  Widget _buildTopBar() {
    final titles = [
      'Patient Details',
      'Symptoms',
      'Choose Doctor',
      'Select Schedule',
      'Payment',
      'First Aid & Token',
    ];
    return Container(
      color: _C.navy,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 14,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _step > 0 ? _back : () => Navigator.pop(context),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titles[_step],
                    style: const TextStyle(color: Colors.white,
                        fontSize: 17, fontWeight: FontWeight.w700)),
                Text('Step ${_step + 1} of 6',
                    style: const TextStyle(color: _C.textHint, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _C.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _C.teal, width: 0.5),
            ),
            child: const Text('OP Registration',
                style: TextStyle(color: _C.teal, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── Step Indicator ────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Container(
      color: _C.navyMid,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: List.generate(6, (i) {
          final done = i < _step;
          final current = i == _step;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    decoration: BoxDecoration(
                      color: done || current ? _C.teal : Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (i < 5) const SizedBox(width: 4),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── Bottom Bar ────────────────────────────────────────────
  Widget _buildBottomBar() {
    final canProceed = _canProceed();
    final labels = ['Next: Symptoms', 'Next: Choose Doctor',
        'Next: Schedule', 'Next: Payment', 'Confirm & Pay ₹${_selectedDoctor?.consultFee.toStringAsFixed(0) ?? ""}'];

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _C.muted, width: 0.5)),
      ),
      child: SizedBox(
        width: double.infinity, height: 52,
        child: ElevatedButton(
          onPressed: canProceed ? _next : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _C.teal,
            foregroundColor: Colors.white,
            elevation: 0,
            disabledBackgroundColor: _C.muted,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(labels[_step],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_step) {
      case 0: return _nameCtrl.text.trim().isNotEmpty && _ageCtrl.text.trim().isNotEmpty && _phoneCtrl.text.trim().length >= 10;
      case 1: return _symptomCat != null;
      case 2: return _selectedDoctor != null;
      case 3: return _selectedSlot != null;
      case 4: return true;
      default: return false;
    }
  }

  // ── Route to correct step ──────────────────────────────
  Widget _buildStep() {
    switch (_step) {
      case 0: return _StepPatient(
        nameCtrl: _nameCtrl, ageCtrl: _ageCtrl,
        phoneCtrl: _phoneCtrl, ayurCtrl: _ayurCtrl,
        gender: _gender, bloodGroup: _bloodGroup,
        onGenderChange: (v) => setState(() => _gender = v),
        onBloodChange: (v) => setState(() => _bloodGroup = v),
        onChanged: () => setState(() {}),
      );
      case 1: return _StepSymptom(
        selected: _symptomCat,
        descCtrl: _symptomDescCtrl,
        onSelect: (c) => setState(() => _symptomCat = c),
      );
      case 2: return _StepDoctor(
        doctors: _doctors,
        symptomCat: _symptomCat,
        selected: _selectedDoctor,
        onSelect: (d) => setState(() {
          _selectedDoctor = d;
          _selectedDayIdx = 0;
          _selectedSlot = null;
        }),
      );
      case 3: return _StepSchedule(
        doctor: _selectedDoctor!,
        selectedDayIdx: _selectedDayIdx,
        selectedSlot: _selectedSlot,
        onDayChange: (i) => setState(() { _selectedDayIdx = i; _selectedSlot = null; }),
        onSlotSelect: (s) => setState(() => _selectedSlot = s),
      );
      case 4: return _StepPayment(
        doctor: _selectedDoctor!,
        slot: _selectedSlot!,
        dayIdx: _selectedDayIdx,
        patient: _nameCtrl.text.trim(),
        symptom: _symptomCat!,
        method: _payMethod,
        upiCtrl: _upiCtrl,
        onMethodChange: (m) => setState(() => _payMethod = m),
        onPay: _next,
      );
      case 5: return _StepFirstAid(
        patient: _nameCtrl.text.trim(),
        doctor: _selectedDoctor!,
        slot: _selectedSlot!,
        dayIdx: _selectedDayIdx,
        token: _tokenNumber,
        symptom: _symptomCat!,
        firstAidContent: _firstAidContent,
        isLoading: _firstAidLoading,
        onDone: () => Navigator.pop(context),
      );
      default: return const SizedBox();
    }
  }
}

// ════════════════════════════════════════════════════════════
// STEP 1 — PATIENT DETAILS
// ════════════════════════════════════════════════════════════
class _StepPatient extends StatelessWidget {
  final TextEditingController nameCtrl, ageCtrl, phoneCtrl, ayurCtrl;
  final String gender, bloodGroup;
  final void Function(String) onGenderChange, onBloodChange;
  final VoidCallback onChanged;

  const _StepPatient({
    required this.nameCtrl, required this.ageCtrl,
    required this.phoneCtrl, required this.ayurCtrl,
    required this.gender, required this.bloodGroup,
    required this.onGenderChange, required this.onBloodChange,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: _C.blueL, borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              Icon(Icons.info_outline_rounded, color: _C.blue, size: 16),
              SizedBox(width: 8),
              Expanded(child: Text('Fill patient details to register for OP. Your Ayur ID auto-fills from your profile.',
                  style: TextStyle(fontSize: 12, color: _C.blue, height: 1.4))),
            ]),
          )),
          const SizedBox(height: 20),

          _Label('PATIENT NAME'),
          _Field(ctrl: nameCtrl, hint: 'Full name', icon: Icons.person_outline_rounded,
              keyboard: TextInputType.name, onChanged: (_) => onChanged()),

          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Label('AGE'),
              _Field(ctrl: ageCtrl, hint: 'Years', icon: Icons.cake_outlined,
                  keyboard: TextInputType.number, onChanged: (_) => onChanged()),
            ])),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Label('PHONE'),
              _Field(ctrl: phoneCtrl, hint: '+91 XXXXX', icon: Icons.phone_outlined,
                  keyboard: TextInputType.phone, onChanged: (_) => onChanged()),
            ])),
          ]),

          const SizedBox(height: 14),
          _Label('AYUR ID (Optional)'),
          _Field(ctrl: ayurCtrl, hint: 'AYR-XXXX-XXXX-XXXX', icon: Icons.badge_outlined,
              keyboard: TextInputType.text, onChanged: (_) => onChanged()),

          const SizedBox(height: 16),
          _Label('GENDER'),
          const SizedBox(height: 8),
          Row(children: ['Male', 'Female', 'Other'].map((g) => Expanded(
            child: GestureDetector(
              onTap: () => onGenderChange(g),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: EdgeInsets.only(right: g != 'Other' ? 10 : 0),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: gender == g ? _C.blue : _C.bg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: gender == g ? _C.blue : _C.muted, width: gender == g ? 1.5 : 0.5),
                ),
                child: Center(child: Text(g, style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: gender == g ? Colors.white : _C.textSec,
                ))),
              ),
            ),
          )).toList()),

          const SizedBox(height: 16),
          _Label('BLOOD GROUP'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'].map((bg) =>
              GestureDetector(
                onTap: () => onBloodChange(bg),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: bloodGroup == bg ? _C.danger : _C.bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: bloodGroup == bg ? _C.danger : _C.muted, width: 0.5),
                  ),
                  child: Text(bg, style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: bloodGroup == bg ? Colors.white : _C.textSec,
                  )),
                ),
              )).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// STEP 2 — SYMPTOMS
// ════════════════════════════════════════════════════════════
class _StepSymptom extends StatelessWidget {
  final SymptomCategory? selected;
  final TextEditingController descCtrl;
  final void Function(SymptomCategory) onSelect;

  const _StepSymptom({required this.selected, required this.descCtrl, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(child: const Text('What is your main concern?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _C.text))),
          const SizedBox(height: 4),
          const Text('Select the category that best describes your symptoms',
              style: TextStyle(fontSize: 12, color: _C.textSec)),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.05,
            ),
            itemCount: _symptomCategories.length,
            itemBuilder: (_, i) {
              final cat = _symptomCategories[i];
              final isSelected = selected?.id == cat.id;
              return FadeInUp(
                delay: Duration(milliseconds: i * 40),
                child: GestureDetector(
                  onTap: () => onSelect(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? _C.blueL : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? _C.blue : _C.muted,
                        width: isSelected ? 2 : 0.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cat.emoji, style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 6),
                        Text(cat.label, textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                                color: isSelected ? _C.blue : _C.textSec)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          if (selected != null) ...[
            const SizedBox(height: 16),
            FadeInUp(child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: _C.blueL, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Text(selected!.emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(child: Text(selected!.hint,
                    style: const TextStyle(fontSize: 12, color: _C.textSec, height: 1.4))),
              ]),
            )),
          ],

          const SizedBox(height: 16),
          _Label('DESCRIBE YOUR SYMPTOMS (Optional)'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _C.muted, width: 0.5),
            ),
            child: TextField(
              controller: descCtrl,
              maxLines: 4,
              style: const TextStyle(fontSize: 13, color: _C.text),
              decoration: const InputDecoration(
                hintText: 'E.g. Fever since 2 days, 102°F, with body ache and headache…',
                hintStyle: TextStyle(fontSize: 12, color: _C.textHint),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('The more you describe, the better first aid advice you\'ll receive after booking.',
              style: TextStyle(fontSize: 11, color: _C.textHint, fontStyle: FontStyle.italic)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// STEP 3 — CHOOSE DOCTOR
// ════════════════════════════════════════════════════════════
class _StepDoctor extends StatelessWidget {
  final List<Doctor> doctors;
  final SymptomCategory? symptomCat;
  final Doctor? selected;
  final void Function(Doctor) onSelect;

  const _StepDoctor({required this.doctors, required this.symptomCat,
      required this.selected, required this.onSelect});

  // Suggest doctor based on symptom
  List<Doctor> get _suggested {
    if (symptomCat == null) return doctors;
    final mapping = {
      'fever': 'General Medicine',
      'chest': 'Cardiology',
      'headache': 'General Medicine',
      'stomach': 'General Medicine',
      'breathing': 'General Medicine',
      'injury': 'Orthopaedics',
      'skin': 'General Medicine',
      'bones': 'Orthopaedics',
      'eye': 'General Medicine',
      'child': 'Paediatrics',
      'women': 'Gynaecology',
      'general': 'General Medicine',
    };
    final spec = mapping[symptomCat!.id] ?? 'General Medicine';
    final matched = doctors.where((d) => d.specialization == spec).toList();
    final rest = doctors.where((d) => d.specialization != spec).toList();
    return [...matched, ...rest];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _suggested.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Our Specialists', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _C.text)),
              const SizedBox(height: 4),
              Row(children: [
                Text(symptomCat?.emoji ?? '', style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text('Recommended for: ${symptomCat?.label ?? ""}',
                    style: const TextStyle(fontSize: 12, color: _C.textSec)),
              ]),
            ]),
          );
        }
        final doc = _suggested[i - 1];
        final isFirst = i == 1 && symptomCat != null;
        return FadeInUp(
          delay: Duration(milliseconds: (i - 1) * 80),
          child: _DoctorCard(
            doctor: doc,
            isSelected: selected?.id == doc.id,
            isRecommended: isFirst,
            onSelect: () => onSelect(doc),
          ),
        );
      },
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final bool isSelected, isRecommended;
  final VoidCallback onSelect;

  const _DoctorCard({required this.doctor, required this.isSelected,
      required this.isRecommended, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? _C.blueL : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? _C.blue : _C.muted,
              width: isSelected ? 2 : 0.5),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(color: doctor.color, borderRadius: BorderRadius.circular(14)),
                  child: Center(child: Text(doctor.initials,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(doctor.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.text))),
                      if (isRecommended) Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: _C.tealL, borderRadius: BorderRadius.circular(6)),
                        child: const Text('Recommended', style: TextStyle(fontSize: 9, color: _C.teal, fontWeight: FontWeight.w700)),
                      ),
                    ]),
                    const SizedBox(height: 2),
                    Text(doctor.specialization, style: const TextStyle(fontSize: 12, color: _C.blue, fontWeight: FontWeight.w600)),
                    Text(doctor.qualification, style: const TextStyle(fontSize: 10, color: _C.textHint)),
                    const SizedBox(height: 6),
                    Row(children: [
                      ...List.generate(5, (j) => Icon(
                        j < doctor.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 12, color: _C.orange,
                      )),
                      const SizedBox(width: 4),
                      Text('${doctor.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _C.text)),
                      const SizedBox(width: 4),
                      Text('(${doctor.reviews} reviews)', style: const TextStyle(fontSize: 10, color: _C.textHint)),
                    ]),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: _C.muted),
            const SizedBox(height: 10),
            Row(children: [
              _DocStat(Icons.work_outline_rounded, '${doctor.experience} yrs exp'),
              const SizedBox(width: 16),
              _DocStat(Icons.calendar_today_outlined, doctor.availableDays.join(', ')),
              const Spacer(),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('₹${doctor.consultFee.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _C.blue)),
                const Text('Consultation', style: TextStyle(fontSize: 9, color: _C.textHint)),
              ]),
              const SizedBox(width: 10),
              Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  color: isSelected ? _C.blue : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? _C.blue : _C.muted, width: 2),
                ),
                child: isSelected ? const Icon(Icons.check_rounded, size: 13, color: Colors.white) : null,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _DocStat extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DocStat(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 12, color: _C.textSec),
    const SizedBox(width: 4),
    Text(text, style: const TextStyle(fontSize: 10, color: _C.textSec)),
  ]);
}

// ════════════════════════════════════════════════════════════
// STEP 4 — SCHEDULE PICKER
// ════════════════════════════════════════════════════════════
class _StepSchedule extends StatelessWidget {
  final Doctor doctor;
  final int selectedDayIdx;
  final TimeSlot? selectedSlot;
  final void Function(int) onDayChange;
  final void Function(TimeSlot) onSlotSelect;

  const _StepSchedule({
    required this.doctor, required this.selectedDayIdx,
    required this.selectedSlot, required this.onDayChange,
    required this.onSlotSelect,
  });

  @override
  Widget build(BuildContext context) {
    final dateKeys = doctor.schedule.keys.toList();
    final today = DateTime.now();

    List<String> _dayLabel(String dateStr) {
      final parts = dateStr.split('/');
      final d = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      final diff = d.difference(DateTime(today.year, today.month, today.day)).inDays;
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final dayName = days[d.weekday - 1];
      final label = diff == 0 ? 'Today' : diff == 1 ? 'Tomorrow' : dayName;
      return [label, '${d.day} ${['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month]}'];
    }

    final currentSlots = selectedDayIdx < dateKeys.length ? doctor.schedule[dateKeys[selectedDayIdx]] ?? [] : [];
    final morningSlots = currentSlots.where((s) => s.period == 'Morning').toList();
    final afternoonSlots = currentSlots.where((s) => s.period == 'Afternoon').toList();
    final eveningSlots = currentSlots.where((s) => s.period == 'Evening').toList();
    final available = currentSlots.where((s) => !s.isBooked).length;
    final total = currentSlots.length;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor summary bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: doctor.color, borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(doctor.initials,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(doctor.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.text)),
                Text(doctor.specialization, style: const TextStyle(fontSize: 12, color: _C.textSec)),
              ])),
              Text('₹${doctor.consultFee.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _C.blue)),
            ]),
          ),

          // Date tabs
          Container(
            color: _C.navy,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Select Date', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(children: dateKeys.asMap().entries.map((e) {
                final isActive = e.key == selectedDayIdx;
                final labels = _dayLabel(e.value);
                return Expanded(child: GestureDetector(
                  onTap: () => onDayChange(e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: EdgeInsets.only(right: e.key < dateKeys.length - 1 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isActive ? _C.teal : Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isActive ? _C.teal : Colors.white.withOpacity(0.15),
                        width: 0.5,
                      ),
                    ),
                    child: Column(children: [
                      Text(labels[0], style: TextStyle(
                        color: isActive ? Colors.white : _C.textHint,
                        fontSize: 10, fontWeight: FontWeight.w700,
                      )),
                      const SizedBox(height: 2),
                      Text(labels[1], style: TextStyle(
                        color: isActive ? Colors.white : Colors.white54,
                        fontSize: 11, fontWeight: FontWeight.w800,
                      )),
                    ]),
                  ),
                ));
              }).toList()),
            ]),
          ),

          // Availability summary
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _C.tealL, borderRadius: BorderRadius.circular(8),
                ),
                child: Text('$available/$total slots available',
                    style: const TextStyle(fontSize: 11, color: _C.teal, fontWeight: FontWeight.w700)),
              ),
              const Spacer(),
              _Legend(color: _C.blueL, textColor: _C.blue, label: 'Available'),
              const SizedBox(width: 10),
              _Legend(color: _C.muted, textColor: _C.textHint, label: 'Booked'),
              if (selectedSlot != null) ...[
                const SizedBox(width: 10),
                _Legend(color: _C.teal, textColor: Colors.white, label: 'Selected'),
              ],
            ]),
          ),

          // Slot groups
          if (morningSlots.isNotEmpty) _SlotGroup('🌅 Morning', morningSlots, selectedSlot, onSlotSelect),
          if (afternoonSlots.isNotEmpty) _SlotGroup('☀️ Afternoon', afternoonSlots, selectedSlot, onSlotSelect),
          if (eveningSlots.isNotEmpty) _SlotGroup('🌙 Evening', eveningSlots, selectedSlot, onSlotSelect),

          if (currentSlots.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: Column(children: [
                Text('📅', style: TextStyle(fontSize: 40)),
                SizedBox(height: 12),
                Text('No slots available on this date', style: TextStyle(color: _C.textSec, fontSize: 14)),
              ])),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color, textColor;
  final String label;
  const _Legend({required this.color, required this.textColor, required this.label});

  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 4),
    Text(label, style: TextStyle(fontSize: 10, color: _C.textSec)),
  ]);
}

class _SlotGroup extends StatelessWidget {
  final String title;
  final List<TimeSlot> slots;
  final TimeSlot? selected;
  final void Function(TimeSlot) onSelect;

  const _SlotGroup(this.title, this.slots, this.selected, this.onSelect);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _C.textSec)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: slots.map((slot) {
            final isSelected = selected == slot;
            final booked = slot.isBooked;
            return GestureDetector(
              onTap: booked ? null : () => onSelect(slot),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: booked ? _C.muted : isSelected ? _C.teal : _C.blueL,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: booked ? _C.muted : isSelected ? _C.teal : _C.blue.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: Text(slot.time, style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: booked ? _C.textHint : isSelected ? Colors.white : _C.blue,
                  decoration: booked ? TextDecoration.lineThrough : null,
                )),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
// STEP 5 — PAYMENT
// ════════════════════════════════════════════════════════════
class _StepPayment extends StatelessWidget {
  final Doctor doctor;
  final TimeSlot slot;
  final int dayIdx;
  final String patient;
  final SymptomCategory symptom;
  final String method;
  final TextEditingController upiCtrl;
  final void Function(String) onMethodChange;
  final VoidCallback onPay;

  const _StepPayment({
    required this.doctor, required this.slot, required this.dayIdx,
    required this.patient, required this.symptom, required this.method,
    required this.upiCtrl, required this.onMethodChange, required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final methods = [
      {'id': 'upi',  'label': 'UPI',           'icon': '📱'},
      {'id': 'card', 'label': 'Debit/Credit Card', 'icon': '💳'},
      {'id': 'nb',   'label': 'Net Banking',    'icon': '🏦'},
      {'id': 'cash', 'label': 'Pay at Counter', 'icon': '🪙'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking summary card
          FadeInDown(child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _C.navy, borderRadius: BorderRadius.circular(16),
            ),
            child: Column(children: [
              Row(children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(color: doctor.color, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(doctor.initials,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(doctor.name,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                  Text(doctor.specialization,
                      style: const TextStyle(color: _C.textHint, fontSize: 11)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('₹${doctor.consultFee.toStringAsFixed(0)}',
                      style: const TextStyle(color: _C.teal, fontSize: 18, fontWeight: FontWeight.w800)),
                  const Text('Consult fee', style: TextStyle(color: _C.textHint, fontSize: 10)),
                ]),
              ]),
              const SizedBox(height: 14),
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 12),
              _PayRow('Patient', patient),
              _PayRow('Symptom', symptom.label),
              _PayRow('Slot', slot.time),
              _PayRow('Token', 'Will be generated after payment'),
              const SizedBox(height: 8),
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Total Payable', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                Text('₹${doctor.consultFee.toStringAsFixed(0)}',
                    style: const TextStyle(color: _C.teal, fontSize: 18, fontWeight: FontWeight.w800)),
              ]),
            ]),
          )),

          const SizedBox(height: 20),
          _Label('PAYMENT METHOD'),
          const SizedBox(height: 10),

          ...methods.map((m) {
            final isSelected = method == m['id'];
            return GestureDetector(
              onTap: () => onMethodChange(m['id'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? _C.blueL : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? _C.blue : _C.muted,
                      width: isSelected ? 1.5 : 0.5),
                ),
                child: Column(children: [
                  Row(children: [
                    Text(m['icon'] as String, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Text(m['label'] as String, style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: isSelected ? _C.blue : _C.text,
                    )),
                    const Spacer(),
                    Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        color: isSelected ? _C.blue : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: isSelected ? _C.blue : _C.muted, width: 2),
                      ),
                      child: isSelected ? const Icon(Icons.check_rounded, size: 12, color: Colors.white) : null,
                    ),
                  ]),
                  if (isSelected && m['id'] == 'upi') ...[
                    const SizedBox(height: 10),
                    Row(children: ['GPay', 'PhonePe', 'Paytm', 'BHIM'].map((app) =>
                      Expanded(child: Container(
                        margin: EdgeInsets.only(right: app != 'BHIM' ? 6 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _C.muted, width: 0.5),
                        ),
                        child: Center(child: Text(app, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _C.text))),
                      ))).toList(),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _C.muted, width: 0.5)),
                      child: TextField(
                        controller: upiCtrl,
                        style: const TextStyle(fontSize: 13, color: _C.text),
                        decoration: const InputDecoration(
                          hintText: 'Or enter UPI ID  (name@upi)',
                          hintStyle: TextStyle(fontSize: 12, color: _C.textHint),
                          prefixIcon: Icon(Icons.alternate_email_rounded, size: 16, color: _C.textSec),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ]),
              ),
            );
          }),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: _C.tealL, borderRadius: BorderRadius.circular(10)),
            child: const Row(children: [
              Icon(Icons.lock_outline_rounded, color: _C.teal, size: 14),
              SizedBox(width: 8),
              Expanded(child: Text('256-bit encrypted payment · Your data is safe',
                  style: TextStyle(fontSize: 11, color: _C.teal))),
            ]),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _PayRow extends StatelessWidget {
  final String label, value;
  const _PayRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      Text(label, style: const TextStyle(color: _C.textHint, fontSize: 11)),
      const SizedBox(width: 8),
      Expanded(child: Text(value, textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))),
    ]),
  );
}

// ════════════════════════════════════════════════════════════
// STEP 6 — FIRST AID + TOKEN
// ════════════════════════════════════════════════════════════
class _StepFirstAid extends StatelessWidget {
  final String patient, token, firstAidContent;
  final Doctor doctor;
  final TimeSlot slot;
  final int dayIdx;
  final SymptomCategory symptom;
  final bool isLoading;
  final VoidCallback onDone;

  const _StepFirstAid({
    required this.patient, required this.token, required this.firstAidContent,
    required this.doctor, required this.slot, required this.dayIdx,
    required this.symptom, required this.isLoading, required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Success card
          FadeInDown(child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0B5B3B), Color(0xFF1D9E75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(children: [
              const Text('✅', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 10),
              const Text('Booking Confirmed!',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Thank you, $patient.',
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 16),

              // Token box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
                ),
                child: Column(children: [
                  const Text('YOUR TOKEN NUMBER',
                      style: TextStyle(color: Colors.white60, fontSize: 10, letterSpacing: 1)),
                  const SizedBox(height: 6),
                  Text(token,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  const SizedBox(height: 4),
                  const Text('Show this at the reception desk',
                      style: TextStyle(color: Colors.white60, fontSize: 10)),
                ]),
              ),
              const SizedBox(height: 14),

              // Appointment details
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10),
                ),
                child: Column(children: [
                  _SuccessRow(Icons.person_outline_rounded, doctor.name),
                  const SizedBox(height: 6),
                  _SuccessRow(Icons.local_hospital_outlined, doctor.specialization),
                  const SizedBox(height: 6),
                  _SuccessRow(Icons.access_time_rounded, slot.time),
                  const SizedBox(height: 6),
                  _SuccessRow(Icons.currency_rupee_rounded, '₹${doctor.consultFee.toStringAsFixed(0)} — Paid'),
                ]),
              ),
            ]),
          )),

          const SizedBox(height: 20),

          // First Aid section
          FadeInUp(delay: const Duration(milliseconds: 200), child: Row(children: [
            const Text('🩺', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('First Aid Advice', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _C.text)),
              Text('While you wait for your ${symptom.label} consultation',
                  style: const TextStyle(fontSize: 11, color: _C.textSec)),
            ])),
            Text(symptom.emoji, style: const TextStyle(fontSize: 22)),
          ])),

          const SizedBox(height: 12),

          if (isLoading)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _C.muted, width: 0.5)),
              child: Column(children: [
                const CircularProgressIndicator(color: _C.teal, strokeWidth: 2.5),
                const SizedBox(height: 14),
                Text('Generating personalised first aid advice for ${symptom.label}…',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: _C.textSec, height: 1.5)),
              ]),
            )
          else
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _C.muted, width: 0.5),
                ),
                child: Column(children: [
                  // Disclaimer
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: _C.orangeL, borderRadius: BorderRadius.circular(8)),
                    child: const Row(children: [
                      Icon(Icons.warning_amber_rounded, color: _C.orange, size: 14),
                      SizedBox(width: 6),
                      Expanded(child: Text('This is general first aid guidance. Always follow your doctor\'s advice.',
                          style: TextStyle(fontSize: 10, color: _C.orange, height: 1.4))),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    firstAidContent.isEmpty ? _staticTip() : firstAidContent,
                    style: const TextStyle(fontSize: 13, color: _C.text, height: 1.7),
                  ),
                ]),
              ),
            ),

          const SizedBox(height: 20),

          // Important notice
          FadeInUp(delay: const Duration(milliseconds: 400), child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _C.purpleL, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _C.purple.withOpacity(0.3), width: 0.5),
            ),
            child: Column(children: [
              Row(children: [
                const Icon(Icons.notifications_active_rounded, color: _C.purple, size: 16),
                const SizedBox(width: 8),
                const Expanded(child: Text('What to bring to the appointment',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.purple))),
              ]),
              const SizedBox(height: 10),
              const _BulletItem('Aadhar card / any government ID'),
              const _BulletItem('Previous prescriptions or reports (if any)'),
              const _BulletItem('List of current medications'),
              const _BulletItem('Insurance card (if applicable)'),
            ]),
          )),

          const SizedBox(height: 20),

          // Done button
          FadeInUp(delay: const Duration(milliseconds: 500), child: SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.blue, foregroundColor: Colors.white, elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Done — Go to Home', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _staticTip() => 'Loading first aid tips… please check your internet connection.';
}

class _SuccessRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _SuccessRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 13, color: Colors.white60),
    const SizedBox(width: 8),
    Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
  ]);
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.only(top: 5), child: Icon(Icons.circle, size: 5, color: _C.purple)),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: _C.purple, height: 1.4))),
    ]),
  );
}

// ── Shared Widgets ─────────────────────────────────────────
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(
        fontSize: 11, fontWeight: FontWeight.w700, color: _C.textHint, letterSpacing: 0.8)),
  );
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;
  final TextInputType? keyboard;
  final void Function(String)? onChanged;

  const _Field({required this.ctrl, required this.hint, required this.icon,
      this.keyboard, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.muted, width: 0.5),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: _C.text),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13, color: _C.textHint),
          prefixIcon: Icon(icon, size: 18, color: _C.textSec),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}