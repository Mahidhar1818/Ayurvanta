import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../services/delivery_service.dart';
import '../../../core/widgets/loading_widget.dart';
import 'delivery_dashboard_screen.dart';

class DeliveryLoginScreen extends StatefulWidget {
  const DeliveryLoginScreen({Key? key}) : super(key: key);

  @override
  _DeliveryLoginScreenState createState() => _DeliveryLoginScreenState();
}

class _DeliveryLoginScreenState extends State<DeliveryLoginScreen> {
  final TextEditingController _deliveryIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _loginMethod = 'id';
  String _errorMessage = '';
  
  final DeliveryService _deliveryService = DeliveryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Hospital themed background decor
          Positioned(
            top: -100, right: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.hospitalBlue.withOpacity(0.05),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 48),
                    _buildLoginMethodToggle(),
                    const SizedBox(height: 32),
                    _buildLoginForm(),
                    const SizedBox(height: 32),
                    _buildLoginButton(),
                    if (_errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildErrorMessage(),
                    ],
                    const SizedBox(height: 40),
                    _buildHelpSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return FadeInDown(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.hospitalBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.medical_services_rounded,
              size: 40,
              color: AppColors.hospitalBlue,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Pharmacy Network',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.hospitalBlue,
              letterSpacing: 1.2,
            ),
          ),
          const Text(
            'Delivery Partner Login',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Join the healthcare supply chain. Deliver medicines, save lives.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoginMethodToggle() {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.bgPage,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _loginMethod = 'id';
                    _errorMessage = '';
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _loginMethod == 'id' ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _loginMethod == 'id' 
                      ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
                      : [],
                  ),
                  child: Center(
                    child: Text(
                      'Partner ID',
                      style: TextStyle(
                        color: _loginMethod == 'id' ? AppColors.hospitalBlue : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _loginMethod = 'phone';
                    _errorMessage = '';
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _loginMethod == 'phone' ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _loginMethod == 'phone' 
                      ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
                      : [],
                  ),
                  child: Center(
                    child: Text(
                      'Phone Number',
                      style: TextStyle(
                        color: _loginMethod == 'phone' ? AppColors.hospitalBlue : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoginForm() {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Column(
        children: [
          if (_loginMethod == 'id') ...[
            _buildTextField(
              controller: _deliveryIdController,
              label: 'Delivery Partner ID',
              hint: 'e.g., AYURDEL001',
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 20),
          ],
          if (_loginMethod == 'phone') ...[
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: 'Enter registered mobile',
              icon: Icons.phone_android_rounded,
              type: TextInputType.phone,
            ),
            const SizedBox(height: 20),
          ],
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            isPass: true,
            suffix: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.hospitalBlue,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _forgotPassword,
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: AppColors.hospitalBlue, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPass = false,
    TextInputType type = TextInputType.text,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPass && !_isPasswordVisible,
          keyboardType: type,
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textHint.withOpacity(0.5)),
            prefixIcon: Icon(icon, color: AppColors.hospitalBlue),
            suffixIcon: suffix,
            filled: true,
            fillColor: AppColors.bgPage,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.hospitalBlue, width: 2),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildLoginButton() {
    return FadeInUp(
      delay: const Duration(milliseconds: 600),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _login,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.hospitalBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: AppColors.hospitalBlue.withOpacity(0.4),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'LOG IN TO NETWORK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
        ),
      ),
    );
  }
  
  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.emergency.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.emergency.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.emergency, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage,
              style: const TextStyle(color: AppColors.emergency, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHelpSection() {
    return FadeInUp(
      delay: const Duration(milliseconds: 800),
      child: Center(
        child: Column(
          children: [
            const Text(
              'Interested in joining AyurVanta Logistics?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            TextButton(
              onPressed: _applyNow,
              child: const Text(
                'Become a Delivery Partner',
                style: TextStyle(
                  color: AppColors.hospitalBlue,
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      Map<String, dynamic> credentials;
      
      if (_loginMethod == 'id') {
        final deliveryId = _deliveryIdController.text.trim();
        if (deliveryId.isEmpty) {
          throw Exception('Please enter Delivery Partner ID');
        }
        credentials = {
          'delivery_partner_id': deliveryId,
          'password': _passwordController.text.trim(),
        };
      } else {
        final phone = _phoneController.text.trim();
        if (phone.isEmpty) {
          throw Exception('Please enter Phone Number');
        }
        credentials = {
          'phone_number': phone,
          'password': _passwordController.text.trim(),
        };
      }
      
      final partner = await _deliveryService.loginDeliveryPartner(credentials);
      
      if (partner != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DeliveryDashboardScreen(partner: partner),
          ),
        );
      } else if (mounted) {
        setState(() {
          _errorMessage = 'Invalid credentials. Check your ID and password.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Connection failed. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Access'),
        content: const Text('Please contact your Pharmacy Manager to reset your network password.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void _applyNow() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply for Logistics Role'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle Requirements:'),
            SizedBox(height: 8),
            Text('• Temperature controlled carrier preferred'),
            Text('• Valid DL & Vehicle documents'),
            Text('• Clean background record'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
