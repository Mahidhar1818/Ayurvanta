import 'package:flutter/material.dart';
import '../../models/hospital_models.dart';

class AdminStaffScreen extends StatefulWidget {
  final List<StaffMember> staff;
  final Function(List<StaffMember>) onStaffChanged;
  const AdminStaffScreen({
    super.key, required this.staff, required this.onStaffChanged});

  @override
  State<AdminStaffScreen> createState() => _AdminStaffScreenState();
}

class _AdminStaffScreenState extends State<AdminStaffScreen> {
  HospitalStaffRole? _filterRole;

  List<StaffMember> get _filtered => _filterRole == null
      ? widget.staff
      : widget.staff.where((s) => s.role == _filterRole).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips + Add button
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        selected: _filterRole == null,
                        onTap: () =>
                            setState(() => _filterRole = null),
                      ),
                      const SizedBox(width: 8),
                      ...HospitalStaffRole.values.map((r) =>
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _FilterChip(
                            label: r.label,
                            selected: _filterRole == r,
                            color: r.color,
                            onTap: () =>
                                setState(() => _filterRole = r),
                          ),
                        )),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _showAddStaffSheet(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF534AB7),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add_rounded,
                          color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('Add Staff',
                        style: TextStyle(color: Colors.white,
                            fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Staff list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _StaffCard(
              member: _filtered[i],
              onEdit: () =>
                  _showEditStaffSheet(context, _filtered[i]),
              onDelete: () => _deleteStaff(_filtered[i]),
              onToggle: () => _toggleActive(_filtered[i]),
            ),
          ),
        ),
      ],
    );
  }

  void _deleteStaff(StaffMember s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Staff'),
        content: Text(
            'Remove ${s.name} from the system? '
            'Their login will be deactivated.'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final updated = List<StaffMember>.from(widget.staff)
                ..removeWhere((m) => m.id == s.id);
              widget.onStaffChanged(updated);
            },
            child: const Text('Remove',
                style: TextStyle(color: Color(0xFFA32D2D))),
          ),
        ],
      ),
    );
  }

  void _toggleActive(StaffMember s) {
    // In real app: API call; here just rebuild
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${s.name} status updated'),
      backgroundColor: const Color(0xFF1D9E75),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
    ));
  }

  void _showAddStaffSheet(BuildContext context) {
    _showStaffForm(context, null);
  }

  void _showEditStaffSheet(BuildContext context, StaffMember s) {
    _showStaffForm(context, s);
  }

  void _showStaffForm(BuildContext context, StaffMember? existing) {
    final nameCtrl = TextEditingController(
        text: existing?.name ?? '');
    final empIdCtrl = TextEditingController(
        text: existing?.empId ?? '');
    final emailCtrl = TextEditingController(
        text: existing?.email ?? '');
    final phoneCtrl = TextEditingController(
        text: existing?.phone ?? '');
    final specCtrl = TextEditingController(
        text: existing?.specialization ?? '');
    var selectedRole =
        existing?.role ?? HospitalStaffRole.doctor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 28,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD3D1C7),
                    borderRadius: BorderRadius.circular(2)),
                )),
                const SizedBox(height: 16),
                Text(existing == null
                    ? 'Add New Staff Member'
                    : 'Edit Staff Member',
                  style: const TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1442))),
                const SizedBox(height: 20),

                // Role selector
                const Text('ROLE', style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: Color(0xFF888780), letterSpacing: 0.8)),
                const SizedBox(height: 8),
                Row(
                  children: HospitalStaffRole.values.map((r) =>
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setS(() => selectedRole = r),
                        child: Container(
                          margin: EdgeInsets.only(
                              right: r != HospitalStaffRole.reportist
                                  ? 8 : 0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10),
                          decoration: BoxDecoration(
                            color: selectedRole == r
                                ? r.bgColor : const Color(0xFFF1EFE8),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selectedRole == r
                                  ? r.color
                                  : const Color(0xFFD3D1C7),
                              width: selectedRole == r ? 1.5 : 0.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(r.emoji,
                                  style: const TextStyle(fontSize: 18)),
                              const SizedBox(height: 4),
                              Text(r.label,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: selectedRole == r
                                      ? r.color
                                      : const Color(0xFF888780),
                                )),
                            ],
                          ),
                        ),
                      ),
                    )).toList(),
                ),
                const SizedBox(height: 16),

                _FormField(label: 'FULL NAME',
                    controller: nameCtrl,
                    hint: 'e.g. Dr. Ramesh Babu'),
                const SizedBox(height: 12),
                _FormField(label: 'EMPLOYEE ID',
                    controller: empIdCtrl,
                    hint: 'e.g. EMP-D-004'),
                const SizedBox(height: 12),
                _FormField(label: 'EMAIL',
                    controller: emailCtrl,
                    hint: 'email@hospital.in',
                    keyboard: TextInputType.emailAddress),
                const SizedBox(height: 12),
                _FormField(label: 'PHONE',
                    controller: phoneCtrl,
                    hint: '+91 XXXXX XXXXX',
                    keyboard: TextInputType.phone),
                const SizedBox(height: 12),
                _FormField(label: 'SPECIALIZATION',
                    controller: specCtrl,
                    hint: 'e.g. General Medicine'),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.isEmpty ||
                          empIdCtrl.text.isEmpty) return;
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                        content: Text(existing == null
                            ? '${nameCtrl.text} added successfully'
                            : '${nameCtrl.text} updated'),
                        backgroundColor: const Color(0xFF1D9E75),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF534AB7),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      existing == null
                          ? 'Add Staff Member'
                          : 'Save Changes',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Staff Card ────────────────────────────────────────────
class _StaffCard extends StatelessWidget {
  final StaffMember member;
  final VoidCallback onEdit, onDelete, onToggle;
  const _StaffCard({
    required this.member, required this.onEdit,
    required this.onDelete, required this.onToggle});

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
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: member.role.bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                  color: member.role.color.withOpacity(0.3),
                  width: 1.5),
            ),
            child: Center(child: Text(
              member.name.split(' ').take(2)
                  .map((n) => n[0]).join().toUpperCase(),
              style: TextStyle(fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: member.role.color))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name,
                  style: const TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1442))),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: member.role.bgColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(member.role.label,
                        style: TextStyle(fontSize: 9,
                            color: member.role.color,
                            fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 6),
                    Text(member.empId,
                      style: const TextStyle(fontSize: 11,
                          color: Color(0xFF888780))),
                  ],
                ),
                const SizedBox(height: 2),
                Text(member.specialization,
                  style: const TextStyle(fontSize: 11,
                      color: Color(0xFF888780))),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded,
                color: Color(0xFF888780), size: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit',
                  child: Row(children: [
                    Icon(Icons.edit_rounded, size: 16,
                        color: Color(0xFF534AB7)),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ])),
              const PopupMenuItem(value: 'toggle',
                  child: Row(children: [
                    Icon(Icons.toggle_on_rounded, size: 16,
                        color: Color(0xFF1D9E75)),
                    SizedBox(width: 10),
                    Text('Toggle Active'),
                  ])),
              const PopupMenuItem(value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete_rounded, size: 16,
                        color: Color(0xFFA32D2D)),
                    SizedBox(width: 10),
                    Text('Remove',
                        style: TextStyle(color: Color(0xFFA32D2D))),
                  ])),
            ],
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') onDelete();
              if (v == 'toggle') onToggle();
            },
          ),
        ],
      ),
    );
  }
}

// ── Helpers ────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected,
      this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFF534AB7);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c.withOpacity(0.12) : const Color(0xFFF1EFE8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? c : Colors.transparent, width: 1),
        ),
        child: Text(label,
          style: TextStyle(fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? c : const Color(0xFF888780))),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label, hint;
  final TextEditingController controller;
  final TextInputType? keyboard;
  const _FormField({
    required this.label, required this.hint,
    required this.controller, this.keyboard});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF888780), letterSpacing: 0.8)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFFD3D1C7), width: 0.5),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboard,
            style: const TextStyle(fontSize: 14,
                color: Color(0xFF1A1442)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  fontSize: 13, color: Color(0xFFB4B2A9)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
