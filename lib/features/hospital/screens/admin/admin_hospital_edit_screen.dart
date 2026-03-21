import 'package:flutter/material.dart';
import '../../models/hospital_models.dart';

class AdminHospitalEditScreen extends StatefulWidget {
  final HospitalProfile hospital;
  final Function(HospitalProfile) onSave;
  const AdminHospitalEditScreen({
      super.key, required this.hospital, required this.onSave});

  @override
  State<AdminHospitalEditScreen> createState() =>
      _AdminHospitalEditScreenState();
}

class _AdminHospitalEditScreenState
    extends State<AdminHospitalEditScreen> {
  late final _nameCtrl    = TextEditingController(text: widget.hospital.name);
  late final _tagCtrl     = TextEditingController(text: widget.hospital.tagline);
  late final _addrCtrl    = TextEditingController(text: widget.hospital.address);
  late final _cityCtrl    = TextEditingController(text: widget.hospital.city);
  late final _pinCtrl     = TextEditingController(text: widget.hospital.pin);
  late final _phoneCtrl   = TextEditingController(text: widget.hospital.phone);
  late final _emailCtrl   = TextEditingController(text: widget.hospital.email);
  late final _timingsCtrl = TextEditingController(text: widget.hospital.timings);
  late final _bedsCtrl    = TextEditingController(
      text: widget.hospital.bedCount.toString());

  late List<String> _specialities =
      List.from(widget.hospital.specialities);
  final _specCtrl = TextEditingController();

  @override
  void dispose() {
    for (final c in [_nameCtrl, _tagCtrl, _addrCtrl,
        _cityCtrl, _pinCtrl, _phoneCtrl, _emailCtrl,
        _timingsCtrl, _bedsCtrl, _specCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1442),
        foregroundColor: Colors.white,
        title: const Text('Edit Hospital Profile',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save',
              style: TextStyle(color: Color(0xFF9F99F0),
                  fontWeight: FontWeight.w800)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Cover images section
            _Section(
              title: 'Hospital Photos',
              child: Column(
                children: [
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEDFE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFFCECBF6),
                          width: 1.5,
                          style: BorderStyle.solid),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_rounded,
                              color: Color(0xFF534AB7), size: 36),
                          SizedBox(height: 8),
                          Text('Tap to add photos',
                            style: TextStyle(color: Color(0xFF534AB7),
                                fontWeight: FontWeight.w700)),
                          SizedBox(height: 4),
                          Text('First photo becomes cover image',
                            style: TextStyle(color: Color(0xFF7F77DD),
                                fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _Section(
              title: 'Basic Information',
              child: Column(
                children: [
                  _EditField(label: 'Hospital Name',
                      controller: _nameCtrl),
                  const SizedBox(height: 12),
                  _EditField(label: 'Tagline',
                      controller: _tagCtrl,
                      maxLines: 2),
                  const SizedBox(height: 12),
                  _EditField(label: 'Address',
                      controller: _addrCtrl,
                      maxLines: 2),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _EditField(
                        label: 'City', controller: _cityCtrl)),
                    const SizedBox(width: 12),
                    Expanded(child: _EditField(
                        label: 'PIN Code', controller: _pinCtrl,
                        keyboard: TextInputType.number)),
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _Section(
              title: 'Contact & Timings',
              child: Column(
                children: [
                  _EditField(label: 'Phone', controller: _phoneCtrl,
                      keyboard: TextInputType.phone),
                  const SizedBox(height: 12),
                  _EditField(label: 'Email', controller: _emailCtrl,
                      keyboard: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  _EditField(label: 'OPD Timings',
                      controller: _timingsCtrl),
                  const SizedBox(height: 12),
                  _EditField(label: 'Total Beds',
                      controller: _bedsCtrl,
                      keyboard: TextInputType.number),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _Section(
              title: 'Specialities',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: _specialities.map((s) =>
                      Chip(
                        label: Text(s),
                        backgroundColor: const Color(0xFFEEEDFE),
                        side: const BorderSide(
                            color: Color(0xFFCECBF6)),
                        labelStyle: const TextStyle(
                            color: Color(0xFF534AB7), fontSize: 12),
                        onDeleted: () =>
                            setState(() => _specialities.remove(s)),
                        deleteIconColor: const Color(0xFF534AB7),
                      )).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F7FB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xFFD3D1C7),
                                width: 0.5),
                          ),
                          child: TextField(
                            controller: _specCtrl,
                            style: const TextStyle(fontSize: 13),
                            decoration: const InputDecoration(
                              hintText: 'Add speciality...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          if (_specCtrl.text.trim().isEmpty) return;
                          setState(() {
                            _specialities.add(
                                _specCtrl.text.trim());
                            _specCtrl.clear();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF534AB7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _save() {
    widget.hospital.name      = _nameCtrl.text;
    widget.hospital.tagline   = _tagCtrl.text;
    widget.hospital.address   = _addrCtrl.text;
    widget.hospital.city      = _cityCtrl.text;
    widget.hospital.pin       = _pinCtrl.text;
    widget.hospital.phone     = _phoneCtrl.text;
    widget.hospital.email     = _emailCtrl.text;
    widget.hospital.timings   = _timingsCtrl.text;
    widget.hospital.bedCount  =
        int.tryParse(_bedsCtrl.text) ?? widget.hospital.bedCount;
    widget.hospital.specialities = _specialities;
    widget.onSave(widget.hospital);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Hospital profile updated'),
      backgroundColor: Color(0xFF1D9E75),
      behavior: SnackBarBehavior.floating,
    ));
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1442))),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final int maxLines;
  const _EditField({required this.label, required this.controller,
      this.keyboard, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF888780), letterSpacing: 0.5)),
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
            keyboardType: keyboard,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 13,
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
