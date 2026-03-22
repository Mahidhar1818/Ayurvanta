import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';

class PaymentScreen extends StatefulWidget {
  final int total;
  final int itemCount;
  final VoidCallback onSuccess;

  const PaymentScreen({
    super.key,
    required this.total,
    required this.itemCount,
    required this.onSuccess,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _method = 'upi';
  bool _processing = false;
  bool _success = false;

  static const _methods = [
    {'id': 'upi',       'label': 'UPI / GPay / PhonePe',     'emoji': '📱'},
    {'id': 'card',      'label': 'Credit / Debit Card',       'emoji': '💳'},
    {'id': 'netbanking','label': 'Net Banking',               'emoji': '🏦'},
    {'id': 'cod',       'label': 'Cash on Delivery',          'emoji': '💵'},
    {'id': 'insurance', 'label': 'Insurance / Mediclaim',     'emoji': '🏥'},
  ];

  Future<void> _pay() async {
    setState(() => _processing = true);
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() { _processing = false; _success = true; });
    HapticFeedback.heavyImpact();
    // Wait 2 seconds then pop and call onSuccess
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pop(context);
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Payment',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(8)),
              child: Text('₹${widget.total}',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800,
                      color: AppColors.blue)))))
        ]),
      body: _success ? _successBody() : _payBody(),
    );
  }

  Widget _successBody() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        ZoomIn(child: Container(width: 100, height: 100,
            decoration: const BoxDecoration(
                color: Color(0xFFEAF3DE), shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded,
                color: AppColors.teal, size: 56))),
        const SizedBox(height: 24),
        FadeInUp(delay: const Duration(milliseconds: 200),
            child: const Text('Payment Successful! 🎉',
                style: TextStyle(fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary))),
        const SizedBox(height: 10),
        FadeInUp(delay: const Duration(milliseconds: 300),
            child: Text(
                '${widget.itemCount} items confirmed.\n'
                'Technician arrives in 2 hrs · Devices ship tomorrow.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13,
                    color: AppColors.textSecondary, height: 1.5))),
      ])));

  Widget _payBody() => Column(children: [
    Expanded(child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        const Text('Select Payment Method',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 14),
        ..._methods.map((m) => GestureDetector(
          onTap: () => setState(() => _method = m['id']!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: _method == m['id']
                  ? AppColors.blueLight : const Color(0xFFF4F7FB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: _method == m['id']
                      ? AppColors.blue : const Color(0xFFE3EAF2),
                  width: _method == m['id'] ? 1.5 : 0.5)),
            child: Row(children: [
              Text(m['emoji']!,
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(child: Text(m['label']!,
                  style: TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _method == m['id']
                          ? AppColors.blue : AppColors.textPrimary))),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: _method == m['id']
                        ? AppColors.blue : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: _method == m['id']
                            ? AppColors.blue : Colors.grey.shade300,
                        width: 2)),
                  child: _method == m['id']
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 12)
                      : null),
            ]))),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: const Color(0xFFEAF3DE),
              borderRadius: BorderRadius.circular(12)),
          child: const Row(children: [
            Icon(Icons.lock_outline_rounded,
                color: Color(0xFF3B6D11), size: 16),
            SizedBox(width: 8),
            Expanded(child: Text(
                '256-bit SSL encrypted · RBI compliant · Ayur ID secured',
                style: TextStyle(fontSize: 11,
                    color: Color(0xFF3B6D11), height: 1.4))),
          ])),
      ]))),
    // Pay button
    Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20,
          MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(
              color: Color(0xFFE3EAF2), width: 0.5))),
      child: SizedBox(width: double.infinity, height: 54,
          child: ElevatedButton(
            onPressed: _processing ? null : _pay,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
            child: _processing
                ? const SizedBox(width: 22, height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5))
                : Text('Pay ₹${widget.total}',
                    style: const TextStyle(fontSize: 17,
                        fontWeight: FontWeight.w800))))),
  ]);
}
