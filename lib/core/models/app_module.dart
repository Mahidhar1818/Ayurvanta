import 'package:flutter/material.dart';

enum AppModule {
  patient, hospital, doctor, pharmacy, delivery, ambulance,
}

enum HospitalRole { admin, doctor, receptionist, reportist }

class HospitalRoleInfo {
  final HospitalRole role;
  final String name, description, emoji;
  final Color bgColor, borderColor, iconBg, textColor;

  const HospitalRoleInfo({
    required this.role,
    required this.name,
    required this.description,
    required this.emoji,
    required this.bgColor,
    required this.borderColor,
    required this.iconBg,
    required this.textColor,
  });

  static const all = [
    HospitalRoleInfo(
      role: HospitalRole.admin,
      name: 'Admin',
      description: 'Full hospital control & staff management',
      emoji: '🛡️',
      bgColor: Color(0xFFEEEDFE),
      borderColor: Color(0xFFCECBF6),
      iconBg: Color(0xFF534AB7),
      textColor: Color(0xFF3C3489),
    ),
    HospitalRoleInfo(
      role: HospitalRole.doctor,
      name: 'Doctor',
      description: 'Patient care, OPD & prescriptions',
      emoji: '👨‍⚕️',
      bgColor: Color(0xFFE6F1FB),
      borderColor: Color(0xFFB5D4F4),
      iconBg: Color(0xFF185FA5),
      textColor: Color(0xFF0C447C),
    ),
    HospitalRoleInfo(
      role: HospitalRole.receptionist,
      name: 'Receptionist',
      description: 'Appointments, check-in & billing',
      emoji: '🗂️',
      bgColor: Color(0xFFEAF3DE),
      borderColor: Color(0xFFC0DD97),
      iconBg: Color(0xFF3B6D11),
      textColor: Color(0xFF27500A),
    ),
    HospitalRoleInfo(
      role: HospitalRole.reportist,
      name: 'Reportist',
      description: 'Lab reports, uploads & results',
      emoji: '🧪',
      bgColor: Color(0xFFFAEEDA),
      borderColor: Color(0xFFFAC775),
      iconBg: Color(0xFF854F0B),
      textColor: Color(0xFF633806),
    ),
  ];
}

class AppModuleInfo {
  final AppModule module;
  final String name, description, emoji;
  final Color bgColor, borderColor, iconBg, textColor;

  const AppModuleInfo({
    required this.module,
    required this.name,
    required this.description,
    required this.emoji,
    required this.bgColor,
    required this.borderColor,
    required this.iconBg,
    required this.textColor,
  });

  static const all = [
    AppModuleInfo(
      module: AppModule.patient,
      name: 'Patient',
      description: 'Book appointments, records & medicines',
      emoji: '👤',
      bgColor: Color(0xFFE6F1FB),
      borderColor: Color(0xFFB5D4F4),
      iconBg: Color(0xFF185FA5),
      textColor: Color(0xFF0C447C),
    ),
    AppModuleInfo(
      module: AppModule.hospital,
      name: 'Hospital',
      description: 'Manage staff, patients & appointments',
      emoji: '🏥',
      bgColor: Color(0xFFEAF3DE),
      borderColor: Color(0xFFC0DD97),
      iconBg: Color(0xFF3B6D11),
      textColor: Color(0xFF27500A),
    ),
    AppModuleInfo(
      module: AppModule.doctor,
      name: 'Doctor',
      description: 'Independent consultations & schedules',
      emoji: '👨‍⚕️',
      bgColor: Color(0xFFEEEDFE),
      borderColor: Color(0xFFCECBF6),
      iconBg: Color(0xFF534AB7),
      textColor: Color(0xFF3C3489),
    ),
    AppModuleInfo(
      module: AppModule.pharmacy,
      name: 'Pharmacy',
      description: 'Medical store & equipment dealer',
      emoji: '💊',
      bgColor: Color(0xFFFAEEDA),
      borderColor: Color(0xFFFAC775),
      iconBg: Color(0xFF854F0B),
      textColor: Color(0xFF633806),
    ),
    AppModuleInfo(
      module: AppModule.delivery,
      name: 'Delivery',
      description: 'Deliver medicines & medical items',
      emoji: '🚚',
      bgColor: Color(0xFFE1F5EE),
      borderColor: Color(0xFF9FE1CB),
      iconBg: Color(0xFF0F6E56),
      textColor: Color(0xFF085041),
    ),
    AppModuleInfo(
      module: AppModule.ambulance,
      name: 'Ambulance',
      description: 'Emergency dispatch & live tracking',
      emoji: '🚑',
      bgColor: Color(0xFFFCEBEB),
      borderColor: Color(0xFFF7C1C1),
      iconBg: Color(0xFFA32D2D),
      textColor: Color(0xFF791F1F),
    ),
  ];
}
