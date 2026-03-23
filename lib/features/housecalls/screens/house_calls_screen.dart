import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/app_translations.dart';

// ═══════════════════════════════════════════════════════════════
//  MODELS
// ═══════════════════════════════════════════════════════════════

class HCDoctor {
  final String id;
  final String name;
  final String specialty;
  final String qualification;
  final String hospital;
  final double rating;
  final int reviews;
  final int experience;
  final double visitFee;
  final String emoji;
  final List<String> languages;
  final bool availableToday;
  final String nextSlot;
  final List<String> conditions;

  const HCDoctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.qualification,
    required this.hospital,
    required this.rating,
    required this.reviews,
    required this.experience,
    required this.visitFee,
    required this.emoji,
    required this.languages,
    required this.availableToday,
    required this.nextSlot,
    required this.conditions,
  });
}

class HCBooking {
  final String id;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String address;
  final String problem;
  final String status; // 'upcoming','completed','cancelled'
  final String? imagePath;
  String? reportFindings;
  List<String>? prescribedMeds;
  String? followUpDate;
  String? doctorNotes;

  HCBooking({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.address,
    required this.problem,
    required this.status,
    this.imagePath,
    this.reportFindings,
    this.prescribedMeds,
    this.followUpDate,
    this.doctorNotes,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'specialty': specialty,
        'date': date,
        'time': time,
        'address': address,
        'problem': problem,
        'status': status,
        'imagePath': imagePath ?? '',
        'reportFindings': reportFindings ?? '',
        'prescribedMeds': (prescribedMeds ?? []).join('||'),
        'followUpDate': followUpDate ?? '',
        'doctorNotes': doctorNotes ?? '',
      };

  factory HCBooking.fromMap(Map<String, dynamic> m) => HCBooking(
        id: m['id'],
        doctorId: m['doctorId'],
        doctorName: m['doctorName'],
        specialty: m['specialty'],
        date: m['date'],
        time: m['time'],
        address: m['address'],
        problem: m['problem'],
        status: m['status'],
        imagePath: m['imagePath'] == '' ? null : m['imagePath'],
        reportFindings: m['reportFindings'] == '' ? null : m['reportFindings'],
        prescribedMeds: m['prescribedMeds'] == ''
            ? null
            : (m['prescribedMeds'] as String).split('||'),
        followUpDate: m['followUpDate'] == '' ? null : m['followUpDate'],
        doctorNotes: m['doctorNotes'] == '' ? null : m['doctorNotes'],
      );
}

// ═══════════════════════════════════════════════════════════════
//  MOCK DOCTOR DATA
// ═══════════════════════════════════════════════════════════════

const List<Map<String, dynamic>> _specializations = [
  {'id': 'all',       'label': 'All',              'emoji': '🏥'},
  {'id': 'general',   'label': 'General Physician','emoji': '🩺'},
  {'id': 'cardio',    'label': 'Cardiologist',      'emoji': '❤️'},
  {'id': 'diabetes',  'label': 'Diabetologist',     'emoji': '🩸'},
  {'id': 'pediatric', 'label': 'Pediatrician',      'emoji': '👶'},
  {'id': 'ortho',     'label': 'Orthopedician',     'emoji': '🦴'},
  {'id': 'neuro',     'label': 'Neurologist',       'emoji': '🧠'},
  {'id': 'derma',     'label': 'Dermatologist',     'emoji': '🫁'},
  {'id': 'gynec',     'label': 'Gynecologist',      'emoji': '👩⚕️'},
  {'id': 'ent',       'label': 'ENT Specialist',    'emoji': '👂'},
  {'id': 'physio',    'label': 'Physiotherapist',   'emoji': '🤸'},
  {'id': 'geriatric', 'label': 'Geriatrician',      'emoji': '👴'},
  {'id': 'pulmo',     'label': 'Pulmonologist',     'emoji': '🫁'},
  {'id': 'psych',     'label': 'Psychiatrist',      'emoji': '🧘'},
];

const Map<String, Map<String, String>> _specTranslations = {
  'general':   {'te': 'సాధారణ వైద్యుడు',   'hi': 'सामान्य चिकित्सक',      'ta': 'பொது மருத்துவர்',       'mr': 'सामान्य चिकित्सक',  'kn': 'ಸಾಮಾನ್ಯ ವೈದ್ಯ'},
  'cardio':    {'te': 'హృదయ వైద్యుడు',      'hi': 'हृदय रोग विशेषज्ञ',    'ta': 'இதய நிபுணர்',           'mr': 'हृदयरोग तज्ज्ञ',    'kn': 'ಹೃದ್ರೋಗ ತಜ್ಞ'},
  'diabetes':  {'te': 'మధుమేహ నిపుణుడు',   'hi': 'मधुमेह विशेषज्ञ',       'ta': 'நீரிழிவு நிபுணர்',       'mr': 'मधुमेह तज्ज्ञ',     'kn': 'ಮಧುಮೇಹ ತಜ್ಞ'},
  'pediatric': {'te': 'శిశు వైద్యుడు',       'hi': 'बाल रोग विशेषज्ञ',     'ta': 'குழந்தை மருத்துவர்',   'mr': 'बालरोग तज्ज्ञ',     'kn': 'ಮಕ್ಕಳ ವೈದ್ಯ'},
  'ortho':     {'te': 'ఎముకల వైద్యుడు',     'hi': 'अस्थि रोग विशेषज्ञ',   'ta': 'எலும்பு நிபுணர்',       'mr': 'अस्थिरोग तज्ज्ञ',   'kn': 'ಮೂಳೆ ತಜ್ಞ'},
  'neuro':     {'te': 'నాడీ వైద్యుడు',       'hi': 'न्यूरोलॉजिस्ट',         'ta': 'நரம்பியல் நிபுணர்',    'mr': 'न्यूरोलॉजिस्ट',     'kn': 'ನ್ಯೂರಾಲಜಿಸ್ಟ್'},
  'derma':     {'te': 'చర్మ వైద్యుడు',       'hi': 'त्वचा विशेषज्ञ',        'ta': 'தோல் நிபுணர்',          'mr': 'त्वचारोग तज्ज्ञ',   'kn': 'ಚರ್ಮ ತಜ್ಞ'},
  'gynec':     {'te': 'స్త్రీ వైద్యురాలు',   'hi': 'स्त्री रोग विशेषज्ञ',  'ta': 'மகப்பேறு நிபுணர்',     'mr': 'स्त्रीरोग तज्ज्ञ',  'kn': 'ಸ್ತ್ರೀರೋಗ ತಜ್ಞ'},
  'ent':       {'te': 'చెవి నాసి గొంతు',    'hi': 'कान नाक गला',            'ta': 'காது மூக்கு தொண்டை',  'mr': 'ENT तज्ज्ञ',         'kn': 'ಕಿವಿ ಮೂಗು ಗಂಟಲು'},
  'physio':    {'te': 'శారీరక చికిత్స',      'hi': 'फिजियोथेरेपिस्ट',       'ta': 'இயற்கை மருத்துவர்',   'mr': 'फिजिओथेरपिस्ट',    'kn': 'ಫಿಸಿಯೋಥೆರಪಿಸ್ಟ್'},
  'geriatric': {'te': 'వృద్ధాప్య వైద్యుడు', 'hi': 'जेरिएट्रिशियन',         'ta': 'முதியோர் மருத்துவர்', 'mr': 'जेरियाट्रिशियन',    'kn': 'ವೃದ್ಧಾಪ್ಯ ವೈದ್ಯ'},
  'pulmo':     {'te': 'శ్వాసకోశ వైద్యుడు',  'hi': 'पल्मोनोलॉजिस्ट',        'ta': 'நுரையீரல் நிபுணர்',   'mr': 'पल्मोनोलॉजिस्ट',   'kn': 'ಶ್ವಾಸಕೋಶ ತಜ್ಞ'},
  'psych':     {'te': 'మానసిక వైద్యుడు',    'hi': 'मनोचिकित्सक',            'ta': 'மனநல மருத்துவர்',     'mr': 'मनोचिकित्सक',        'kn': 'ಮನೋ ವೈದ್ಯ'},
};

final List<HCDoctor> _allDoctors = [
  HCDoctor(id: 'd1', name: 'Dr. Priya Sharma', specialty: 'general', qualification: 'MBBS, MD (General Medicine)', hospital: 'Apollo Hospitals', rating: 4.9, reviews: 312, experience: 14, visitFee: 599, emoji: '👩⚕️', languages: ['English', 'Hindi', 'Telugu'], availableToday: true, nextSlot: 'Today 11:00 AM', conditions: ['Fever', 'Cold', 'BP Check', 'General Checkup', 'Fatigue']),
  HCDoctor(id: 'd2', name: 'Dr. Ravi Kumar', specialty: 'cardio', qualification: 'MBBS, MD, DM (Cardiology)', hospital: 'Apollo Hospitals Hyderabad', rating: 4.8, reviews: 428, experience: 18, visitFee: 1299, emoji: '🧑⚕️', languages: ['English', 'Telugu', 'Hindi'], availableToday: true, nextSlot: 'Today 3:00 PM', conditions: ['Chest Pain', 'BP', 'Heart Palpitations', 'Post-surgery follow-up']),
  HCDoctor(id: 'd3', name: 'Dr. Anitha Reddy', specialty: 'diabetes', qualification: 'MBBS, MD, Fellowship (Diabetology)', hospital: 'Care Hospitals', rating: 4.7, reviews: 195, experience: 11, visitFee: 899, emoji: '👩⚕️', languages: ['Telugu', 'English'], availableToday: true, nextSlot: 'Today 2:00 PM', conditions: ['Diabetes Management', 'HbA1c Review', 'Insulin Adjustment', 'Diet Counseling']),
  HCDoctor(id: 'd4', name: 'Dr. Suresh Babu', specialty: 'pediatric', qualification: 'MBBS, DCH, MD (Pediatrics)', hospital: 'Rainbow Hospitals', rating: 4.9, reviews: 521, experience: 16, visitFee: 799, emoji: '🧑⚕️', languages: ['Telugu', 'English', 'Hindi'], availableToday: false, nextSlot: 'Tomorrow 10:00 AM', conditions: ['Child Fever', 'Vaccinations', 'Growth Assessment', 'Newborn Care']),
  HCDoctor(id: 'd5', name: 'Dr. Kavitha Menon', specialty: 'ortho', qualification: 'MBBS, MS (Orthopaedics)', hospital: 'Yashoda Hospitals', rating: 4.6, reviews: 178, experience: 12, visitFee: 999, emoji: '👩⚕️', languages: ['English', 'Malayalam', 'Hindi'], availableToday: true, nextSlot: 'Today 5:00 PM', conditions: ['Joint Pain', 'Fracture Review', 'Physiotherapy Advice', 'Spine Issues']),
  HCDoctor(id: 'd6', name: 'Dr. Venkat Rao', specialty: 'neuro', qualification: 'MBBS, MD, DM (Neurology)', hospital: 'NIMS Hyderabad', rating: 4.8, reviews: 264, experience: 20, visitFee: 1499, emoji: '🧑⚕️', languages: ['Telugu', 'English'], availableToday: false, nextSlot: 'Tomorrow 9:00 AM', conditions: ['Headache', 'Migraine', 'Paralysis Follow-up', 'Memory Issues', 'Epilepsy']),
  HCDoctor(id: 'd7', name: 'Dr. Sneha Patel', specialty: 'derma', qualification: 'MBBS, MD (Dermatology)', hospital: 'Kamineni Hospitals', rating: 4.7, reviews: 303, experience: 9, visitFee: 799, emoji: '👩⚕️', languages: ['English', 'Hindi', 'Gujarati'], availableToday: true, nextSlot: 'Today 1:00 PM', conditions: ['Skin Rash', 'Acne', 'Eczema', 'Hair Loss', 'Psoriasis']),
  HCDoctor(id: 'd8', name: 'Dr. Lakshmi Prasad', specialty: 'gynec', qualification: 'MBBS, MS (OBG)', hospital: 'Fernandez Hospital', rating: 4.9, reviews: 417, experience: 15, visitFee: 999, emoji: '👩⚕️', languages: ['Telugu', 'English', 'Hindi'], availableToday: true, nextSlot: 'Today 4:00 PM', conditions: ['Pregnancy Checkup', 'PCOS', 'Menstrual Issues', 'Post-delivery Care']),
  HCDoctor(id: 'd9', name: 'Dr. Arun Krishnan', specialty: 'ent', qualification: 'MBBS, MS (ENT)', hospital: 'Star Hospitals', rating: 4.6, reviews: 142, experience: 10, visitFee: 699, emoji: '🧑⚕️', languages: ['English', 'Tamil', 'Telugu'], availableToday: true, nextSlot: 'Today 12:00 PM', conditions: ['Ear Pain', 'Sinus', 'Tonsillitis', 'Hearing Issues', 'Vertigo']),
  HCDoctor(id: 'd10', name: 'Dr. Meena Iyer', specialty: 'physio', qualification: 'BPT, MPT (Ortho)', hospital: 'Independent Practitioner', rating: 4.8, reviews: 229, experience: 8, visitFee: 599, emoji: '👩⚕️', languages: ['Tamil', 'English', 'Hindi'], availableToday: true, nextSlot: 'Today 6:00 PM', conditions: ['Back Pain', 'Sports Injury', 'Stroke Rehab', 'Post-Surgery Physio']),
  HCDoctor(id: 'd11', name: 'Dr. Rajesh Gupta', specialty: 'geriatric', qualification: 'MBBS, MD, Fellowship (Geriatrics)', hospital: 'Medicover Hospitals', rating: 4.7, reviews: 156, experience: 22, visitFee: 1199, emoji: '🧑⚕️', languages: ['Hindi', 'English'], availableToday: false, nextSlot: 'Tomorrow 11:00 AM', conditions: ['Elderly Care', 'Dementia', 'Fall Prevention', 'Palliative Care']),
  HCDoctor(id: 'd12', name: 'Dr. Sujatha Nair', specialty: 'pulmo', qualification: 'MBBS, MD (Pulmonology)', hospital: 'Citizen Hospitals', rating: 4.7, reviews: 198, experience: 13, visitFee: 999, emoji: '👩⚕️', languages: ['Malayalam', 'English', 'Hindi'], availableToday: true, nextSlot: 'Today 10:00 AM', conditions: ['Asthma', 'COPD', 'Breathlessness', 'Sleep Apnea', 'Post-COVID Care']),
  HCDoctor(id: 'd13', name: 'Dr. Prasad Kulkarni', specialty: 'psych', qualification: 'MBBS, MD (Psychiatry)', hospital: 'NIMHANS Affiliated', rating: 4.8, reviews: 287, experience: 17, visitFee: 1299, emoji: '🧑⚕️', languages: ['Marathi', 'Hindi', 'English'], availableToday: false, nextSlot: 'Tomorrow 2:00 PM', conditions: ['Anxiety', 'Depression', 'Insomnia', 'Stress Management', 'OCD']),
];

// ═══════════════════════════════════════════════════════════════
//  MAIN SCREEN
// ═══════════════════════════════════════════════════════════════

class HouseCallsScreen extends StatefulWidget {
  const HouseCallsScreen({super.key});

  @override
  State<HouseCallsScreen> createState() => _HouseCallsScreenState();
}

class _HouseCallsScreenState extends State<HouseCallsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedSpec = 'all';
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();
  List<HCBooking> _bookings = [];
  String _lang = 'en';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString('app_language') ?? 'en';
    final rawList = prefs.getStringList('hc_bookings') ?? [];
    setState(() {
      _bookings = rawList.map((raw) {
        final parts = raw.split(';;;');
        final map = <String, dynamic>{};
        for (final p in parts) {
          final idx = p.indexOf(':');
          if (idx != -1) map[p.substring(0, idx)] = p.substring(idx + 1);
        }
        return HCBooking.fromMap(map);
      }).toList();
    });
  }

  Future<void> _saveBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = _bookings.map((b) {
      return b.toMap().entries.map((e) => '\${e.key}:\${e.value}').join(';;;');
    }).toList();
    await prefs.setStringList('hc_bookings', rawList);
  }

  String _specLabel(String id) {
    if (_lang == 'en') {
      final spec = _specializations.firstWhere(
          (s) => s['id'] == id, orElse: () => {'label': id});
      return spec['label'] as String;
    }
    return _specTranslations[id]?[_lang] ??
        (_specializations.firstWhere(
                (s) => s['id'] == id,
                orElse: () => {'label': id})['label'] as String);
  }

  List<HCDoctor> get _filteredDoctors {
    return _allDoctors.where((d) {
      final matchSpec = _selectedSpec == 'all' || d.specialty == _selectedSpec;
      final q = _searchQuery.toLowerCase();
      final matchSearch = q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          _specLabel(d.specialty).toLowerCase().contains(q) ||
          d.conditions.any((c) => c.toLowerCase().contains(q)) ||
          d.hospital.toLowerCase().contains(q);
      return matchSpec && matchSearch;
    }).toList();
  }

  List<HCBooking> get _upcomingBookings =>
      _bookings.where((b) => b.status == 'upcoming').toList();
  List<HCBooking> get _completedBookings =>
      _bookings.where((b) => b.status == 'completed').toList();

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookTab(),
                _buildMyVisitsTab(),
                _buildReportsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B1A2C), Color(0xFF0D2137)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16, right: 16, bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
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
                    Text('AyurVanta HouseCalls',
                        style: TextStyle(color: Colors.white,
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    Text('Doctor visits at your home',
                        style: TextStyle(
                            color: Colors.white60, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.teal, width: 0.5),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.home_rounded,
                        color: AppColors.teal, size: 13),
                    SizedBox(width: 4),
                    Text('Home Visit',
                        style: TextStyle(
                            color: AppColors.teal,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Stats row
          Row(
            children: [
              _statChip('13+', 'Specialties', Icons.medical_services_outlined),
              const SizedBox(width: 8),
              _statChip('60 min', 'Dedicated visit', Icons.timer_outlined),
              const SizedBox(width: 8),
              _statChip('2 hr', 'Arrival time', Icons.local_hospital_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.teal, size: 14),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800)),
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 9),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tabs ────────────────────────────────────────────────────
  Widget _buildTabs() {
    return Container(
      color: const Color(0xFF0D2137),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.teal,
        indicatorWeight: 2.5,
        labelColor: AppColors.teal,
        unselectedLabelColor: Colors.white38,
        labelStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w700),
        tabs: const [
          Tab(text: 'Book Visit'),
          Tab(text: 'My Visits'),
          Tab(text: 'Reports & Rx'),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  TAB 1 — BOOK VISIT
  // ════════════════════════════════════════════════════════════

  Widget _buildBookTab() {
    return Column(
      children: [
        _buildSearchAndFilter(),
        _buildSpecializationChips(),
        Expanded(
          child: _filteredDoctors.isEmpty
              ? _buildEmpty()
              : ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: _filteredDoctors.length,
                  itemBuilder: (_, i) => FadeInUp(
                    delay: Duration(milliseconds: i * 50),
                    child: _DoctorCard(
                      doctor: _filteredDoctors[i],
                      lang: _lang,
                      specLabel: _specLabel(_filteredDoctors[i].specialty),
                      onBook: () => _openBookingWizard(_filteredDoctors[i]),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.bgPage,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFE3EAF2), width: 0.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded,
                      color: AppColors.textHint, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: const InputDecoration(
                        hintText: 'Search doctor, specialty, condition…',
                        hintStyle: TextStyle(
                            color: AppColors.textHint, fontSize: 12),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10),
                      ),
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textPrimary),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchCtrl.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: const Icon(Icons.close_rounded,
                          color: AppColors.textHint, size: 16),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Image pick button
          GestureDetector(
            onTap: _pickImageForDiagnosis,
            child: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.blue.withOpacity(0.3), width: 0.5),
              ),
              child: const Icon(Icons.add_a_photo_outlined,
                  color: AppColors.blue, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationChips() {
    return Container(
      color: Colors.white,
      height: 46,
      padding: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _specializations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final spec = _specializations[i];
          final isActive = _selectedSpec == spec['id'];
          final label = spec['id'] == 'all'
              ? 'All'
              : _specLabel(spec['id'] as String);
          return GestureDetector(
            onTap: () => setState(() => _selectedSpec = spec['id'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.blue : AppColors.bgPage,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? AppColors.blue
                      : const Color(0xFFE0EAF4),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Text(spec['emoji'] as String,
                      style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 5),
                  Text(label,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? Colors.white
                              : AppColors.navyLight)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text('No doctors found',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text('Try searching for "\$_searchQuery" differently',
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  // ── Image diagnosis ─────────────────────────────────────────
  Future<void> _pickImageForDiagnosis() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE3EAF2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('Upload Symptom Image',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            const Text(
                'Take a photo or upload from gallery to help find\\nthe right specialist',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _imageSourceButton(
                    '📷', 'Camera', Colors.blue,
                    () => Navigator.pop(context, ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _imageSourceButton(
                    '🖼️', 'Gallery', AppColors.teal,
                    () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (source == null) return;
    final file = await picker.pickImage(source: source, imageQuality: 80);
    if (file == null || !mounted) return;
    _showImageSpecialtyPicker(file.path);
  }

  Widget _imageSourceButton(
      String emoji, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: color.withOpacity(0.3), width: 0.5),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ],
        ),
      ),
    );
  }

  void _showImageSpecialtyPicker(String imagePath) {
    // Mock AI analysis — in production, call Vision API
    final suggestions = [
      {'spec': 'derma', 'reason': 'Skin condition detected', 'conf': '87%'},
      {'spec': 'general', 'reason': 'General assessment recommended', 'conf': '72%'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                  color: const Color(0xFFE3EAF2),
                  borderRadius: BorderRadius.circular(2)),
            ),
            const Text('AI Specialist Suggestion',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            const Text('Based on your uploaded image',
                style: TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            // Show image preview
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(imagePath),
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Recommended Specialists',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ),
            ),
            const SizedBox(height: 10),
            ...suggestions.map((s) {
              final spec = _specializations.firstWhere(
                  (sp) => sp['id'] == s['spec'],
                  orElse: () => {'label': s['spec'], 'emoji': '🩺'});
              return ListTile(
                leading: Text(spec['emoji'] as String,
                    style: const TextStyle(fontSize: 28)),
                title: Text(_specLabel(s['spec'] as String),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                subtitle: Text(s['reason'] as String,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(s['conf'] as String,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.teal)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedSpec = s['spec'] as String;
                    _tabController.animateTo(0);
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── Booking Wizard ───────────────────────────────────────────
  void _openBookingWizard(HCDoctor doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _BookingWizard(
          doctor: doctor,
          lang: _lang,
          specLabel: _specLabel(doctor.specialty),
          onConfirm: (booking) {
            setState(() {
              _bookings.insert(0, booking);
            });
            _saveBookings();
          },
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  TAB 2 — MY VISITS
  // ════════════════════════════════════════════════════════════

  Widget _buildMyVisitsTab() {
    if (_bookings.isEmpty) {
      return _buildNoVisits();
    }
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        if (_upcomingBookings.isNotEmpty) ...[
          _sectionLabel('Upcoming Visits',
              Icons.calendar_today_rounded, AppColors.blue),
          const SizedBox(height: 10),
          ..._upcomingBookings.map((b) => _BookingCard(
                booking: b,
                onCancel: () => _cancelBooking(b),
                onComplete: () => _markCompleted(b),
                isUpcoming: true,
              )),
          const SizedBox(height: 16),
        ],
        if (_completedBookings.isNotEmpty) ...[
          _sectionLabel('Past Visits',
              Icons.check_circle_outline_rounded, AppColors.teal),
          const SizedBox(height: 10),
          ..._completedBookings.map((b) => _BookingCard(
                booking: b,
                onCancel: () {},
                onComplete: () {},
                isUpcoming: false,
              )),
        ],
      ],
    );
  }

  Widget _buildNoVisits() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏠', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 14),
          const Text('No visits booked yet',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Book a doctor visit from the Book tab',
              style: TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _tabController.animateTo(0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('Book a Visit',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  void _cancelBooking(HCBooking b) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Visit?'),
        content: Text('Cancel visit with \${b.doctorName} on \${b.date}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _bookings.removeWhere((x) => x.id == b.id);
                });
                _saveBookings();
              },
              child: const Text('Yes, Cancel',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  void _markCompleted(HCBooking b) {
    setState(() {
      final idx = _bookings.indexWhere((x) => x.id == b.id);
      if (idx != -1) {
        _bookings[idx] = HCBooking(
          id: b.id, doctorId: b.doctorId,
          doctorName: b.doctorName, specialty: b.specialty,
          date: b.date, time: b.time, address: b.address,
          problem: b.problem, status: 'completed',
          imagePath: b.imagePath,
          reportFindings: 'Patient examined at home. Vitals stable.',
          prescribedMeds: ['Paracetamol 500mg - 3x daily',
              'Cetirizine 10mg - 1x night',
              'Vitamin C 500mg - 1x daily'],
          followUpDate: '7 days',
          doctorNotes: b.problem,
        );
      }
    });
    _saveBookings();
  }

  // ════════════════════════════════════════════════════════════
  //  TAB 3 — REPORTS & RX
  // ════════════════════════════════════════════════════════════

  Widget _buildReportsTab() {
    final completed = _completedBookings
        .where((b) => b.reportFindings != null)
        .toList();

    if (completed.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📋', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 14),
            const Text('No reports yet',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            const Text(
                'Reports & prescriptions will appear\\nafter your home visit',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _sectionLabel('Prescriptions & Reports',
            Icons.description_outlined, AppColors.blue),
        const SizedBox(height: 10),
        ...completed.map((b) => _ReportCard(booking: b)),
      ],
    );
  }

  Widget _sectionLabel(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(text,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  DOCTOR CARD WIDGET
// ═══════════════════════════════════════════════════════════════

class _DoctorCard extends StatelessWidget {
  final HCDoctor doctor;
  final String lang;
  final String specLabel;
  final VoidCallback onBook;

  const _DoctorCard({
    required this.doctor,
    required this.lang,
    required this.specLabel,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.blue.withOpacity(0.15)),
                  ),
                  child: Center(
                    child: Text(doctor.emoji,
                        style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.name,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text(specLabel,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.blue,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(doctor.qualification,
                          style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                // Available badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: doctor.availableToday
                        ? AppColors.teal.withOpacity(0.12)
                        : Colors.orange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    doctor.availableToday ? 'Today' : 'Tomorrow',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: doctor.availableToday
                            ? AppColors.teal
                            : Colors.orange),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Stats row
            Row(
              children: [
                _infoChip('⭐', '\${doctor.rating}',
                    '(\${doctor.reviews})', Colors.amber),
                const SizedBox(width: 8),
                _infoChip('🏥', doctor.hospital, '', AppColors.blue),
                const SizedBox(width: 8),
                _infoChip('📅', '\${doctor.experience} yrs', '', AppColors.teal),
              ],
            ),
            const SizedBox(height: 8),
            // Languages
            Row(
              children: [
                const Icon(Icons.language_rounded,
                    size: 12, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(doctor.languages.join(' • '),
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textHint)),
              ],
            ),
            const SizedBox(height: 8),
            // Conditions
            Wrap(
              spacing: 6, runSpacing: 4,
              children: doctor.conditions.take(4).map((c) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.bgPage,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: const Color(0xFFE3EAF2), width: 0.5),
                    ),
                    child: Text(c,
                        style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary)),
                  )).toList(),
            ),
            const SizedBox(height: 12),
            // Footer
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₹\${doctor.visitFee.toInt()}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary)),
                    const Text('per home visit',
                        style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary)),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(doctor.nextSlot,
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.teal,
                            fontWeight: FontWeight.w700)),
                    const Text('Next available',
                        style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textHint)),
                  ],
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onBook,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Book Visit',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String emoji, String text, String sub, Color color) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 3),
          Flexible(
            child: Text('\$text\$sub',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color)),
          ),
        ],
      ),
    );
  }
}
// ═══════════════════════════════════════════════════════════════
//  BOOKING WIZARD (4 steps)
// ═══════════════════════════════════════════════════════════════

class _BookingWizard extends StatefulWidget {
  final HCDoctor doctor;
  final String lang;
  final String specLabel;
  final void Function(HCBooking) onConfirm;

  const _BookingWizard({
    required this.doctor,
    required this.lang,
    required this.specLabel,
    required this.onConfirm,
  });

  @override
  State<_BookingWizard> createState() => _BookingWizardState();
}

class _BookingWizardState extends State<_BookingWizard> {
  int _step = 0;

  // Step 1 — date/time
  String _selectedDate = '';
  String _selectedTime = '';

  // Step 2 — address
  final _addressCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();

  // Step 3 — problem
  final _problemCtrl = TextEditingController();
  String? _imagePath;
  String _selectedProblemType = '';

  // Step 4 — payment
  String _paymentMode = 'upi';

  final List<String> _dates = _generateDates();
  static List<String> _generateDates() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = now.add(Duration(days: i));
      final months = ['Jan','Feb','Mar','Apr','May','Jun',
          'Jul','Aug','Sep','Oct','Nov','Dec'];
      final days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
      return '\${days[d.weekday % 7]}, \${d.day} \${months[d.month - 1]}';
    });
  }

  final List<String> _timeSlots = [
    '9:00 AM','9:30 AM','10:00 AM','10:30 AM',
    '11:00 AM','11:30 AM','12:00 PM','2:00 PM',
    '2:30 PM','3:00 PM','4:00 PM','4:30 PM',
    '5:00 PM','6:00 PM','6:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = _dates[0];
    _selectedTime = _timeSlots[0];
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _landmarkCtrl.dispose();
    _problemCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step == 0 && (_selectedDate.isEmpty || _selectedTime.isEmpty)) {
      _snack('Please select date and time');
      return;
    }
    if (_step == 1 && _addressCtrl.text.trim().isEmpty) {
      _snack('Please enter your address');
      return;
    }
    if (_step == 2 && _problemCtrl.text.trim().isEmpty) {
      _snack('Please describe your problem');
      return;
    }
    if (_step < 3) {
      setState(() => _step++);
    } else {
      _confirmBooking();
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _confirmBooking() {
    final booking = HCBooking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      doctorId: widget.doctor.id,
      doctorName: widget.doctor.name,
      specialty: widget.specLabel,
      date: _selectedDate,
      time: _selectedTime,
      address: '\${_addressCtrl.text.trim()}'
          '\${_landmarkCtrl.text.trim().isEmpty ? "" : ", \${_landmarkCtrl.text.trim()}"}',
      problem: _problemCtrl.text.trim(),
      status: 'upcoming',
      imagePath: _imagePath,
    );
    widget.onConfirm(booking);
    _showSuccessScreen();
  }

  void _showSuccessScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _BookingSuccessScreen(
          doctorName: widget.doctor.name,
          date: _selectedDate,
          time: _selectedTime,
          fee: widget.doctor.visitFee,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildWizardHeader(),
          _buildStepIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildCurrentStep(),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildWizardHeader() {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16, right: 16, bottom: 14,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_step > 0) {
                setState(() => _step--);
              } else {
                Navigator.pop(context);
              }
            },
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
          // Doctor mini info
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(widget.doctor.emoji,
                  style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.doctor.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                Text(widget.specLabel,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
          Text('₹\${widget.doctor.visitFee.toInt()}',
              style: const TextStyle(
                  color: AppColors.teal,
                  fontSize: 16,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Date & Time', 'Address', 'Problem', 'Confirm'];
    return Container(
      color: AppColors.navyDark,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: List.generate(steps.length, (i) {
          final done = i < _step;
          final active = i == _step;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 3,
                        decoration: BoxDecoration(
                          color: done || active
                              ? AppColors.teal
                              : Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(steps[i],
                          style: TextStyle(
                              fontSize: 9,
                              color: active
                                  ? AppColors.teal
                                  : done
                                      ? Colors.white54
                                      : Colors.white24,
                              fontWeight: active
                                  ? FontWeight.w700
                                  : FontWeight.w400)),
                    ],
                  ),
                ),
                if (i < steps.length - 1) const SizedBox(width: 4),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 0: return _buildStep1();
      case 1: return _buildStep2();
      case 2: return _buildStep3();
      case 3: return _buildStep4();
      default: return const SizedBox();
    }
  }

  // Step 1 — Date & Time
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepTitle('Select Date', 'Choose when the doctor should visit'),
        const SizedBox(height: 14),
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _dates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final d = _dates[i];
              final parts = d.split(', ');
              final isSelected = d == _selectedDate;
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 64,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.blue
                          : const Color(0xFFE3EAF2),
                      width: isSelected ? 1.5 : 0.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(parts[0],
                          style: TextStyle(
                              fontSize: 10,
                              color: isSelected
                                  ? Colors.white70
                                  : AppColors.textHint)),
                      const SizedBox(height: 2),
                      Text(parts.length > 1
                              ? parts[1].split(' ')[0]
                              : '',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary)),
                      Text(parts.length > 1
                              ? parts[1].split(' ')[1]
                              : '',
                          style: TextStyle(
                              fontSize: 10,
                              color: isSelected
                                  ? Colors.white70
                                  : AppColors.textHint)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        _stepTitle('Select Time', 'Available slots for Dr. \${widget.doctor.name.split(' ')[1]}'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10, runSpacing: 10,
          children: _timeSlots.map((t) {
            final isSelected = t == _selectedTime;
            return GestureDetector(
              onTap: () => setState(() => _selectedTime = t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.blue
                        : const Color(0xFFE3EAF2),
                  ),
                ),
                child: Text(t,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Step 2 — Address
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepTitle('Your Address',
            'Doctor will visit you at this address'),
        const SizedBox(height: 16),
        _inputField(
          controller: _addressCtrl,
          label: 'Full Address',
          hint: 'House no, Street, Area, City, State…',
          icon: Icons.home_outlined,
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        _inputField(
          controller: _landmarkCtrl,
          label: 'Landmark (optional)',
          hint: 'Near school, temple, etc.',
          icon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.teal.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.teal.withOpacity(0.2)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: AppColors.teal, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Doctor will call you 30 minutes before arrival. '
                  'Please ensure someone is home.',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.teal,
                      height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Step 3 — Problem description
  Widget _buildStep3() {
    final quickProblems = widget.doctor.conditions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepTitle('Describe Your Problem',
            'Help the doctor prepare before the visit'),
        const SizedBox(height: 12),
        // Quick select
        const Text('Quick select:',
            style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: quickProblems.map((p) {
            final isSelected = _selectedProblemType == p;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedProblemType = p;
                  if (_problemCtrl.text.isEmpty) {
                    _problemCtrl.text = p;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.blue.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.blue
                        : const Color(0xFFE3EAF2),
                  ),
                ),
                child: Text(p,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.blue
                            : AppColors.textPrimary)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // Text input
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE3EAF2)),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 4),
          child: TextField(
            controller: _problemCtrl,
            maxLines: 4,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textPrimary),
            decoration: const InputDecoration(
              hintText:
                  'Describe your symptoms in detail…\\nE.g. Fever since 2 days, headache, cough…',
              hintStyle: TextStyle(
                  color: AppColors.textHint, fontSize: 12),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Image attachment
        GestureDetector(
          onTap: _pickProblemImage,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: _imagePath != null
                      ? AppColors.teal
                      : const Color(0xFFE3EAF2)),
            ),
            child: _imagePath != null
                ? Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_imagePath!),
                          width: 56, height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Image attached ✓',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.teal)),
                            Text('Doctor will review before visit',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _imagePath = null),
                        child: const Icon(Icons.close_rounded,
                            color: Colors.red, size: 18),
                      ),
                    ],
                  )
                : const Row(
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          color: AppColors.blue, size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Attach photo (optional)',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary)),
                            Text(
                                'Rash, wound, or any visible symptom',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: AppColors.textHint),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickProblemImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (file != null && mounted) {
      setState(() => _imagePath = file.path);
    }
  }

  // Step 4 — Review & Payment
  Widget _buildStep4() {
    final total = widget.doctor.visitFee;
    final paymentModes = [
      {'id': 'upi', 'label': 'UPI', 'icon': '📱'},
      {'id': 'card', 'label': 'Card', 'icon': '💳'},
      {'id': 'net', 'label': 'Net Banking', 'icon': '🏦'},
      {'id': 'cash', 'label': 'Cash on Visit', 'icon': '💵'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepTitle('Review & Confirm',
            'Everything looks good? Confirm your booking'),
        const SizedBox(height: 14),
        // Summary card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3EAF2)),
          ),
          child: Column(
            children: [
              // Doctor row
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Text(widget.doctor.emoji,
                        style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.doctor.name,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary)),
                          Text(widget.specLabel,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFF0F4F8)),
              _reviewRow(Icons.calendar_today_rounded,
                  'Date', _selectedDate),
              _reviewRow(Icons.access_time_rounded,
                  'Time', _selectedTime),
              _reviewRow(Icons.home_rounded,
                  'Address', _addressCtrl.text.trim()),
              _reviewRow(Icons.medical_information_outlined,
                  'Problem', _problemCtrl.text.trim()),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Bill
        _stepTitle('Bill Summary', ''),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE3EAF2)),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              _billRow('Visit Fee', '₹\${total.toInt()}'),
              _billRow('Platform fee', '₹0', isGreen: true),
              _billRow('GST (18%)',
                  '₹\${(total * 0.18).toInt()}'),
              const Divider(height: 16),
              _billRow('Total Payable',
                  '₹\${(total + total * 0.18).toInt()}',
                  isBold: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Payment mode
        _stepTitle('Payment Mode', ''),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.8,
          ),
          itemCount: paymentModes.length,
          itemBuilder: (_, i) {
            final pm = paymentModes[i];
            final isActive = _paymentMode == pm['id'];
            return GestureDetector(
              onTap: () =>
                  setState(() => _paymentMode = pm['id'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.blue.withOpacity(0.08)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive
                        ? AppColors.blue
                        : const Color(0xFFE3EAF2),
                    width: isActive ? 1.5 : 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(pm['icon'] as String,
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(pm['label'] as String,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isActive
                                ? AppColors.blue
                                : AppColors.textPrimary)),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _reviewRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppColors.textHint),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _billRow(String label, String value,
      {bool isBold = false, bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: isBold ? 13 : 12,
                  fontWeight:
                      isBold ? FontWeight.w700 : FontWeight.w500,
                  color: AppColors.textPrimary)),
          Text(value,
              style: TextStyle(
                  fontSize: isBold ? 14 : 12,
                  fontWeight:
                      isBold ? FontWeight.w800 : FontWeight.w600,
                  color: isGreen
                      ? AppColors.teal
                      : (isBold
                          ? AppColors.blue
                          : AppColors.textPrimary))),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final labels = ['Next →', 'Next →', 'Next →', 'Confirm & Pay'];
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFECF0F5))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _next,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _step == 3 ? AppColors.teal : AppColors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(labels[_step],
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  Widget _stepTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE3EAF2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Icon(icon, size: 18, color: AppColors.blue),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                    fontSize: 12, color: AppColors.textHint),
                hintText: hint,
                hintStyle: const TextStyle(
                    fontSize: 12, color: AppColors.textHint),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SUCCESS SCREEN
// ═══════════════════════════════════════════════════════════════

class _BookingSuccessScreen extends StatelessWidget {
  final String doctorName;
  final String date;
  final String time;
  final double fee;

  const _BookingSuccessScreen({
    required this.doctorName,
    required this.date,
    required this.time,
    required this.fee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                child: Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.teal.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded,
                      color: AppColors.teal, size: 50),
                ),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: const Text('Visit Booked! 🎉',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
              ),
              const SizedBox(height: 8),
              FadeInUp(
                delay: const Duration(milliseconds: 180),
                child: Text('\$doctorName will visit you on\\n\$date at \$time',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5)),
              ),
              const SizedBox(height: 28),
              FadeInUp(
                delay: const Duration(milliseconds: 250),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE3EAF2)),
                  ),
                  child: Column(
                    children: [
                      _successRow('📅', 'Date', date),
                      const SizedBox(height: 10),
                      _successRow('⏰', 'Time', time),
                      const SizedBox(height: 10),
                      _successRow('💰', 'Amount',
                          '₹\${(fee + fee * 0.18).toInt()} (incl. GST)'),
                      const SizedBox(height: 10),
                      _successRow('📞', 'Reminder',
                          'Doctor calls 30 min before'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 320),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: AppColors.blue, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'After the visit, the doctor will add reports '
                          'and prescriptions directly to your profile '
                          'under Reports & Rx tab.',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.blue,
                              height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Pop all the way back to home
                      Navigator.popUntil(
                          context, (r) => r.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Back to Home',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _successRow(String emoji, String label, String value) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Text('\$label: ',
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary)),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BOOKING CARD (My Visits Tab)
// ═══════════════════════════════════════════════════════════════

class _BookingCard extends StatelessWidget {
  final HCBooking booking;
  final VoidCallback onCancel;
  final VoidCallback onComplete;
  final bool isUpcoming;

  const _BookingCard({
    required this.booking,
    required this.onCancel,
    required this.onComplete,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUpcoming
                        ? AppColors.blue.withOpacity(0.1)
                        : AppColors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isUpcoming ? 'Upcoming' : 'Completed',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isUpcoming
                            ? AppColors.blue
                            : AppColors.teal),
                  ),
                ),
                const Spacer(),
                Text(booking.date,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textHint)),
              ],
            ),
            const SizedBox(height: 10),
            Text(booking.doctorName,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            Text(booking.specialty,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 12, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(booking.time,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
                const SizedBox(width: 14),
                const Icon(Icons.location_on_outlined,
                    size: 12, color: AppColors.textHint),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(booking.address,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.medical_information_outlined,
                    size: 12, color: AppColors.textHint),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(booking.problem,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                ),
              ],
            ),
            if (isUpcoming) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onCancel,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.red.withOpacity(0.3)),
                        ),
                        child: const Center(
                          child: Text('Cancel Visit',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: onComplete,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.teal,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text('Mark Complete',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  REPORT CARD (Reports & Rx Tab)
// ═══════════════════════════════════════════════════════════════

class _ReportCard extends StatefulWidget {
  final HCBooking booking;
  const _ReportCard({required this.booking});

  @override
  State<_ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<_ReportCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.description_outlined,
                        color: AppColors.blue, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.doctorName,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary)),
                        Text(b.specialty,
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.blue,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text('\${b.date} • \${b.time}',
                            style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textHint)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Rx',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppColors.teal)),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textHint, size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFFF0F4F8), height: 1),
                  const SizedBox(height: 12),
                  // Findings
                  if (b.reportFindings != null) ...[
                    _rxSection('🔍 Doctor Findings', b.reportFindings!),
                    const SizedBox(height: 12),
                  ],
                  // Problem
                  _rxSection('🤒 Patient Complaint', b.problem),
                  const SizedBox(height: 12),
                  // Prescribed medicines
                  if (b.prescribedMeds != null &&
                      b.prescribedMeds!.isNotEmpty) ...[
                    const Text('💊 Prescribed Medicines',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    ...b.prescribedMeds!.map((med) => Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F8FF),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.blue.withOpacity(0.15)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.medication_outlined,
                                  color: AppColors.blue, size: 14),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(med,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 10),
                  ],
                  // Follow-up
                  if (b.followUpDate != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.orange.withOpacity(0.25)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event_repeat_rounded,
                              color: Colors.orange, size: 14),
                          const SizedBox(width: 8),
                          Text(
                              'Follow-up recommended in \${b.followUpDate}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  // Save to profile button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(children: [
                              Icon(Icons.check_circle_rounded,
                                  color: Colors.white, size: 16),
                              SizedBox(width: 8),
                              Text('Prescription saved to your profile ✓'),
                            ]),
                            backgroundColor: AppColors.teal,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      icon: const Icon(Icons.save_outlined, size: 16),
                      label: const Text('Save to Profile / Download Rx'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        textStyle: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  Widget _rxSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(content,
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5)),
      ],
    );
  }
}
