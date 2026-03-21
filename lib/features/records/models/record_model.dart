import 'package:flutter/material.dart';

enum RecordType { report, prescription, scan, other }

enum RecordStatus { normal, borderline, review, active, expired }

class RecordModel {
  final String id, title, doctor, hospital, date;
  final RecordType type;
  final RecordStatus status;
  final Color iconBg;
  final IconData icon;

  const RecordModel({
    required this.id, required this.title,
    required this.doctor, required this.hospital,
    required this.date, required this.type,
    required this.status, required this.iconBg,
    required this.icon,
  });
}

class PrescriptionModel {
  final String id, doctorName, doctorInitials,
      specialty, hospital, date;
  final bool isActive;
  final List<MedicineModel> medicines;

  const PrescriptionModel({
    required this.id, required this.doctorName,
    required this.doctorInitials, required this.specialty,
    required this.hospital, required this.date,
    required this.isActive, required this.medicines,
  });
}

class MedicineModel {
  final String name, dosage, duration;
  const MedicineModel({
    required this.name,
    required this.dosage,
    required this.duration,
  });
}
