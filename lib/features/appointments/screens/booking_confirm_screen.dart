import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../models/doctor_model.dart';

class BookingConfirmScreen extends StatefulWidget {
  final DoctorModel doctor;
  final String selectedSlot;
  const BookingConfirmScreen({
    super.key,
    required this.doctor,
    required this.selectedSlot,
  });
  @override
  State<BookingConfirmScreen> createState() =>
      _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends State<BookingConfirmScreen> {
  bool _confirmed = false;
  bool _isLoading = false;

  void _confirmBooking() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() { _isLoading = false; _confirmed = true; });
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.doctor;
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
        title: const Text('Confirm Booking',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: _confirmed ? _SuccessView(doctor: d,
          slot: widget.selectedSlot)
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            FadeInDown(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: const Color(0xFFE3EAF2), width: 0.5),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 70, height: 70,
                      decoration: BoxDecoration(
                        color: d.color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(d.initials,
                          style: const TextStyle(color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(d.name,
                      style: const TextStyle(fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(d.specialty,
                      style: const TextStyle(fontSize: 14,
                          color: AppColors.textSecondary)),
                    Text(d.hospital,
                      style: const TextStyle(fontSize: 12,
                          color: AppColors.textHint)),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFF0F4F8)),
                    const SizedBox(height: 16),
                    _DetailRow('Date', 'Tomorrow, Mar 22, 2026'),
                    _DetailRow('Time', widget.selectedSlot),
                    _DetailRow('Type', 'In-person Consultation'),
                    _DetailRow('Fee', '₹\${d.fee}'),
                    _DetailRow('Ayur ID', 'AYR-4829-3810-7642'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: SizedBox(
                width: double.infinity, height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _confirmBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : const Text('Confirm & Pay ₹',
                          style: TextStyle(fontSize: 16,
                              fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  const _DetailRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 13,
              color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

// ── Success View ─────────────────────────────────────────
class _SuccessView extends StatelessWidget {
  final DoctorModel doctor;
  final String slot;
  const _SuccessView({required this.doctor, required this.slot});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomIn(
              child: Container(
                width: 90, height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF3DE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: Color(0xFF1D9E75), size: 48),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(delay: const Duration(milliseconds: 200),
              child: const Text('Appointment Confirmed!',
                style: TextStyle(fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            ),
            const SizedBox(height: 10),
            FadeInUp(delay: const Duration(milliseconds: 300),
              child: Text(
                'Your appointment with \${doctor.name}\\nis confirmed for \$slot tomorrow.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14,
                    color: AppColors.textSecondary, height: 1.6),
              ),
            ),
            const SizedBox(height: 32),
            FadeInUp(delay: const Duration(milliseconds: 400),
              child: SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Back to Home',
                      style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
