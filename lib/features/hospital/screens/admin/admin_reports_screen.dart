import 'package:flutter/material.dart';
import '../../models/op_models.dart';

class AdminReportsScreen extends StatefulWidget {
  final List<OPRecord> ops;
  final Function(String opId, double newBill) onBillEdit;
  const AdminReportsScreen({
      super.key, required this.ops, required this.onBillEdit});

  @override
  State<AdminReportsScreen> createState() =>
      _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  String _search = '';
  OPStatus? _filter;

  List<OPRecord> get _filtered => widget.ops.where((op) {
    final matchSearch = _search.isEmpty ||
        op.patientName.toLowerCase().contains(_search.toLowerCase()) ||
        op.ayurId.contains(_search);
    final matchFilter = _filter == null || op.status == _filter;
    return matchSearch && matchFilter;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Search
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFD3D1C7), width: 0.5),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Search patient name or Ayur ID...',
                    hintStyle: TextStyle(fontSize: 13,
                        color: Color(0xFFB4B2A9)),
                    prefixIcon: Icon(Icons.search_rounded,
                        color: Color(0xFFB4B2A9), size: 18),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Status filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _Chip(label: 'All',
                        selected: _filter == null,
                        onTap: () =>
                            setState(() => _filter = null)),
                    const SizedBox(width: 8),
                    ...OPStatus.values.map((s) =>
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _Chip(label: s.label,
                            selected: _filter == s,
                            onTap: () =>
                                setState(() => _filter = s)),
                      )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _filtered.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 8),
            itemBuilder: (_, i) => _OPReportCard(
              op: _filtered[i],
              onEditBill: () =>
                  _showBillEditor(context, _filtered[i]),
            ),
          ),
        ),
      ],
    );
  }

  void _showBillEditor(BuildContext context, OPRecord op) {
    final consultCtrl =
        TextEditingController(text: op.consultFee.toString());
    final reportCtrl =
        TextEditingController(text: op.reportFee.toString());
    final medCtrl =
        TextEditingController(text: op.medicineFee.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD3D1C7),
                borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Edit Bill — ${op.patientName}',
              style: const TextStyle(fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1442))),
            Text('Token ${op.tokenNo} · ${op.timeSlot}',
              style: const TextStyle(fontSize: 12,
                  color: Color(0xFF888780))),
            const SizedBox(height: 20),
            _BillField(label: 'Consultation Fee ₹',
                controller: consultCtrl),
            const SizedBox(height: 12),
            _BillField(label: 'Report / Lab Fee ₹',
                controller: reportCtrl),
            const SizedBox(height: 12),
            _BillField(label: 'Medicine Fee ₹',
                controller: medCtrl),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final total =
                    (double.tryParse(consultCtrl.text) ?? 0) +
                    (double.tryParse(reportCtrl.text) ?? 0) +
                    (double.tryParse(medCtrl.text) ?? 0);
                  widget.onBillEdit(op.id, total);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF534AB7),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Update Bill',
                    style: TextStyle(fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OPReportCard extends StatelessWidget {
  final OPRecord op;
  final VoidCallback onEditBill;
  const _OPReportCard({required this.op, required this.onEditBill});

  Color get _statusColor {
    switch (op.status) {
      case OPStatus.completed: return const Color(0xFF1D9E75);
      case OPStatus.withDoctor: return const Color(0xFF185FA5);
      case OPStatus.inLab: return const Color(0xFF854F0B);
      case OPStatus.billing: return const Color(0xFF534AB7);
      case OPStatus.waiting: return const Color(0xFF888780);
      case OPStatus.cancelled: return const Color(0xFFA32D2D);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(op.patientName,
                      style: const TextStyle(fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1442))),
                    Text('${op.ayurId} · Age ${op.age} · ${op.gender}',
                      style: const TextStyle(fontSize: 11,
                          color: Color(0xFF888780))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(op.status.label,
                  style: TextStyle(fontSize: 10,
                      color: _statusColor,
                      fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          if (op.prescribedTests.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text('Prescribed Tests:',
              style: TextStyle(fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF888780))),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6, runSpacing: 6,
              children: op.prescribedTests.map((t) =>
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAEEDA),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(t, style: const TextStyle(
                      fontSize: 11, color: Color(0xFF854F0B),
                      fontWeight: FontWeight.w600)),
                )).toList(),
            ),
          ],
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFE3EAF2)),
          const SizedBox(height: 10),
          Row(
            children: [
              _BillItem(label: 'Consult',
                  value: '₹${op.consultFee.toStringAsFixed(0)}'),
              _BillItem(label: 'Reports',
                  value: '₹${op.reportFee.toStringAsFixed(0)}'),
              _BillItem(label: 'Medicine',
                  value: '₹${op.medicineFee.toStringAsFixed(0)}'),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${op.totalBill.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1442))),
                  GestureDetector(
                    onTap: onEditBill,
                    child: const Text('Edit Bill',
                      style: TextStyle(fontSize: 11,
                          color: Color(0xFF534AB7),
                          fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BillItem extends StatelessWidget {
  final String label, value;
  const _BillItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10,
              color: Color(0xFFB4B2A9),
              fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1442))),
        ],
      ),
    );
  }
}

class _BillField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _BillField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF888780))),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: const Color(0xFFD3D1C7), width: 0.5),
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true),
            style: const TextStyle(fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1442)),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF534AB7).withOpacity(0.12)
              : const Color(0xFFF1EFE8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected
                  ? const Color(0xFF534AB7)
                  : Colors.transparent,
              width: 1),
        ),
        child: Text(label, style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700,
            color: selected
                ? const Color(0xFF534AB7)
                : const Color(0xFF888780))),
      ),
    );
  }
}
