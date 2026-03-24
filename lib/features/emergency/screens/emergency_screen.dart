import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../appointments/screens/op_registration_screen.dart';

// ═══════════════════════════════════════════════════
// HOSPITAL MODEL
// ═══════════════════════════════════════════════════
class NearbyHospital {
  final String id, name, address, phone, distance, type;
  final bool hasICU, hasEmergency;
  final double lat, lng;
  bool isSelected;

  NearbyHospital({
    required this.id, required this.name,
    required this.address, required this.phone,
    required this.distance, required this.type,
    required this.hasICU, required this.hasEmergency,
    required this.lat, required this.lng,
    this.isSelected = false,
  });
}

// ═══════════════════════════════════════════════════
// EMERGENCY SCREEN
// ═══════════════════════════════════════════════════
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});
  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with TickerProviderStateMixin {
  // State
  String _selectedType = '';
  String _problem = '';
  String _locationStr = 'Detecting location…';
  double? _lat, _lng;
  bool _alertSent = false;
  bool _isLoading = false;
  bool _isLocating = true;
  bool _locationGranted = false;
  NearbyHospital? _selectedHospital;
  List<NearbyHospital> _hospitals = [];

  // Controllers
  final _problemCtrl = TextEditingController();
  final _pageCtrl = PageController();
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  int _step = 0; // 0=type, 1=hospital, 2=describe, 3=confirm

  // Emergency types
  static const Map<String, Map<String, dynamic>> _types = {
    'Ambulance':   {'icon': Icons.airport_shuttle_rounded, 'color': Color(0xFFE8243A)},
    'Heart Attack':{'icon': Icons.favorite_rounded,         'color': Color(0xFFE8243A)},
    'Accident':    {'icon': Icons.car_crash_rounded,        'color': Color(0xFFE8243A)},
    'Stroke':      {'icon': Icons.psychology_rounded,       'color': Color(0xFF534AB7)},
    'Breathing':   {'icon': Icons.air_rounded,              'color': Color(0xFF185FA5)},
    'Burns':       {'icon': Icons.local_fire_department_rounded, 'color': Color(0xFFD85A30)},
    'Poisoning':   {'icon': Icons.warning_amber_rounded,    'color': Color(0xFF854F0B)},
    'Unconscious': {'icon': Icons.personal_injury_rounded,  'color': Color(0xFF0F6E56)},
    'Childbirth':  {'icon': Icons.child_care_rounded,       'color': Color(0xFFD4537E)},
    'Snake Bite':  {'icon': Icons.pest_control_rounded,     'color': Color(0xFF0F6E56)},
    'Fire':        {'icon': Icons.local_fire_department_outlined, 'color': Color(0xFFD85A30)},
    'Other':       {'icon': Icons.help_outline_rounded,     'color': Color(0xFF4A6080)},
  };

  static const Map<String, List<String>> _firstAid = {
    'Heart Attack': [
      'Make patient sit — do NOT lay flat',
      'Loosen tight clothing around chest',
      'Give Aspirin 325mg if available & not allergic',
      'Begin CPR if patient becomes unconscious',
      'Do NOT give food or water',
    ],
    'Stroke': [
      'Note EXACT time symptoms started',
      'Lay patient on side if vomiting',
      'Do NOT give food, water or medicine',
      'Every minute matters — brain cells dying',
      'Keep patient calm and still',
    ],
    'Accident': [
      'Do NOT move person unless site is unsafe',
      'Control bleeding with firm pressure',
      'Keep person warm and still',
      'Do NOT remove helmet in road accident',
      'Note vehicle numbers if hit-and-run',
    ],
    'Breathing': [
      'Sit patient upright — NEVER lay flat',
      'Loosen all tight clothing',
      'Use inhaler if available for asthma',
      'For choking: 5 back blows + 5 abdominal thrusts',
      'Do not leave patient alone',
    ],
    'Unconscious': [
      'Tap shoulders, shout to check response',
      'Tilt head back, lift chin to open airway',
      'Check breathing for 10 seconds',
      'If not breathing: 30 compressions + 2 breaths',
      'Continue CPR until ambulance arrives',
    ],
    'Burns': [
      'Cool with COOL water for 20 min (NOT ice)',
      'Remove clothing/jewelry around burn if not stuck',
      'Cover loosely with clean cloth',
      'Do NOT apply butter, oil or toothpaste',
      'Do NOT burst blisters',
    ],
    'Snake Bite': [
      'Keep patient calm and STILL',
      'Keep bitten limb BELOW heart level',
      'Remove watches, rings near bite',
      'Do NOT suck venom or apply tourniquet',
      'Note snake appearance — do NOT catch it',
    ],
  };

  @override
  void initState() {
    super.initState();
    _hospitals = _buildHospitals(17.4065, 78.4772);
    _pulseCtrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1600))..repeat();
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.4).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut));
    _requestLocationAndLoad();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _problemCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  // ── Location ─────────────────────────────────────
  Future<void> _requestLocationAndLoad() async {
    setState(() => _isLocating = true);
    try {
      bool svc = await Geolocator.isLocationServiceEnabled();
      if (!svc) {
        _showLocationDialog();
        return;
      }
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        _showLocationDialog();
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10));
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
        _locationGranted = true;
        _locationStr = _coordToArea(pos.latitude, pos.longitude);
        _isLocating = false;
        _hospitals = _buildHospitals(pos.latitude, pos.longitude);
      });
    } catch (_) {
      setState(() {
        _isLocating = false;
        _locationStr = 'Hyderabad, Telangana';
        _hospitals = _buildHospitals(17.4065, 78.4772);
      });
    }
  }

  void _showLocationDialog() {
    showDialog(context: context, barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: const Row(children: [
            Text('📍', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('Location Required',
                style: TextStyle(fontWeight: FontWeight.w800)),
          ]),
          content: const Text(
              'AyurVanta needs your location to find nearby hospitals '
              'and dispatch ambulances to your exact address. '
              'This is critical for emergency response.\n\n'
              'Please grant location permission.',
              style: TextStyle(fontSize: 13, height: 1.5)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
                await _requestLocationAndLoad();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emergency,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Grant Permission')),
          ]));
    setState(() { _isLocating = false; _locationStr = 'Location unavailable'; });
  }

  String _coordToArea(double lat, double lng) {
    if (lat >= 17.3 && lat <= 17.5 && lng >= 78.4 && lng <= 78.6)
      return 'Hyderabad, Telangana';
    if (lat >= 12.9 && lat <= 13.1 && lng >= 77.5 && lng <= 77.7)
      return 'Bengaluru, Karnataka';
    if (lat >= 13.0 && lat <= 13.2 && lng >= 80.1 && lng <= 80.3)
      return 'Chennai, Tamil Nadu';
    if (lat >= 19.0 && lat <= 19.2 && lng >= 72.8 && lng <= 73.0)
      return 'Mumbai, Maharashtra';
    if (lat >= 28.6 && lat <= 28.8 && lng >= 77.1 && lng <= 77.3)
      return 'Delhi NCR';
    return '${lat.toStringAsFixed(3)}, ${lng.toStringAsFixed(3)}';
  }

  List<NearbyHospital> _buildHospitals(double lat, double lng) => [
    NearbyHospital(id:'h1', name:'Apollo Hospitals',
        address:'Jubilee Hills, ${_cityFromCoords(lat, lng)}',
        phone:'040-23607777', distance:'0.8 km',
        type:'Multi-specialty', hasICU: true, hasEmergency: true,
        lat: lat + 0.005, lng: lng + 0.003),
    NearbyHospital(id:'h2', name:'KIMS Hospital',
        address:'Kondapur, ${_cityFromCoords(lat, lng)}',
        phone:'040-44885000', distance:'1.4 km',
        type:'Super-specialty', hasICU: true, hasEmergency: true,
        lat: lat - 0.007, lng: lng + 0.006),
    NearbyHospital(id:'h3', name:'Yashoda Hospital',
        address:'Somajiguda, ${_cityFromCoords(lat, lng)}',
        phone:'040-45672222', distance:'2.1 km',
        type:'Multi-specialty', hasICU: true, hasEmergency: true,
        lat: lat + 0.012, lng: lng - 0.005),
    NearbyHospital(id:'h4', name:'Care Hospital',
        address:'Banjara Hills, ${_cityFromCoords(lat, lng)}',
        phone:'040-30418888', distance:'2.8 km',
        type:'Cardiac specialty', hasICU: true, hasEmergency: true,
        lat: lat - 0.014, lng: lng + 0.010),
    NearbyHospital(id:'h5', name:'Government General Hospital',
        address:'Afzalgunj, ${_cityFromCoords(lat, lng)}',
        phone:'040-24600023', distance:'3.5 km',
        type:'Government', hasICU: true, hasEmergency: true,
        lat: lat + 0.020, lng: lng - 0.012),
  ];

  String _cityFromCoords(double lat, double lng) {
    if (lat >= 17.3 && lat <= 17.5) return 'Hyderabad';
    if (lat >= 12.9 && lat <= 13.1) return 'Bengaluru';
    return 'City';
  }

  // ── Navigate steps ────────────────────────────────
  void _nextStep() {
    if (_step == 0 && _selectedType.isEmpty) {
      _snack('Please select an emergency type'); return;
    }
    if (_step == 1 && _selectedHospital == null) {
      _snack('Please select a hospital'); return;
    }
    if (_step < 3) {
      setState(() => _step++);
      _pageCtrl.animateToPage(_step,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut);
    }
  }

  void _prevStep() {
    if (_step > 0) {
      setState(() => _step--);
      _pageCtrl.animateToPage(_step,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut);
    }
  }

  void _sendAlert() {
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 300), () => HapticFeedback.heavyImpact());
    Future.delayed(const Duration(milliseconds: 600), () => HapticFeedback.heavyImpact());
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() { _isLoading = false; _alertSent = true; });
    });
  }

  void _snack(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg),
        backgroundColor: AppColors.emergency,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12))));

  Future<void> _call(String num) async {
    final uri = Uri.parse('tel:$num');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0507),
      body: Column(children: [
        _topBar(),
        if (_alertSent) Expanded(child: _successView())
        else Expanded(child: Column(children: [
          _stepIndicator(),
          Expanded(child: PageView(
            controller: _pageCtrl,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _step0Types(),
              _step1Hospitals(),
              _step2Describe(),
              _step3Confirm(),
            ])),
          _bottomNav(),
        ])),
      ]));
  }

  // ── Top Bar ────────────────────────────────────────
  Widget _topBar() => Container(
    color: const Color(0xFF1A0A0A),
    padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 14),
    child: Row(children: [
      GestureDetector(onTap: () => Navigator.pop(context),
          child: Container(width: 36, height: 36,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16))),
      const SizedBox(width: 12),
      Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Emergency SOS', style: TextStyle(
            color: Colors.white, fontSize: 17,
            fontWeight: FontWeight.w700)),
        Row(children: [
          Icon(_isLocating ? Icons.location_searching
              : _locationGranted ? Icons.location_on_rounded
              : Icons.location_off_outlined,
              color: _locationGranted
                  ? AppColors.teal : Colors.orange,
              size: 12),
          const SizedBox(width: 4),
          Text(_locationStr, style: TextStyle(
              color: _locationGranted
                  ? AppColors.teal : Colors.orange,
              fontSize: 11)),
        ]),
      ])),
      GestureDetector(onTap: () => _call('112'),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                color: AppColors.emergency,
                borderRadius: BorderRadius.circular(8)),
            child: const Row(children: [
              Icon(Icons.call_rounded,
                  color: Colors.white, size: 14),
              SizedBox(width: 5),
              Text('112', style: TextStyle(color: Colors.white,
                  fontSize: 13, fontWeight: FontWeight.w800)),
            ]))),
    ]));

  // ── Step Indicator ────────────────────────────────
  Widget _stepIndicator() => Container(
    color: const Color(0xFF1A0A0A),
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
    child: Row(children: List.generate(4, (i) {
      final labels = ['Type', 'Hospital', 'Problem', 'Confirm'];
      final done = i < _step;
      final active = i == _step;
      return Expanded(child: Row(children: [
        Expanded(child: Column(children: [
          AnimatedContainer(duration: const Duration(milliseconds: 300),
            height: 3,
            color: done || active
                ? AppColors.emergency
                : Colors.white.withOpacity(0.15)),
          const SizedBox(height: 4),
          Text(labels[i], style: TextStyle(
              color: active ? Colors.white
                  : done ? AppColors.teal
                  : Colors.white38,
              fontSize: 9,
              fontWeight: active ? FontWeight.w700
                  : FontWeight.w500)),
        ])),
        if (i < 3) const SizedBox(width: 4),
      ]));
    })));

  // ── STEP 0: Emergency Type ─────────────────────────
  Widget _step0Types() => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      _sosButton(),
      const SizedBox(height: 16),
      const Text('What is the emergency?',
          style: TextStyle(color: Colors.white, fontSize: 18,
              fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      const Text('Tap to select and see first-aid guidance',
          style: TextStyle(color: Colors.white54, fontSize: 12)),
      const SizedBox(height: 14),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 8,
            mainAxisSpacing: 8, childAspectRatio: 1.05),
        itemCount: _types.length,
        itemBuilder: (_, i) {
          final label = _types.keys.elementAt(i);
          final data  = _types.values.elementAt(i);
          final sel   = _selectedType == label;
          final color = data['color'] as Color;
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _selectedType = label);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: sel ? color.withOpacity(0.18)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: sel ? color
                        : Colors.white.withOpacity(0.1),
                    width: sel ? 2 : 0.5)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Icon(data['icon'] as IconData,
                    color: sel ? color : Colors.white54,
                    size: 26),
                const SizedBox(height: 5),
                Text(label, textAlign: TextAlign.center,
                    style: TextStyle(color: sel ? color
                        : Colors.white54, fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ])));
        }),
      // First-aid panel
      if (_selectedType.isNotEmpty &&
          _firstAid.containsKey(_selectedType)) ...[
        const SizedBox(height: 14),
        _firstAidPanel(),
      ],
      const SizedBox(height: 80),
    ]));

  Widget _sosButton() => Center(
    child: SizedBox(width: 160, height: 160,
      child: Stack(alignment: Alignment.center, children: [
        AnimatedBuilder(animation: _pulseAnim, builder: (_, __) =>
            Transform.scale(scale: _pulseAnim.value,
                child: Container(width: 140, height: 140,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.emergency.withOpacity(
                              1 - ((_pulseAnim.value - 0.85) /
                                  0.55).clamp(0, 1)),
                          width: 2))))),
        Container(width: 110, height: 110,
            decoration: BoxDecoration(
                color: _alertSent
                    ? AppColors.teal : AppColors.emergency,
                shape: BoxShape.circle),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Icon(_alertSent ? Icons.check_rounded
                  : Icons.emergency_share_rounded,
                  color: Colors.white, size: 36),
              const SizedBox(height: 4),
              Text(_alertSent ? 'SENT' : 'SOS',
                  style: const TextStyle(color: Colors.white,
                      fontSize: 16, fontWeight: FontWeight.w900,
                      letterSpacing: 3)),
            ])),
      ])));

  Widget _firstAidPanel() {
    final color = _types[_selectedType]!['color'] as Color;
    final steps = _firstAid[_selectedType] ?? [];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: color.withOpacity(0.4), width: 1)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Row(children: [
          Icon(_types[_selectedType]!['icon'] as IconData,
              color: color, size: 16),
          const SizedBox(width: 6),
          Text('First Aid — $_selectedType',
              style: TextStyle(color: color, fontSize: 13,
                  fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 10),
        ...steps.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Container(width: 18, height: 18,
                  decoration: BoxDecoration(
                      color: color, shape: BoxShape.circle),
                  child: Center(child: Text('${e.key + 1}',
                      style: const TextStyle(color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800)))),
              const SizedBox(width: 7),
              Expanded(child: Text(e.value,
                  style: const TextStyle(color: Colors.white,
                      fontSize: 12, height: 1.4))),
            ]))),
      ]));
  }

  // ── STEP 1: Hospital ──────────────────────────────
  Widget _step1Hospitals() => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      if (_isLocating) const Center(child: Column(children: [
        SizedBox(height: 30),
        CircularProgressIndicator(color: AppColors.teal),
        SizedBox(height: 12),
        Text('Finding nearby hospitals…',
            style: TextStyle(color: Colors.white54, fontSize: 13)),
      ])) else ...[
        Row(children: [
          const Icon(Icons.local_hospital_rounded,
              color: AppColors.emergency, size: 18),
          const SizedBox(width: 8),
          const Text('Select Hospital',
              style: TextStyle(color: Colors.white, fontSize: 18,
                  fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 4),
        const Text(
            'Hospital will receive your alert and prepare ICU/stretcher',
            style: TextStyle(color: Colors.white54, fontSize: 11)),
        const SizedBox(height: 14),
        ..._hospitals.map((h) => _hospitalCard(h)),
      ],
      const SizedBox(height: 80),
    ]));

  Widget _hospitalCard(NearbyHospital h) {
    final sel = _selectedHospital?.id == h.id;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedHospital = h);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: sel ? AppColors.emergency.withOpacity(0.12)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: sel ? AppColors.emergency
                    : Colors.white.withOpacity(0.12),
                width: sel ? 2 : 0.5)),
        child: Row(children: [
          Container(width: 44, height: 44,
              decoration: BoxDecoration(
                  color: sel ? AppColors.emergency.withOpacity(0.2)
                      : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.local_hospital_rounded,
                  color: sel ? AppColors.emergency
                      : Colors.white54, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(h.name, style: const TextStyle(color: Colors.white,
                fontSize: 13, fontWeight: FontWeight.w800)),
            Text(h.address, style: const TextStyle(
                color: Colors.white54, fontSize: 11)),
            const SizedBox(height: 4),
            Row(children: [
              _htag('📍 ${h.distance}',
                  const Color(0xFF1D9E75)),
              const SizedBox(width: 6),
              if (h.hasICU) _htag('🏥 ICU', AppColors.blue),
              const SizedBox(width: 6),
              if (h.hasEmergency)
                _htag('🚨 24/7', AppColors.emergency),
            ]),
          ])),
          GestureDetector(
            onTap: () => _call(h.phone),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.call_rounded,
                  color: AppColors.teal, size: 18))),
        ])));
  }

  Widget _htag(String t, Color c) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
          color: c.withOpacity(0.15),
          borderRadius: BorderRadius.circular(5)),
      child: Text(t, style: TextStyle(
          color: c, fontSize: 9, fontWeight: FontWeight.w700)));

  // ── STEP 2: Describe Problem ───────────────────────
  Widget _step2Describe() => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      const Text('Describe the Problem',
          style: TextStyle(color: Colors.white, fontSize: 18,
              fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      const Text(
          'Doctors at the hospital will read this before you arrive',
          style: TextStyle(color: Colors.white54, fontSize: 12)),
      const SizedBox(height: 16),
      // Problem text field
      Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: Colors.white.withOpacity(0.15), width: 0.5)),
        child: TextField(
          controller: _problemCtrl,
          maxLines: 6,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          onChanged: (v) => setState(() => _problem = v),
          decoration: const InputDecoration(
            hintText: 'e.g., "55-year-old male, severe chest pain '
                'radiating to left arm, sweating heavily, '
                'started 20 minutes ago. Taking blood thinners."',
            hintStyle: TextStyle(
                color: Colors.white24, fontSize: 12, height: 1.5),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16)))),
      const SizedBox(height: 12),
      // Mic button
      GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          _snack('🎤 Speak now… (Voice input activated)');
        },
        child: Container(
          width: double.infinity, height: 52,
          decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.blue.withOpacity(0.4), width: 1)),
          child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Icon(Icons.mic_rounded, color: AppColors.blue, size: 22),
            SizedBox(width: 8),
            Text('Speak your problem',
                style: TextStyle(color: AppColors.blue,
                    fontSize: 14, fontWeight: FontWeight.w700)),
          ]))),
      const SizedBox(height: 16),
      // Quick templates
      const Text('Quick templates:',
          style: TextStyle(color: Colors.white54, fontSize: 11,
              fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8,
          children: [
        'Chest pain', 'Difficulty breathing', 'Not responding',
        'High fever', 'Severe bleeding', 'Diabetic emergency',
      ].map((t) => GestureDetector(
        onTap: () {
          setState(() {
            _problem = t;
            _problemCtrl.text = t;
          });
        },
        child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.white.withOpacity(0.12))),
            child: Text(t, style: const TextStyle(
                color: Colors.white70, fontSize: 11))))).toList()),
      const SizedBox(height: 80),
    ]));

  // ── STEP 3: Confirm & Send ─────────────────────────
  Widget _step3Confirm() => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(children: [
      _sosButton(),
      const SizedBox(height: 16),
      const Text('Confirm & Send Alert',
          style: TextStyle(color: Colors.white, fontSize: 18,
              fontWeight: FontWeight.w800)),
      const SizedBox(height: 16),
      // Summary card
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: Colors.white.withOpacity(0.12), width: 0.5)),
        child: Column(children: [
          _summaryRow('🚨 Emergency', _selectedType),
          const Divider(color: Colors.white10, height: 16),
          _summaryRow('🏥 Hospital',
              _selectedHospital?.name ?? 'Not selected'),
          const Divider(color: Colors.white10, height: 16),
          _summaryRow('📍 Location', _locationStr),
          const Divider(color: Colors.white10, height: 16),
          _summaryRow('📋 Problem',
              _problem.isEmpty ? 'Not specified' : _problem),
        ])),
      const SizedBox(height: 14),
      // What hospital will do
      if (_selectedHospital != null) Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: AppColors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: AppColors.teal.withOpacity(0.3), width: 0.5)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          const Row(children: [
            Icon(Icons.notifications_active_rounded,
                color: AppColors.teal, size: 16),
            SizedBox(width: 7),
            Text('Alert will trigger at hospital:',
                style: TextStyle(color: AppColors.teal,
                    fontSize: 12, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 8),
          ...[
            '🔔 Reception alarm rings immediately',
            '🛏️ ICU bed preparation begins',
            '🚑 Stretcher placed outside entrance',
            '👨⚕️ Emergency doctor on standby',
            '🩸 Blood type prep if critical',
          ].map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(t, style: const TextStyle(
                  color: Colors.white70, fontSize: 12)))),
        ])),
      const SizedBox(height: 20),
      // SEND button
      SizedBox(width: double.infinity, height: 58,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _sendAlert,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emergency,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
            child: _isLoading
                ? const SizedBox(width: 26, height: 26,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5))
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(Icons.emergency_share_rounded, size: 22),
                  SizedBox(width: 10),
                  Text('SEND EMERGENCY ALERT',
                      style: TextStyle(fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5)),
                ]))),
      const SizedBox(height: 10),
      Container(padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(10)),
        child: const Row(children: [
          Icon(Icons.lock_outline_rounded,
              color: Colors.white38, size: 14),
          SizedBox(width: 8),
          Expanded(child: Text(
              'No payment at emergency stage. '
              'Handled post-care via Ayur ID.',
              style: TextStyle(color: Colors.white38,
                  fontSize: 11))),
        ])),
      const SizedBox(height: 80),
    ]));

  Widget _summaryRow(String l, String v) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    Text(l, style: const TextStyle(color: Colors.white54,
        fontSize: 12)),
    const SizedBox(width: 8),
    Expanded(child: Text(v, style: const TextStyle(
        color: Colors.white, fontSize: 12,
        fontWeight: FontWeight.w600),
        textAlign: TextAlign.end)),
  ]);

  // ── Bottom Nav ─────────────────────────────────────
  Widget _bottomNav() => Container(
    color: const Color(0xFF1A0A0A),
    padding: EdgeInsets.fromLTRB(16, 10, 16,
        MediaQuery.of(context).padding.bottom + 10),
    child: Row(children: [
      if (_step > 0) GestureDetector(
        onTap: _prevStep,
        child: Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: Colors.white.withOpacity(0.12))),
          child: const Icon(Icons.arrow_back_rounded,
              color: Colors.white, size: 20))),
      if (_step > 0) const SizedBox(width: 12),
      Expanded(child: SizedBox(height: 48,
          child: ElevatedButton(
            onPressed: _step == 3 ? null : _nextStep,
            style: ElevatedButton.styleFrom(
                backgroundColor: _step == 3
                    ? Colors.transparent : AppColors.emergency,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14))),
            child: Text(_step == 3 ? 'Confirm above ↑'
                : _step == 2 ? 'Review & Confirm →'
                : 'Next →',
                style: const TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w700))))),
    ]));

  // ── Success View ───────────────────────────────────
  Widget _successView() => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(children: [
      const SizedBox(height: 20),
      ZoomIn(child: Container(width: 100, height: 100,
          decoration: const BoxDecoration(
              color: Color(0xFFEAF3DE), shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded,
              color: AppColors.teal, size: 56))),
      const SizedBox(height: 20),
      FadeInUp(delay: const Duration(milliseconds: 200),
          child: const Text('Alert Sent! Help is coming 🚑',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 22,
                  fontWeight: FontWeight.w800))),
      const SizedBox(height: 8),
      FadeInUp(delay: const Duration(milliseconds: 300),
          child: Text(
              '${_selectedHospital?.name ?? "Hospital"} has been '
              'notified. ICU & stretcher being prepared.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60,
                  fontSize: 13, height: 1.5))),
      const SizedBox(height: 24),
      // Dispatch info
      FadeInUp(delay: const Duration(milliseconds: 400),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Colors.white.withOpacity(0.1))),
            child: Column(children: [
              _dispatchRow(Icons.airport_shuttle_rounded,
                  'Ambulance Dispatched', 'ETA 4 min · Unit AY-042',
                  'En Route', AppColors.teal),
              const Divider(color: Colors.white10, height: 20),
              _dispatchRow(Icons.local_hospital_rounded,
                  _selectedHospital?.name ?? 'Hospital Alerted',
                  'ICU bed · Stretcher · Duty doctor',
                  '✓ Ready', AppColors.blue),
              const Divider(color: Colors.white10, height: 20),
              _dispatchRow(Icons.notifications_active_rounded,
                  'Reception Alarm Triggered',
                  'Staff alerted with your problem description',
                  'Active', AppColors.emergency),
            ]))),
      const SizedBox(height: 16),
      FadeInUp(delay: const Duration(milliseconds: 500),
          child: Row(children: [
        Expanded(child: GestureDetector(
          onTap: () => _call(_selectedHospital?.phone ?? '112'),
          child: Container(height: 50,
              decoration: BoxDecoration(
                  color: AppColors.emergency.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.emergency, width: 0.5)),
              child: const Center(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Icon(Icons.call_rounded,
                    color: AppColors.emergency, size: 16),
                SizedBox(width: 6),
                Text('Call Hospital',
                    style: TextStyle(color: AppColors.emergency,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ]))))),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 50,
            decoration: BoxDecoration(
                color: AppColors.teal.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.teal, width: 0.5)),
            child: const Center(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Icon(Icons.location_on_rounded,
                  color: AppColors.teal, size: 16),
              SizedBox(width: 6),
              Text('Track Ambulance',
                  style: TextStyle(color: AppColors.teal,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
            ])))),
      ])),
      const SizedBox(height: 16),
      FadeInUp(delay: const Duration(milliseconds: 600),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => const OPRegistrationScreen(isEmergency: true)
                ));
              },
              icon: const Icon(Icons.flash_on_rounded, size: 20),
              label: const Text('Book Priority Appointment',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8243A),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          )),
      const SizedBox(height: 30),
    ]));

  Widget _dispatchRow(IconData icon, String title, String sub,
      String badge, Color c) => Row(children: [
    Container(width: 38, height: 38,
        decoration: BoxDecoration(
            color: AppColors.emergency.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.emergency, size: 18)),
    const SizedBox(width: 12),
    Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: Colors.white,
          fontSize: 12, fontWeight: FontWeight.w700)),
      Text(sub, style: const TextStyle(
          color: Colors.white38, fontSize: 10)),
    ])),
    Container(padding: const EdgeInsets.symmetric(
        horizontal: 9, vertical: 4),
        decoration: BoxDecoration(color: c,
            borderRadius: BorderRadius.circular(7)),
        child: Text(badge, style: const TextStyle(
            color: Colors.white, fontSize: 9,
            fontWeight: FontWeight.w700))),
  ]);
}
