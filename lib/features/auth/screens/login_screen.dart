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

class _LoginScreenState extends State<LoginScreen> {
  final _aadharController = TextEditingController();
  final _otpController    = TextEditingController();

  bool _otpSent    = false;
  bool _isLoading  = false;
  String _otp      = '';

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
        content: Text(msg),
        backgroundColor: AppColors.navyMid,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // Logo row
              FadeInDown(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.teal,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.health_and_safety_rounded,
                          color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'AyurVanta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Heading
              FadeInLeft(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeInLeft(
                delay: const Duration(milliseconds: 300),
                child: const Text(
                  'Login with your Aadhar number to\naccess your Ayur ID',
                  style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Aadhar field
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aadhar Number',
                      style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                          width: 0.5,
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
                          letterSpacing: 4,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'XXXX XXXX XXXX',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.2),
                            letterSpacing: 2,
                            fontSize: 16,
                          ),
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 16),
                          prefixIcon: const Icon(Icons.credit_card_rounded,
                              color: AppColors.textHint, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // OTP field (shown after OTP is sent)
              if (_otpSent)
                FadeInUp(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter OTP',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: _otpController,
                        onChanged: (val) => setState(() => _otp = val),
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 52,
                          fieldWidth: 44,
                          activeFillColor: Colors.white.withOpacity(0.1),
                          inactiveFillColor: Colors.white.withOpacity(0.05),
                          selectedFillColor: AppColors.teal.withOpacity(0.2),
                          activeColor: AppColors.teal,
                          inactiveColor: Colors.white.withOpacity(0.15),
                          selectedColor: AppColors.teal,
                        ),
                        enableActiveFill: true,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            "Didn't receive OTP? ",
                            style: TextStyle(
                                color: AppColors.textHint, fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: _sendOtp,
                            child: const Text(
                              'Resend',
                              style: TextStyle(
                                color: AppColors.teal,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 36),

              // Primary button
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : (_otpSent ? _verifyOtp : _sendOtp),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.teal.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            _otpSent ? 'Verify & Login' : 'Send OTP',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Disclaimer
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: Center(
                  child: Text(
                    'Your Aadhar data is AES-256 encrypted\nand never stored in plain text.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 11,
                      height: 1.6,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
