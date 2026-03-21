import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/app_module.dart';
import '../../../core/services/auth_preference_service.dart';
import 'admin/admin_dashboard_screen.dart';
import 'doctor/doctor_dashboard_screen.dart';
import 'receptionist/receptionist_dashboard_screen.dart';
import 'reportist/reportist_dashboard_screen.dart';

class HospitalLoginScreen extends StatefulWidget {
  final HospitalRoleInfo role;
  const HospitalLoginScreen({super.key, required this.role});

  @override
  State<HospitalLoginScreen> createState() => _HospitalLoginScreenState();
}

class _HospitalLoginScreenState extends State<HospitalLoginScreen> {
  final _empIdCtrl   = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _passVisible = false;
  bool _isLoading   = false;

  bool get _isAdmin =>
      widget.role.role == HospitalRole.admin;

  @override
  void dispose() {
    _empIdCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_empIdCtrl.text.trim().isEmpty) {
      _showSnack('Please enter your Employee ID');
      return;
    }
    if (_passwordCtrl.text.isEmpty) {
      _showSnack('Please enter your password');
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    await AuthPreferenceService.saveLoginState(
      name: '${widget.role.name} ${_empIdCtrl.text.trim()}',
      email: '${_empIdCtrl.text.trim()}@hospital.ayurvanta.in',
      module: 'Hospital-${widget.role.name}',
    );

    setState(() => _isLoading = false);

    _showSnack(
        'Welcome! Logged in as ${widget.role.name}');

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) {
          switch (widget.role.role) {
            case HospitalRole.admin:
              return const AdminDashboardScreen();
            case HospitalRole.doctor:
              return const DoctorDashboardScreen();
            case HospitalRole.receptionist:
              return const ReceptionistDashboardScreen();
            case HospitalRole.reportist:
              return const ReportistDashboardScreen();
          }
        }),
        (route) => false,
      );
    }
  }

  void _forgotPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ForgotPasswordSheet(role: widget.role),
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
      backgroundColor: const Color(0xFF060D14),
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role badge
                  FadeInDown(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: widget.role.bgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: widget.role.borderColor, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget.role.emoji,
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Text(widget.role.name,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: widget.role.textColor)),
                          const SizedBox(width: 4),
                          Text('Portal',
                            style: TextStyle(
                                fontSize: 13,
                                color: widget.role.textColor
                                    .withOpacity(0.6))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Welcome text
                  FadeInLeft(
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      'Sign in to continue',
                      style: const TextStyle(color: Colors.white,
                          fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 180),
                    child: Text(
                      'Use your hospital-issued Employee ID\nto access the ${widget.role.name} dashboard.',
                      style: const TextStyle(color: Colors.white38,
                          fontSize: 13, height: 1.55),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Employee ID field
                  FadeInUp(
                    delay: const Duration(milliseconds: 250),
                    child: _buildFieldLabel('EMPLOYEE ID'),
                  ),
                  const SizedBox(height: 8),
                  FadeInUp(
                    delay: const Duration(milliseconds: 280),
                    child: _buildTextField(
                      controller: _empIdCtrl,
                      hint: 'e.g. EMP-2024-001',
                      icon: Icons.badge_outlined,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  FadeInUp(
                    delay: const Duration(milliseconds: 320),
                    child: _buildFieldLabel('PASSWORD'),
                  ),
                  const SizedBox(height: 8),
                  FadeInUp(
                    delay: const Duration(milliseconds: 350),
                    child: _buildTextField(
                      controller: _passwordCtrl,
                      hint: 'Enter your password',
                      icon: Icons.lock_outline_rounded,
                      obscure: !_passVisible,
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                            () => _passVisible = !_passVisible),
                        child: Icon(
                          _passVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white38, size: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Forgot password — Admin only
                  if (_isAdmin)
                    FadeInUp(
                      delay: const Duration(milliseconds: 380),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: _forgotPassword,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: widget.role.bgColor
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.help_outline_rounded,
                                    size: 13,
                                    color: widget.role.textColor
                                        .withOpacity(0.8)),
                                const SizedBox(width: 5),
                                Text('Forgot Password?',
                                  style: TextStyle(
                                    color: widget.role.textColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 36),

                  // Login button
                  FadeInUp(
                    delay: const Duration(milliseconds: 420),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.role.iconBg,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          disabledBackgroundColor:
                              widget.role.iconBg.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Login as ${widget.role.name}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 18),
                                ],
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Security notice
                  FadeInUp(
                    delay: const Duration(milliseconds: 480),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_outlined,
                              color: Colors.white24, size: 15),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _isAdmin
                                  ? 'Admin accounts are monitored. '
                                    'All actions are logged with timestamp & IP.'
                                  : 'Your credentials are encrypted. '
                                    'Contact your Admin if you face any issues.',
                              style: const TextStyle(
                                  color: Colors.white24,
                                  fontSize: 11,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Top Bar ──────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: const Color(0xFF0A1520),
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
                color: Colors.white.withOpacity(0.08),
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
              color: widget.role.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(widget.role.emoji,
                  style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.role.name} Login',
                  style: const TextStyle(color: Colors.white,
                      fontSize: 15, fontWeight: FontWeight.w700)),
                const Text('AyurVanta Hospital Portal',
                  style: TextStyle(color: Colors.white38,
                      fontSize: 11)),
              ],
            ),
          ),
          // Role indicator chip
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: widget.role.bgColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: widget.role.borderColor.withOpacity(0.4),
                  width: 0.5),
            ),
            child: Text(widget.role.name.toUpperCase(),
              style: TextStyle(
                color: widget.role.textColor,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              )),
          ),
        ],
      ),
    );
  }

  // ── Field Label ───────────────────────────────────────
  Widget _buildFieldLabel(String label) {
    return Text(label,
      style: const TextStyle(
          color: Colors.white38,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8));
  }

  // ── Text Field ────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: Colors.white.withOpacity(0.1), width: 0.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(
            color: Colors.white, fontSize: 14,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              color: Colors.white24, fontSize: 13),
          prefixIcon: Icon(icon, color: Colors.white38, size: 18),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

// ── Forgot Password Sheet (Admin only) ───────────────────
class _ForgotPasswordSheet extends StatefulWidget {
  final HospitalRoleInfo role;
  const _ForgotPasswordSheet({required this.role});

  @override
  State<_ForgotPasswordSheet> createState() =>
      _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState
    extends State<_ForgotPasswordSheet> {
  final _empIdCtrl = TextEditingController();
  bool _submitted  = false;
  bool _isLoading  = false;

  Future<void> _submit() async {
    if (_empIdCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please enter your Employee ID'),
        backgroundColor: AppColors.navyMid,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() { _isLoading = false; _submitted = true; });
  }

  @override
  void dispose() {
    _empIdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0E1A26),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          if (!_submitted) ...[
            // Header
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: widget.role.iconBg.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(Icons.lock_reset_rounded,
                      color: widget.role.textColor, size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reset Password',
                      style: TextStyle(color: Colors.white,
                          fontSize: 17, fontWeight: FontWeight.w800)),
                    Text('Admin verification required',
                      style: TextStyle(color: Colors.white38,
                          fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text('EMPLOYEE ID',
              style: TextStyle(color: Colors.white38,
                  fontSize: 11, fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: Colors.white.withOpacity(0.1), width: 0.5),
              ),
              child: TextField(
                controller: _empIdCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Enter your Employee ID',
                  hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                  prefixIcon: Icon(Icons.badge_outlined,
                      color: Colors.white38, size: 18),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: Colors.white24, size: 14),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'A reset link will be sent to the '
                      'Admin\'s registered hospital email address.',
                      style: TextStyle(color: Colors.white30,
                          fontSize: 11, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.role.iconBg,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5))
                    : const Text('Send Reset Link',
                        style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w700)),
              ),
            ),
          ] else ...[
            // Success state
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 72, height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF3DE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mark_email_read_rounded,
                        color: Color(0xFF1D9E75), size: 36),
                  ),
                  const SizedBox(height: 18),
                  const Text('Reset Link Sent!',
                    style: TextStyle(color: Colors.white,
                        fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  const Text(
                    'Check your hospital-registered email.\n'
                    'The link expires in 30 minutes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38,
                        fontSize: 13, height: 1.5)),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity, height: 50,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                            color: Colors.white24, width: 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Back to Login',
                          style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
