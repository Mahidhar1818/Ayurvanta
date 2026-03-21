import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/app_module.dart';
import '../../../core/services/auth_preference_service.dart';
import '../../home/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  final AppModuleInfo module;
  const AuthScreen({super.key, required this.module});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Login fields
  final _loginEmailCtrl  = TextEditingController();
  final _loginPassCtrl   = TextEditingController();

  // Sign up fields
  final _signupNameCtrl  = TextEditingController();
  final _signupEmailCtrl = TextEditingController();
  final _signupPassCtrl  = TextEditingController();
  final _signupConfCtrl  = TextEditingController();
  final _phoneCtrl       = TextEditingController();

  // OTP
  final _otpCtrl = TextEditingController();
  bool _showOtp      = false;
  bool _isLoading    = false;
  bool _passVisible  = false;
  String _otp        = '';

  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailCtrl.dispose();  _loginPassCtrl.dispose();
    _signupNameCtrl.dispose();  _signupEmailCtrl.dispose();
    _signupPassCtrl.dispose();  _signupConfCtrl.dispose();
    _phoneCtrl.dispose();       _otpCtrl.dispose();
    super.dispose();
  }

  // ── Google Sign In ───────────────────────────────────
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final account = await _googleSignIn.signIn();
      if (account != null && mounted) {
        await AuthPreferenceService.saveLoginState(
          name: account.displayName ?? 'User',
          email: account.email,
          module: widget.module.name,
        );
        _navigateToHome();
      }
    } catch (e) {
      _showSnack('Google Sign In failed. Try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Email Login ──────────────────────────────────────
  Future<void> _loginWithEmail() async {
    if (_loginEmailCtrl.text.isEmpty || _loginPassCtrl.text.isEmpty) {
      _showSnack('Please fill in all fields');
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    await AuthPreferenceService.saveLoginState(
      name: _loginEmailCtrl.text.split('@').first,
      email: _loginEmailCtrl.text,
      module: widget.module.name,
    );
    setState(() => _isLoading = false);
    _navigateToHome();
  }

  // ── Email Sign Up ────────────────────────────────────
  Future<void> _signUpWithEmail() async {
    if (_signupNameCtrl.text.isEmpty ||
        _signupEmailCtrl.text.isEmpty ||
        _signupPassCtrl.text.isEmpty) {
      _showSnack('Please fill in all fields');
      return;
    }
    if (_signupPassCtrl.text != _signupConfCtrl.text) {
      _showSnack('Passwords do not match');
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    await AuthPreferenceService.saveLoginState(
      name: _signupNameCtrl.text,
      email: _signupEmailCtrl.text,
      module: widget.module.name,
    );
    setState(() => _isLoading = false);
    _navigateToHome();
  }

  // ── Aadhar OTP ───────────────────────────────────────
  Future<void> _sendAadharOtp() async {
    if (_phoneCtrl.text.length != 12) {
      _showSnack('Enter valid 12-digit Aadhar number');
      return;
    }
    setState(() { _isLoading = true; });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() { _isLoading = false; _showOtp = true; });
    _showSnack('OTP sent to your Aadhar-linked mobile');
  }

  Future<void> _verifyAadharOtp() async {
    if (_otp.length != 6) {
      _showSnack('Enter the 6-digit OTP');
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    await AuthPreferenceService.saveLoginState(
      name: 'AyurVanta User',
      email: 'aadhar@ayurvanta.in',
      module: widget.module.name,
    );
    setState(() => _isLoading = false);
    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (_) => false,
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.navyMid,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0818),
      body: Column(
        children: [
          _TopBar(module: widget.module),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    child: Text(
                      _tabController.index == 0
                          ? 'Welcome back 👋'
                          : 'Create account ✨',
                      style: const TextStyle(color: Colors.white,
                          fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FadeInDown(
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      'Login or create your account to access\n'
                      'the \${widget.module.name} module',
                      style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 13, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login / Sign Up tabs
                  FadeInUp(
                    delay: const Duration(milliseconds: 150),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: TabBar(
                        controller: _tabController,
                        onTap: (_) => setState(() {}),
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: AppColors.blue,
                        unselectedLabelColor: Colors.white54,
                        labelStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                        overlayColor: WidgetStateProperty.all(
                            Colors.transparent),
                        tabs: const [
                          Tab(text: 'Login'),
                          Tab(text: 'Sign Up'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tab content
                  SizedBox(
                    height: 500, // Fixed height for TabBarView inside scroll
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _LoginTab(
                          emailCtrl: _loginEmailCtrl,
                          passCtrl: _loginPassCtrl,
                          passVisible: _passVisible,
                          isLoading: _isLoading,
                          onTogglePass: () => setState(
                              () => _passVisible = !_passVisible),
                          onLogin: _loginWithEmail,
                          onGoogle: _signInWithGoogle,
                          onAadhar: () => _tabController
                              .animateTo(1),
                          module: widget.module,
                        ),
                        _SignUpTab(
                          nameCtrl: _signupNameCtrl,
                          emailCtrl: _signupEmailCtrl,
                          passCtrl: _signupPassCtrl,
                          confCtrl: _signupConfCtrl,
                          phoneCtrl: _phoneCtrl,
                          passVisible: _passVisible,
                          isLoading: _isLoading,
                          showOtp: _showOtp,
                          otpCtrl: _otpCtrl,
                          otp: _otp,
                          onOtpChanged: (v) =>
                              setState(() => _otp = v),
                          onTogglePass: () => setState(
                              () => _passVisible = !_passVisible),
                          onSignUp: _signUpWithEmail,
                          onGoogle: _signInWithGoogle,
                          onSendOtp: _sendAadharOtp,
                          onVerifyOtp: _verifyAadharOtp,
                          module: widget.module,
                        ),
                      ],
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
  final AppModuleInfo module;
  const _TopBar({required this.module});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A0F2E),
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
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: module.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(module.emoji,
                style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          Text('\${module.name} App',
            style: const TextStyle(color: Colors.white,
                fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ── Login Tab ────────────────────────────────────────────
class _LoginTab extends StatelessWidget {
  final TextEditingController emailCtrl, passCtrl;
  final bool passVisible, isLoading;
  final VoidCallback onTogglePass, onLogin, onGoogle, onAadhar;
  final AppModuleInfo module;

  const _LoginTab({
    required this.emailCtrl, required this.passCtrl,
    required this.passVisible, required this.isLoading,
    required this.onTogglePass, required this.onLogin,
    required this.onGoogle, required this.onAadhar,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DarkLabel('EMAIL / PHONE'),
        _DarkField(
          controller: emailCtrl,
          hint: 'Enter your email or phone',
          icon: Icons.person_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _DarkLabel('PASSWORD'),
        _DarkField(
          controller: passCtrl,
          hint: 'Enter your password',
          icon: Icons.lock_outline_rounded,
          obscure: !passVisible,
          suffixIcon: GestureDetector(
            onTap: onTogglePass,
            child: Icon(
              passVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textHint, size: 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: const Text('Forgot password?',
              style: TextStyle(color: AppColors.textHint,
                  fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 24),
        _PrimaryButton(
          label: 'Login to \${module.name} App',
          isLoading: isLoading,
          onTap: onLogin,
        ),
        const SizedBox(height: 20),
        _Divider(),
        const SizedBox(height: 16),
        _SocialRow(onGoogle: onGoogle, onAadhar: onAadhar),
      ],
    );
  }
}

// ── Sign Up Tab ──────────────────────────────────────────
class _SignUpTab extends StatelessWidget {
  final TextEditingController nameCtrl, emailCtrl,
      passCtrl, confCtrl, phoneCtrl, otpCtrl;
  final bool passVisible, isLoading, showOtp;
  final String otp;
  final ValueChanged<String> onOtpChanged;
  final VoidCallback onTogglePass, onSignUp,
      onGoogle, onSendOtp, onVerifyOtp;
  final AppModuleInfo module;

  const _SignUpTab({
    required this.nameCtrl, required this.emailCtrl,
    required this.passCtrl, required this.confCtrl,
    required this.phoneCtrl, required this.otpCtrl,
    required this.passVisible, required this.isLoading,
    required this.showOtp, required this.otp,
    required this.onOtpChanged, required this.onTogglePass,
    required this.onSignUp, required this.onGoogle,
    required this.onSendOtp, required this.onVerifyOtp,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DarkLabel('FULL NAME'),
        _DarkField(
          controller: nameCtrl,
          hint: 'Enter your full name',
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: 14),
        _DarkLabel('EMAIL ADDRESS'),
        _DarkField(
          controller: emailCtrl,
          hint: 'Enter your email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _DarkLabel('PASSWORD'),
        _DarkField(
          controller: passCtrl,
          hint: 'Create a password',
          icon: Icons.lock_outline_rounded,
          obscure: !passVisible,
          suffixIcon: GestureDetector(
            onTap: onTogglePass,
            child: Icon(
              passVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textHint, size: 18,
            ),
          ),
        ),
        const SizedBox(height: 14),
        _DarkLabel('CONFIRM PASSWORD'),
        _DarkField(
          controller: confCtrl,
          hint: 'Re-enter password',
          icon: Icons.lock_outline_rounded,
          obscure: true,
        ),
        const SizedBox(height: 24),
        _PrimaryButton(
          label: 'Create \${module.name} Account',
          isLoading: isLoading,
          onTap: onSignUp,
        ),
        const SizedBox(height: 20),
        _Divider(),
        const SizedBox(height: 16),
        _SocialRow(onGoogle: onGoogle, onAadhar: onSendOtp),
        if (showOtp) ...[
          const SizedBox(height: 20),
          _DarkLabel('ENTER OTP'),
          PinCodeTextField(
            appContext: context,
            length: 6,
            controller: otpCtrl,
            onChanged: onOtpChanged,
            keyboardType: TextInputType.number,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(12),
              fieldHeight: 50,
              fieldWidth: 42,
              activeFillColor:
                  Colors.white.withOpacity(0.1),
              inactiveFillColor:
                  Colors.white.withOpacity(0.05),
              selectedFillColor:
                  AppColors.teal.withOpacity(0.2),
              activeColor: AppColors.teal,
              inactiveColor:
                  Colors.white.withOpacity(0.15),
              selectedColor: AppColors.teal,
            ),
            enableActiveFill: true,
            textStyle: const TextStyle(
                color: Colors.white, fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          _PrimaryButton(
            label: 'Verify OTP & Register',
            isLoading: isLoading,
            onTap: onVerifyOtp,
            color: AppColors.teal,
          ),
        ],
      ],
    );
  }
}

// ── Shared Widgets ───────────────────────────────────────
class _DarkLabel extends StatelessWidget {
  final String text;
  const _DarkLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text,
      style: const TextStyle(color: AppColors.textHint,
          fontSize: 11, fontWeight: FontWeight.w700,
          letterSpacing: 0.8)),
  );
}

class _DarkField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const _DarkField({
    required this.controller, required this.hint,
    required this.icon, this.obscure = false,
    this.keyboardType, this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: Colors.white.withOpacity(0.12), width: 0.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              color: Colors.white24, fontSize: 13),
          prefixIcon: Icon(icon,
              color: AppColors.textHint, size: 18),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 14),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;
  final Color color;

  const _PrimaryButton({
    required this.label, required this.isLoading,
    required this.onTap, this.color = AppColors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading
            ? const SizedBox(width: 22, height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5))
            : Text(label,
                style: const TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(
            height: 0.5,
            color: Colors.white.withOpacity(0.1))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('or continue with',
            style: TextStyle(color: Colors.white30,
                fontSize: 12)),
        ),
        Expanded(child: Container(
            height: 0.5,
            color: Colors.white.withOpacity(0.1))),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  final VoidCallback onGoogle, onAadhar;
  const _SocialRow({required this.onGoogle,
      required this.onAadhar});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SocialBtn(
          label: 'Google',
          icon: '🔵',
          onTap: onGoogle,
        )),
        const SizedBox(width: 10),
        Expanded(child: _SocialBtn(
          label: 'Aadhar OTP',
          icon: '📱',
          onTap: onAadhar,
        )),
        const SizedBox(width: 10),
        Expanded(child: _SocialBtn(
          label: 'Apple',
          icon: '🍎',
          onTap: () {},
        )),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final String label, icon;
  final VoidCallback onTap;
  const _SocialBtn({required this.label,
      required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: Colors.white.withOpacity(0.12), width: 0.5),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(label,
              style: const TextStyle(color: Colors.white60,
                  fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
