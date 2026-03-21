import 'package:flutter/material.dart';
import '../../models/op_models.dart';

class AdminPaymentsScreen extends StatefulWidget {
  final List<OPRecord> ops;
  const AdminPaymentsScreen({super.key, required this.ops});

  @override
  State<AdminPaymentsScreen> createState() =>
      _AdminPaymentsScreenState();
}

class _AdminPaymentsScreenState
    extends State<AdminPaymentsScreen> {
  PaymentStatus? _filter;

  List<OPRecord> get _filtered => _filter == null
      ? widget.ops
      : widget.ops.where((o) => o.paymentStatus == _filter)
          .toList();

  double get _totalCollected => widget.ops
      .where((o) => o.paymentStatus == PaymentStatus.paid)
      .fold(0, (s, o) => s + o.totalBill);

  double get _totalPending => widget.ops
      .where((o) => o.paymentStatus == PaymentStatus.pending)
      .fold(0, (s, o) => s + o.totalBill);

  double get _totalPartial => widget.ops
      .where((o) => o.paymentStatus == PaymentStatus.partial)
      .fold(0, (s, o) => s + o.totalBill);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Summary cards
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Today's Payments",
                  style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1442))),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _PaySummaryCard(
                      label: 'Collected',
                      value: '₹${_totalCollected.toStringAsFixed(0)}',
                      color: const Color(0xFF1D9E75),
                      bgColor: const Color(0xFFE1F5EE),
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _PaySummaryCard(
                      label: 'Pending',
                      value: '₹${_totalPending.toStringAsFixed(0)}',
                      color: const Color(0xFFA32D2D),
                      bgColor: const Color(0xFFFCEBEB),
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _PaySummaryCard(
                      label: 'Partial',
                      value: '₹${_totalPartial.toStringAsFixed(0)}',
                      color: const Color(0xFFBA7517),
                      bgColor: const Color(0xFFFAEEDA),
                    )),
                  ],
                ),
              ],
            ),
          ),

          // Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
                left: 14, right: 14, bottom: 12),
            child: Row(
              children: [
                _PChip(label: 'All', selected: _filter == null,
                    onTap: () => setState(() => _filter = null)),
                const SizedBox(width: 8),
                _PChip(label: 'Paid',
                    selected: _filter == PaymentStatus.paid,
                    color: const Color(0xFF1D9E75),
                    onTap: () => setState(
                        () => _filter = PaymentStatus.paid)),
                const SizedBox(width: 8),
                _PChip(label: 'Pending',
                    selected: _filter == PaymentStatus.pending,
                    color: const Color(0xFFA32D2D),
                    onTap: () => setState(
                        () => _filter = PaymentStatus.pending)),
                const SizedBox(width: 8),
                _PChip(label: 'Partial',
                    selected: _filter == PaymentStatus.partial,
                    color: const Color(0xFFBA7517),
                    onTap: () => setState(
                        () => _filter = PaymentStatus.partial)),
              ],
            ),
          ),

          // Payment list
          ListView.separated(
            padding: const EdgeInsets.all(12),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filtered.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 8),
            itemBuilder: (_, i) =>
                _PaymentRow(op: _filtered[i],
                  onMarkPaid: () {
                    setState(() {
                      _filtered[i].paymentStatus =
                          PaymentStatus.paid;
                    });
                  }),
          ),
        ],
      ),
    );
  }
}

class _PaySummaryCard extends StatelessWidget {
  final String label, value;
  final Color color, bgColor;
  const _PaySummaryCard({required this.label, required this.value,
      required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor, borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11,
              color: color.withOpacity(0.7),
              fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14,
              fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final OPRecord op;
  final VoidCallback onMarkPaid;
  const _PaymentRow({required this.op, required this.onMarkPaid});

  Color get _payColor {
    switch (op.paymentStatus) {
      case PaymentStatus.paid:    return const Color(0xFF1D9E75);
      case PaymentStatus.pending: return const Color(0xFFA32D2D);
      case PaymentStatus.partial: return const Color(0xFFBA7517);
    }
  }

  String get _payLabel {
    switch (op.paymentStatus) {
      case PaymentStatus.paid:    return 'Paid';
      case PaymentStatus.pending: return 'Pending';
      case PaymentStatus.partial: return 'Partial';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: _payColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(
              op.paymentStatus == PaymentStatus.paid
                  ? Icons.check_circle_rounded
                  : Icons.pending_rounded,
              color: _payColor, size: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(op.patientName,
                  style: const TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1442))),
                Text('${op.tokenNo} · ${op.timeSlot}',
                  style: const TextStyle(fontSize: 11,
                      color: Color(0xFF888780))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${op.totalBill.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1442))),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _payColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(_payLabel,
                  style: TextStyle(fontSize: 10,
                      color: _payColor,
                      fontWeight: FontWeight.w700)),
              ),
              if (op.paymentStatus != PaymentStatus.paid)
                GestureDetector(
                  onTap: onMarkPaid,
                  child: const Text('Mark Paid',
                    style: TextStyle(fontSize: 10,
                        color: Color(0xFF1D9E75),
                        fontWeight: FontWeight.w700)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;
  const _PChip({required this.label, required this.selected,
      this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFF534AB7);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c.withOpacity(0.12)
              : const Color(0xFFF1EFE8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? c : Colors.transparent,
              width: 1),
        ),
        child: Text(label, style: TextStyle(fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? c : const Color(0xFF888780))),
      ),
    );
  }
}