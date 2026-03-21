import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import 'opportunities_home_screen.dart';

class OpportunitiesAuthScreen extends StatefulWidget {
  const OpportunitiesAuthScreen({super.key});
  @override
  State<OpportunitiesAuthScreen> createState() => _OpportunitiesAuthScreenState();
}

class _OpportunitiesAuthScreenState extends State<OpportunitiesAuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginEmailCtrl = TextEditingController();
  final _loginPassCtrl = TextEditingController();
  final _regNameCtrl = TextEditingController();
  final _regEmailCtrl = TextEditingController();
  final _regPhoneCtrl = TextEditingController();
  final _regPassCtrl = TextEditingController();
  final _regQualCtrl = TextEditingController();
  String _selectedRole = 'Doctor';
  String _selectedExp = 'Fresher (0-1 yr)';
  bool _passVisible = false;
  bool _isLoading = false;
  bool _agreeTerms = false;

  static const _roles = [
    'Doctor','Nurse','Pharmacist','Lab Technician','Physiotherapist',
    'Radiologist','Hospital Admin','Medical Coder','Clinical Researcher',
    'Dentist','Paramedic','Healthcare IT','Other',
  ];
  static const _expLevels = [
    'Fresher (0-1 yr)','1-3 years','3-5 years','5-10 years','10+ years',
  ];
  static const _roleEmojis = {
    'Doctor':'👨⚕️','Nurse':'👩⚕️','Pharmacist':'💊','Lab Technician':'🔬',
    'Physiotherapist':'🏋️','Radiologist':'📡','Hospital Admin':'🏥',
    'Medical Coder':'💻','Clinical Researcher':'🧪','Dentist':'🦷',
    'Paramedic':'🚑','Healthcare IT':'🖥️','Other':'⚕️',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkLogin();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailCtrl.dispose(); _loginPassCtrl.dispose();
    _regNameCtrl.dispose(); _regEmailCtrl.dispose();
    _regPhoneCtrl.dispose(); _regPassCtrl.dispose();
    _regQualCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkLogin() async {
    final p = await SharedPreferences.getInstance();
    if ((p.getBool('opp_logged_in') ?? false) && mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const OpportunitiesHomeScreen()));
    }
  }

  Future<void> _login() async {
    if (_loginEmailCtrl.text.trim().isEmpty || _loginPassCtrl.text.isEmpty) {
      _snack('Please enter email and password'); return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final p = await SharedPreferences.getInstance();
    await p.setBool('opp_logged_in', true);
    final name = _loginEmailCtrl.text.split('@').first;
    await p.setString('opp_user_name', name[0].toUpperCase() + name.substring(1));
    await p.setString('opp_user_email', _loginEmailCtrl.text);
    await p.setString('opp_user_role', _selectedRole);
    setState(() => _isLoading = false);
    _goHome();
  }

  Future<void> _register() async {
    if (_regNameCtrl.text.trim().isEmpty || _regEmailCtrl.text.trim().isEmpty ||
        _regPhoneCtrl.text.trim().isEmpty || _regPassCtrl.text.isEmpty) {
      _snack('Please fill all required fields'); return;
    }
    if (!_agreeTerms) { _snack('Please agree to Terms & Conditions'); return; }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final p = await SharedPreferences.getInstance();
    await p.setBool('opp_logged_in', true);
    await p.setString('opp_user_name', _regNameCtrl.text.trim());
    await p.setString('opp_user_email', _regEmailCtrl.text.trim());
    await p.setString('opp_user_role', _selectedRole);
    await p.setString('opp_user_exp', _selectedExp);
    await p.setString('opp_user_qual', _regQualCtrl.text.trim());
    setState(() => _isLoading = false);
    _goHome();
  }

  Future<void> _socialLogin(String name, String email) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final p = await SharedPreferences.getInstance();
    await p.setBool('opp_logged_in', true);
    await p.setString('opp_user_name', name);
    await p.setString('opp_user_email', email);
    await p.setString('opp_user_role', _selectedRole);
    setState(() => _isLoading = false);
    _goHome();
  }

  void _goHome() {
    Navigator.pushReplacement(context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OpportunitiesHomeScreen(),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ));
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.navyMid,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: SingleChildScrollView(
        child: Column(children: [_hero(), _authCard(), const SizedBox(height: 40)]),
      ),
    );
  }

  Widget _hero() {
    return Container(
      height: 280,
      color: const Color(0xFF0A1628),
      child: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: _BgPainter())),
        SafeArea(child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 12),
              Container(width: 32, height: 32,
                decoration: BoxDecoration(color: AppColors.teal,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.health_and_safety_rounded,
                    color: Colors.white, size: 18)),
              const SizedBox(width: 8),
              const Text('AyurVanta', style: TextStyle(color: Colors.white,
                  fontSize: 16, fontWeight: FontWeight.w700)),
              Container(
                margin: const EdgeInsets.only(left: 5),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.teal,
                    borderRadius: BorderRadius.circular(4)),
                child: const Text('JOBS', style: TextStyle(color: Colors.white,
                    fontSize: 9, fontWeight: FontWeight.w800)),
              ),
            ]),
            const Spacer(),
            FadeInLeft(child: const Text('Your Medical\nCareer Starts Here',
                style: TextStyle(color: Colors.white, fontSize: 28,
                    fontWeight: FontWeight.w800, height: 1.2))),
            const SizedBox(height: 8),
            const Text('50,000+ verified healthcare jobs · AIIMS · Apollo · Fortis · NHM',
                style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            const SizedBox(height: 14),
            Row(children: [
              _pill('50K+', 'Jobs'), const SizedBox(width: 8),
              _pill('12K+', 'Hospitals'), const SizedBox(width: 8),
              _pill('2L+', 'Professionals'),
            ]),
            const SizedBox(height: 16),
          ]),
        )),
      ]),
    );
  }

  Widget _pill(String v, String l) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.5)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(v, style: const TextStyle(color: AppColors.teal,
          fontSize: 13, fontWeight: FontWeight.w800)),
      const SizedBox(width: 4),
      Text(l, style: const TextStyle(color: Colors.white60, fontSize: 11)),
    ]),
  );

  Widget _authCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15),
            blurRadius: 30, offset: const Offset(0, -10))],
      ),
      child: Column(children: [
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFF4F7FB),
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(4),
          child: TabBar(
            controller: _tabController,
            onTap: (_) => setState(() {}),
            indicator: BoxDecoration(color: AppColors.blue,
                borderRadius: BorderRadius.circular(9)),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            tabs: const [Tab(text: 'Sign In'), Tab(text: 'Join Now')],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: _tabController.index == 0 ? _loginTab() : _registerTab(),
        ),
      ]),
    );
  }

  Widget _loginTab() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Welcome back 👋', style: TextStyle(fontSize: 20,
          fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      const SizedBox(height: 4),
      const Text('Sign in to your AyurVanta Jobs profile',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      const SizedBox(height: 24),
      _lbl('Email / Phone'), const SizedBox(height: 6),
      _field(_loginEmailCtrl, 'doctor@hospital.com',
          Icons.person_outline_rounded, keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 14),
      _lbl('Password'), const SizedBox(height: 6),
      _field(_loginPassCtrl, '••••••••', Icons.lock_outline_rounded,
          obscure: !_passVisible,
          suffix: GestureDetector(
            onTap: () => setState(() => _passVisible = !_passVisible),
            child: Icon(_passVisible ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
                color: AppColors.textHint, size: 18))),
      Align(alignment: Alignment.centerRight,
          child: TextButton(onPressed: () {},
              child: const Text('Forgot password?',
                  style: TextStyle(fontSize: 12, color: AppColors.blue,
                      fontWeight: FontWeight.w600)))),
      _btn('Sign In', _isLoading, _login),
      const SizedBox(height: 16),
      _divider(), const SizedBox(height: 16),
      _social('Continue with Google', '🔵',
          () => _socialLogin('Medical Professional', 'user@gmail.com')),
      const SizedBox(height: 8),
      _social('Continue with Ayur ID', '⚕️',
          () => _socialLogin('Arjun Sharma', 'arjun@ayurvanta.in')),
    ]),
  );

  Widget _registerTab() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Create your profile ✨', style: TextStyle(fontSize: 20,
          fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      const SizedBox(height: 4),
      const Text('Join 2 lakh+ healthcare professionals on AyurVanta Jobs',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      const SizedBox(height: 20),
      _lbl('Full Name *'), const SizedBox(height: 6),
      _field(_regNameCtrl, 'Dr. Priya Sharma', Icons.badge_outlined),
      const SizedBox(height: 14),
      _lbl('Email Address *'), const SizedBox(height: 6),
      _field(_regEmailCtrl, 'priya@hospital.com', Icons.email_outlined,
          keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 14),
      _lbl('Phone Number *'), const SizedBox(height: 6),
      _field(_regPhoneCtrl, '+91 98765 43210', Icons.phone_outlined,
          keyboardType: TextInputType.phone),
      const SizedBox(height: 14),
      _lbl('Password *'), const SizedBox(height: 6),
      _field(_regPassCtrl, 'Min 8 characters', Icons.lock_outline_rounded,
          obscure: !_passVisible,
          suffix: GestureDetector(
            onTap: () => setState(() => _passVisible = !_passVisible),
            child: Icon(_passVisible ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
                color: AppColors.textHint, size: 18))),
      const SizedBox(height: 14),
      _lbl('Qualification'), const SizedBox(height: 6),
      _field(_regQualCtrl, 'MBBS, MD, BSc Nursing, B.Pharm…',
          Icons.school_outlined),
      const SizedBox(height: 14),
      _lbl('I am a *'), const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8,
          children: _roles.map((r) {
            final sel = r == _selectedRole;
            return GestureDetector(
              onTap: () => setState(() => _selectedRole = r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: sel ? AppColors.blue : const Color(0xFFF4F7FB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: sel ? AppColors.blue : const Color(0xFFE3EAF2),
                    width: sel ? 1.5 : 0.5)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(_roleEmojis[r] ?? '⚕️',
                      style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 5),
                  Text(r, style: TextStyle(fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: sel ? Colors.white : AppColors.navyLight)),
                ]),
              ),
            );
          }).toList()),
      const SizedBox(height: 14),
      _lbl('Experience Level *'), const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFFF4F7FB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedExp, isExpanded: true,
            items: _expLevels.map((e) => DropdownMenuItem(value: e,
                child: Text(e, style: const TextStyle(fontSize: 13,
                    color: AppColors.textPrimary)))).toList(),
            onChanged: (v) => setState(() => _selectedExp = v!),
          ),
        ),
      ),
      const SizedBox(height: 16),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Checkbox(value: _agreeTerms,
            onChanged: (v) => setState(() => _agreeTerms = v ?? false),
            activeColor: AppColors.blue,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
        Expanded(child: GestureDetector(
          onTap: () => setState(() => _agreeTerms = !_agreeTerms),
          child: const Padding(
            padding: EdgeInsets.only(top: 11),
            child: Text('I agree to AyurVanta Jobs Terms of Service and Privacy Policy',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary,
                    height: 1.4))))),
      ]),
      const SizedBox(height: 16),
      _btn('Create Profile & Find Jobs', _isLoading, _register),
      const SizedBox(height: 16),
      _divider(), const SizedBox(height: 16),
      _social('Sign up with Google', '🔵',
          () => _socialLogin('Medical Professional', 'user@gmail.com')),
    ]),
  );

  Widget _lbl(String t) => Text(t, style: const TextStyle(
      fontSize: 12, fontWeight: FontWeight.w700,
      color: AppColors.textSecondary));

  Widget _field(TextEditingController c, String hint, IconData icon,
      {bool obscure = false, TextInputType? keyboardType, Widget? suffix}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF4F7FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5)),
      child: TextField(
        controller: c, obscureText: obscure, keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
          prefixIcon: Icon(icon, color: AppColors.textHint, size: 18),
          suffixIcon: suffix != null
              ? Padding(padding: const EdgeInsets.only(right: 12), child: suffix)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14)),
      ),
    );
  }

  Widget _btn(String label, bool loading, VoidCallback onTap) => SizedBox(
    width: double.infinity, height: 52,
    child: ElevatedButton(
      onPressed: loading ? null : onTap,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue,
          foregroundColor: Colors.white, elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      child: loading
          ? const SizedBox(width: 22, height: 22,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
          : Text(label, style: const TextStyle(fontSize: 15,
              fontWeight: FontWeight.w700)),
    ),
  );

  Widget _divider() => Row(children: [
    Expanded(child: Container(height: 0.5, color: const Color(0xFFE3EAF2))),
    const Padding(padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text('or', style: TextStyle(color: AppColors.textHint, fontSize: 12))),
    Expanded(child: Container(height: 0.5, color: const Color(0xFFE3EAF2))),
  ]);

  Widget _social(String label, String emoji, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(color: const Color(0xFFF4F7FB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 13,
                fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ]),
        ),
      );
}

class _BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(0.03)
        ..style = PaintingStyle.stroke..strokeWidth = 1;
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.3),
          50.0 + i * 40, p);
    }
  }
  @override bool shouldRepaint(_) => false;
}