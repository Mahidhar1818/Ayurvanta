import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _aadharController = TextEditingController();
  final _otpController    = TextEditingController();

  bool _otpSent    = false;
  bool _isLoading  = false;
  String _otp      = '';

  late AnimationController _bgAnimController;

  @override
  void initState() {
    super.initState();
    _bgAnimController = AnimationController(
        vsync: this, duration: const Duration(seconds: 10))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgAnimController.dispose();
    _aadharController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_aadharController.text.length != 12) {
      _showSnack('Enter a valid 12-digit Aadhar number');
      return;
    }
    setState(() { _isLoading = true; });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() { _isLoading = false; _otpSent = true; });
      _showSnack('OTP sent to your Aadhar-linked mobile');
    });
  }

  void _verifyOtp() {
    if (_otp.length != 6) {
      _showSnack('Enter the 6-digit OTP');
      return;
    }
    setState(() { _isLoading = true; });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() { _isLoading = false; });
      _showSnack('Login successful! Welcome to AyurVanta');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 8,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDark,
      body: Stack(
        children: [
          // Dynamic Abstract Background
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: AnimatedBuilder(
              animation: _bgAnimController,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: -100 + (30 * _bgAnimController.value),
                      left: -50,
                      child: _buildBlurCircle(const Color(0xFF1D9E75), 300),
                    ),
                    Positioned(
                      bottom: -50 - (40 * _bgAnimController.value),
                      right: -100 + (20 * _bgAnimController.value),
                      child: _buildBlurCircle(const Color(0xFF185FA5), 350),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.4,
                      left: 200 - (50 * _bgAnimController.value),
                      child: _buildBlurCircle(const Color(0xFFE8243A).withOpacity(0.5), 200),
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Dark overlay tint
          Container(color: Colors.black.withOpacity(0.25)),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  // Enhanced Logo row
                  FadeInDown(
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.teal.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'AyurVanta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontFamily: 'SF Pro Display',
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Glassmorphism Login Card
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 30,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Heading inside card
                          const Text(
                            'Welcome back',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _otpSent
                                ? 'We sent a secure code to verify your identity.'
                                : 'Login with your Aadhar number to securely access your Ayur ID.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(height: 36),

                          // Aadhar field
                          const Text(
                            'Aadhar ID',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: _aadharController,
                              keyboardType: TextInputType.number,
                              maxLength: 12,
                              enabled: !_otpSent,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: 5,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                hintText: 'XXXX XXXX XXXX',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                  letterSpacing: 2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                counterText: '',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 18),
                                prefixIcon: Icon(Icons.fingerprint_rounded,
                                    color: Colors.white.withOpacity(0.5), size: 22),
                              ),
                            ),
                          ),

                          // OTP field transition
                          AnimatedSize(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.fastOutSlowIn,
                            child: _otpSent
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 28),
                                      const Text(
                                        'Secure OTP',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      PinCodeTextField(
                                        appContext: context,
                                        length: 6,
                                        controller: _otpController,
                                        onChanged: (val) => setState(() => _otp = val),
                                        keyboardType: TextInputType.number,
                                        animationType: AnimationType.scale,
                                        pinTheme: PinTheme(
                                          shape: PinCodeFieldShape.box,
                                          borderRadius: BorderRadius.circular(14),
                                          fieldHeight: 54,
                                          fieldWidth: 46,
                                          activeFillColor: Colors.white.withOpacity(0.15),
                                          inactiveFillColor: Colors.white.withOpacity(0.05),
                                          selectedFillColor: Colors.white.withOpacity(0.1),
                                          activeColor: AppColors.teal,
                                          inactiveColor: Colors.white.withOpacity(0.1),
                                          selectedColor: AppColors.blueLight,
                                        ),
                                        enableActiveFill: true,
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            "Didn't receive code? ",
                                            style: TextStyle(
                                                color: Colors.white.withOpacity(0.6), fontSize: 13),
                                          ),
                                          GestureDetector(
                                            onTap: _sendOtp,
                                            child: const Text(
                                              'Resend OTP',
                                              style: TextStyle(
                                                color: Color(0xFF27D095),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),

                          const SizedBox(height: 40),

                          // Primary button inside card
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: !_isLoading
                                      ? [AppColors.teal, const Color(0xFF16805E)]
                                      : [AppColors.teal.withOpacity(0.5), const Color(0xFF16805E).withOpacity(0.5)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: !_isLoading
                                    ? [
                                        BoxShadow(
                                          color: AppColors.teal.withOpacity(0.4),
                                          blurRadius: 16,
                                          offset: const Offset(0, 6),
                                        )
                                      ]
                                    : [],
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : (_otpSent ? _verifyOtp : _sendOtp),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.8,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _otpSent ? 'Verify & Login' : 'Send Code',
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(Icons.arrow_forward_rounded, size: 20),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Bottom Disclaimer
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shield_rounded, 
                              color: Colors.white.withOpacity(0.4), size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Secured by AES-256 Encryption',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
    );
  }
}
