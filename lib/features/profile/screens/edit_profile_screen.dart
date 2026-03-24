import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/translations/tr_extension.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl   = TextEditingController(text: 'Arjun Sharma');
  final _phoneCtrl  = TextEditingController(text: '+91 98765 43210');
  final _emailCtrl  = TextEditingController(text: 'arjun@gmail.com');
  final _dobCtrl    = TextEditingController(text: '14 Mar 1990');
  final _bloodCtrl  = TextEditingController(text: 'B+');
  final _genderCtrl = TextEditingController(text: 'Male');
  final _heightCtrl = TextEditingController(text: '172 cm');
  final _weightCtrl = TextEditingController(text: '74 kg');

  bool _isSaving = false;

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('profile_updated') ?? 'Profile updated successfully!'),
          backgroundColor: AppColors.teal,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        title: Text(context.tr('edit_profile') ?? 'Edit Profile',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 46,
                    backgroundColor: AppColors.teal,
                    child: Text('AS',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800)),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.navyDark,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
              ),
              child: Column(
                children: [
                  _buildField('Full Name', _nameCtrl),
                  _buildField('Phone Number', _phoneCtrl),
                  _buildField('Email Address', _emailCtrl),
                  _buildField('Date of Birth', _dobCtrl),
                  _buildField('Gender', _genderCtrl),
                  _buildField('Blood Group', _bloodCtrl),
                  Row(
                    children: [
                      Expanded(child: _buildField('Height', _heightCtrl)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildField('Weight', _weightCtrl)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 24, height: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Save Changes',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE3EAF2))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.blue)),
            ),
          ),
        ],
      ),
    );
  }
}
