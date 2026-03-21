import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/tr_extension.dart';
import '../../../core/services/razorpay_service.dart';
import '../../pharmacy/screens/medicine_catalog_screen.dart';

class OpdPaymentScreen extends StatefulWidget {
  final String patientName;
  final String doctorName;
  final String department;
  final String symptoms;
  final int tokenNumber;
  final int opdFee;

  const OpdPaymentScreen({
    super.key,
    required this.patientName,
    required this.doctorName,
    required this.department,
    required this.symptoms,
    required this.tokenNumber,
    this.opdFee = 200,
  });

  @override
  State<OpdPaymentScreen> createState() =>
      _OpdPaymentScreenState();
}

class _OpdPaymentScreenState
    extends State<OpdPaymentScreen> {
  late RazorpayService _rzp;
  bool _isPaying  = false;
  bool _isPaid    = false;
  String _paymentId = '';

  @override
  void initState() {
    super.initState();
    _rzp = RazorpayService(
      onSuccess: (id) {
        setState(() {
          _isPaying   = false;
          _isPaid     = true;
          _paymentId  = id;
        });
        _showSuccess();
      },
      onFailure: (err) {
        setState(() => _isPaying = false);
        _showSnack('Payment failed: $err');
      },
      onExternalWallet: () {
        setState(() => _isPaying = false);
      },
    );
  }

  void _pay() {
    setState(() => _isPaying = true);
    _rzp.openCheckout(
      amountInPaise: widget.opdFee * 100,
      description: 'OPD Fee — ${widget.department}',
      userName: widget.patientName,
      userEmail: 'patient@ayurvanta.in',
      userPhone: '+919876543210',
      orderId: 'OPD${widget.tokenNumber}${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            ZoomIn(
              child: Container(
                width: 72, height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF3DE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.teal, size: 40),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Payment Successful!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              )),
            const SizedBox(height: 8),
            Text(
              'OPD fee of ₹${widget.opdFee} paid.\n'
              'Token #${widget.tokenNumber} confirmed.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                    MaterialPageRoute(builder: (_) =>
                      const MedicineCatalogScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12)),
                ),
                child: const Text(
                    'Browse Medicines 💊'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.popUntil(
                    context, (r) => r.isFirst);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.navyMid,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _rzp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(context.tr('opd_title'),
          style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Success banner
            FadeInDown(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3DE),
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFFC0DD97),
                      width: 0.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr(
                                'registration_submitted'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF27500A),
                            )),
                          Text(
                            'Token #${widget.tokenNumber} · ${widget.doctorName}',
                            style: const TextStyle(
                                fontSize: 11,
                                color:
                                    Color(0xFF3B6D11))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Token card
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFFB5D4F4),
                      width: 0.5),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text('TOKEN NUMBER',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blue,
                            letterSpacing: 0.8,
                          )),
                        const SizedBox(height: 4),
                        Text('${widget.tokenNumber}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.blue,
                          )),
                      ],
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Show this token at the hospital reception counter when called.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.blue,
                          height: 1.5,
                        )),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Appointment summary
            FadeInUp(
              delay: const Duration(milliseconds: 150),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFFE3EAF2),
                      width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text('Appointment Summary',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      )),
                    const SizedBox(height: 10),
                    _SummaryRow(
                        context.tr('patient_name'),
                        widget.patientName),
                    _SummaryRow('Doctor',
                        widget.doctorName),
                    _SummaryRow(
                        context.tr('department'),
                        widget.department),
                    _SummaryRow(
                        context.tr('symptoms'),
                        widget.symptoms.isEmpty
                            ? '—'
                            : widget.symptoms),
                    _SummaryRow(
                        'Date & Time',
                        'Today · ${TimeOfDay.now().format(context)}'),
                    const Divider(
                        color: Color(0xFFE3EAF2)),
                    Row(
                      children: [
                        const Text('OPD Fee',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          )),
                        const Spacer(),
                        Text('₹${widget.opdFee}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.blue,
                          )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Pay button
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isPaying || _isPaid
                      ? null
                      : _pay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPaid
                        ? AppColors.teal
                        : AppColors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14)),
                  ),
                  child: _isPaying
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5))
                      : _isPaid
                          ? const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_rounded,
                                    size: 20),
                                SizedBox(width: 8),
                                Text('Paid ✓',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight.w800,
                                  )),
                              ])
                          : Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                const Icon(
                                    Icons.payment_rounded,
                                    size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '💳 Pay OPD Fee ₹${widget.opdFee}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight.w800,
                                  )),
                              ]),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Pay at counter option
            FadeInUp(
              delay: const Duration(milliseconds: 250),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (_) =>
                        const MedicineCatalogScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        AppColors.textSecondary,
                    side: const BorderSide(
                        color: Color(0xFFE3EAF2),
                        width: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Pay at Hospital Counter',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Browse medicines hint
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>
                    const MedicineCatalogScreen())),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEDFE),
                    borderRadius:
                        BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFFCECBF6),
                        width: 0.5),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.medication_rounded,
                          color: Color(0xFF534AB7),
                          size: 22),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text('Order your medicines',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3C3489),
                              )),
                            Text(
                              'Browse 40+ medicines & add to cart',
                              style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      Color(0xFF534AB7))),
                          ],
                        ),
                      ),
                      Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: Color(0xFF534AB7)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  const _SummaryRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
