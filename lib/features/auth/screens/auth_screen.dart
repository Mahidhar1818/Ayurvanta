import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/app_module.dart';
import '../../../core/services/auth_preference_service.dart';
import '../../home/screens/home_screen.dart';
import '../../onboarding/screens/module_selector_screen.dart';

class AuthScreen extends StatefulWidget {
  final AppModuleInfo module;
  const AuthScreen({super.key, required this.module});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _loginEmail = TextEditingController();
  final _loginPass  = TextEditingController();
  final _regName    = TextEditingController();
  final _regEmail   = TextEditingController();
  final _regPhone   = TextEditingController();
  final _regPass    = TextEditingController();
  bool _passVis = false, _loading = false, _agreed = false;
  String _selectedRole = 'Doctor';
  String _selectedExp  = 'Fresher (0–1 yr)';

  static const _roles = ['Doctor','Nurse','Pharmacist','Lab Technician',
    'Physiotherapist','Radiologist','Hospital Admin','Dentist',
    'Medical Coder','Paramedic','Other'];
  static const _exps  = ['Fresher (0–1 yr)','1–3 years',
    '3–5 years','5–10 years','10+ years'];
  static const _roleEmojis = {
    'Doctor':'👨⚕️','Nurse':'👩⚕️','Pharmacist':'💊',
    'Lab Technician':'🔬','Physiotherapist':'🏋️',
    'Radiologist':'📡','Hospital Admin':'🏥','Dentist':'🦷',
    'Medical Coder':'💻','Paramedic':'🚑','Other':'⚕️',
  };

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _loginEmail.dispose(); _loginPass.dispose();
    _regName.dispose(); _regEmail.dispose();
    _regPhone.dispose(); _regPass.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_loginEmail.text.trim().isEmpty || _loginPass.text.isEmpty) {
      _snack('Please enter email and password'); return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    await AuthPreferenceService.saveLoginState(
      name: _loginEmail.text.split('@').first,
      email: _loginEmail.text,
      module: widget.module.name,
    );
    setState(() => _loading = false);
    _go();
  }

  Future<void> _register() async {
    if (_regName.text.trim().isEmpty || _regEmail.text.trim().isEmpty ||
        _regPass.text.isEmpty) {
      _snack('Please fill required fields'); return;
    }
    if (!_agreed) { _snack('Please agree to Terms'); return; }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    await AuthPreferenceService.saveLoginState(
      name: _regName.text.trim(),
      email: _regEmail.text.trim(),
      module: widget.module.name,
    );
    setState(() => _loading = false);
    _go();
  }

  Future<void> _socialLogin(String name, String email) async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    await AuthPreferenceService.saveLoginState(
        name: name, email: email, module: widget.module.name);
    setState(() => _loading = false);
    _go();
  }

  void _go() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false);
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(m), backgroundColor: AppColors.navyMid,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12))));

  @override
  Widget build(BuildContext context) {
    final mod = widget.module;
    return Scaffold(
      body: Stack(children: [
        // Gradient background
        Container(decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF0B1A2C), Color(0xFF1A2E44),
                     Color(0xFF0B1A2C)],
          ))),
        // Decorative circles
        Positioned(top: -80, right: -60,
            child: Container(width: 280, height: 280,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.teal.withOpacity(0.06)))),
        Positioned(bottom: -100, left: -80,
            child: Container(width: 320, height: 320,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.blue.withOpacity(0.06)))),
        SafeArea(child: Column(children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(width: 38, height: 38,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.12))),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 16))),
              const SizedBox(width: 12),
              // Module badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.12))),
                child: Row(children: [
                  Text(mod.emoji,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(mod.name, style: const TextStyle(
                      color: Colors.white, fontSize: 13,
                      fontWeight: FontWeight.w700)),
                ])),
            ])),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              FadeInLeft(child: Row(children: [
                Container(width: 44, height: 44,
                    decoration: BoxDecoration(
                        color: AppColors.teal,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(
                        Icons.health_and_safety_rounded,
                        color: Colors.white, size: 24)),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text('AyurVanta',
                      style: TextStyle(color: Colors.white,
                          fontSize: 20, fontWeight: FontWeight.w800)),
                  Text('${mod.name} Portal',
                      style: const TextStyle(
                          color: AppColors.textHint, fontSize: 12)),
                ]),
              ])),
            ])),
          // Card
          Expanded(child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28))),
            child: Column(children: [
              const SizedBox(height: 8),
              Container(width: 40, height: 4,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE3EAF2),
                      borderRadius: BorderRadius.circular(2))),
              // Tabs
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FB),
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.all(4),
                  child: TabBar(
                    controller: _tab,
                    onTap: (_) => setState(() {}),
                    indicator: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(
                            color: AppColors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2))]),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700),
                    overlayColor: WidgetStateProperty.all(
                        Colors.transparent),
                    tabs: const [
                      Tab(text: 'Sign In'),
                      Tab(text: 'Create Account'),
                    ]))),
              Expanded(child: TabBarView(
                controller: _tab,
                physics: const NeverScrollableScrollPhysics(),
                children: [_loginTab(), _registerTab()])),
            ]))),
        ])),
      ]));
  }

  Widget _loginTab() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      const Text('Welcome back 👋',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
              color: AppColors.textPrimary)),
      const SizedBox(height: 4),
      Text('Sign in to ${widget.module.name} portal',
          style: const TextStyle(fontSize: 13,
              color: AppColors.textSecondary)),
      const SizedBox(height: 24),
      _lbl('Email / Phone'),
      const SizedBox(height: 6),
      _field(_loginEmail, 'doctor@hospital.com',
          Icons.person_outline_rounded,
          keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 16),
      _lbl('Password'),
      const SizedBox(height: 6),
      _field(_loginPass, '••••••••',
          Icons.lock_outline_rounded, obscure: !_passVis,
          suffix: IconButton(
            icon: Icon(_passVis
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
                color: AppColors.textHint, size: 18),
            onPressed: () => setState(() => _passVis = !_passVis))),
      Align(alignment: Alignment.centerRight,
          child: TextButton(onPressed: () {},
              child: const Text('Forgot password?',
                  style: TextStyle(color: AppColors.blue,
                      fontSize: 12, fontWeight: FontWeight.w600)))),
      _primaryBtn('Sign In', _loading, _login),
      const SizedBox(height: 20),
      _divider(),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: _socialBtn('Google', '🔵',
            () => _socialLogin('Medical Pro', 'user@gmail.com'))),
        const SizedBox(width: 10),
        Expanded(child: _socialBtn('Ayur ID', '⚕️',
            () => _socialLogin('Arjun Sharma',
                'arjun@ayurvanta.in'))),
        const SizedBox(width: 10),
        Expanded(child: _socialBtn('Apple', '🍎', () {})),
      ]),
    ]));

  Widget _registerTab() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      const Text('Join AyurVanta ✨',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
              color: AppColors.textPrimary)),
      const SizedBox(height: 4),
      const Text('Create your professional profile',
          style: TextStyle(fontSize: 13,
              color: AppColors.textSecondary)),
      const SizedBox(height: 20),
      _lbl('Full Name *'),
      const SizedBox(height: 6),
      _field(_regName, 'Dr. Priya Sharma',
          Icons.badge_outlined),
      const SizedBox(height: 14),
      _lbl('Email Address *'),
      const SizedBox(height: 6),
      _field(_regEmail, 'priya@hospital.com',
          Icons.email_outlined,
          keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 14),
      _lbl('Phone Number *'),
      const SizedBox(height: 6),
      _field(_regPhone, '+91 98765 43210',
          Icons.phone_outlined,
          keyboardType: TextInputType.phone),
      const SizedBox(height: 14),
      _lbl('Password *'),
      const SizedBox(height: 6),
      _field(_regPass, 'Min 8 characters',
          Icons.lock_outline_rounded, obscure: !_passVis,
          suffix: IconButton(
            icon: Icon(_passVis
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
                color: AppColors.textHint, size: 18),
            onPressed: () =>
                setState(() => _passVis = !_passVis))),
      const SizedBox(height: 16),
      _lbl('I am a *'),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8,
          children: _roles.map((r) {
            final sel = r == _selectedRole;
            return GestureDetector(
              onTap: () => setState(() => _selectedRole = r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                    color: sel
                        ? AppColors.blue
                        : const Color(0xFFF4F7FB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: sel ? AppColors.blue
                            : const Color(0xFFE3EAF2),
                        width: sel ? 1.5 : 0.5)),
                child: Row(mainAxisSize: MainAxisSize.min,
                    children: [
                  Text(_roleEmojis[r] ?? '⚕️',
                      style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 5),
                  Text(r, style: TextStyle(fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: sel ? Colors.white
                          : AppColors.navyLight)),
                ])));
          }).toList()),
      const SizedBox(height: 14),
      _lbl('Experience *'),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 2),
        decoration: BoxDecoration(
            color: const Color(0xFFF4F7FB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFFE3EAF2), width: 0.5)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedExp, isExpanded: true,
            items: _exps.map((e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(
                  fontSize: 13, color: AppColors.textPrimary)),
            )).toList(),
            onChanged: (v) => setState(() => _selectedExp = v!),
          ))),
      const SizedBox(height: 16),
      Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Checkbox(value: _agreed,
            onChanged: (v) =>
                setState(() => _agreed = v ?? false),
            activeColor: AppColors.blue,
            materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap),
        Expanded(child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
              'I agree to AyurVanta Terms of Service '
              'and Privacy Policy',
              style: const TextStyle(fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4)))),
      ]),
      const SizedBox(height: 16),
      _primaryBtn('Create Account & Continue',
          _loading, _register),
    ]));

  Widget _lbl(String t) => Text(t,
      style: const TextStyle(fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary));

  Widget _field(TextEditingController c, String hint,
      IconData icon,
      {bool obscure = false,
      TextInputType? keyboardType,
      Widget? suffix}) =>
      Container(
        decoration: BoxDecoration(
            color: const Color(0xFFF4F7FB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFFE3EAF2), width: 0.5)),
        child: TextField(
          controller: c,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(
              fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  color: AppColors.textHint, fontSize: 13),
              prefixIcon: Icon(icon,
                  color: AppColors.textHint, size: 18),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 14))));

  Widget _primaryBtn(String l, bool loading, VoidCallback t) =>
      SizedBox(
        width: double.infinity, height: 52,
        child: ElevatedButton(
          onPressed: loading ? null : t,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: AppColors.blue.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14))),
          child: loading
              ? const SizedBox(width: 22, height: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5))
              : Text(l, style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700))));

  Widget _divider() => Row(children: [
    Expanded(child: Container(height: 0.5,
        color: const Color(0xFFE3EAF2))),
    const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text('or continue with',
            style: TextStyle(
                color: AppColors.textHint, fontSize: 12))),
    Expanded(child: Container(height: 0.5,
        color: const Color(0xFFE3EAF2))),
  ]);

  Widget _socialBtn(String l, String e, VoidCallback t) =>
      GestureDetector(
        onTap: t,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
              color: const Color(0xFFF4F7FB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFFE3EAF2), width: 0.5)),
          child: Column(children: [
            Text(e, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 3),
            Text(l, style: const TextStyle(fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary)),
          ])));
}
