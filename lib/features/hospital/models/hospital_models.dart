import 'package:flutter/material.dart';

// ── Staff member ─────────────────────────────────────────
class StaffMember {
  final String id, name, empId, email, phone, specialization;
  final HospitalStaffRole role;
  final bool isActive;
  final String joinDate;

  const StaffMember({
    required this.id,
    required this.name,
    required this.empId,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.role,
    this.isActive = true,
    required this.joinDate,
  });
}

enum HospitalStaffRole { doctor, receptionist, reportist }

extension HospitalStaffRoleX on HospitalStaffRole {
  String get label {
    switch (this) {
      case HospitalStaffRole.doctor:       return 'Doctor';
      case HospitalStaffRole.receptionist: return 'Receptionist';
      case HospitalStaffRole.reportist:    return 'Reportist';
    }
  }

  Color get color {
    switch (this) {
      case HospitalStaffRole.doctor:       return const Color(0xFF185FA5);
      case HospitalStaffRole.receptionist: return const Color(0xFF3B6D11);
      case HospitalStaffRole.reportist:    return const Color(0xFF854F0B);
    }
  }

  Color get bgColor {
    switch (this) {
      case HospitalStaffRole.doctor:       return const Color(0xFFE6F1FB);
      case HospitalStaffRole.receptionist: return const Color(0xFFEAF3DE);
      case HospitalStaffRole.reportist:    return const Color(0xFFFAEEDA);
    }
  }

  String get emoji {
    switch (this) {
      case HospitalStaffRole.doctor:       return '👨‍⚕️';
      case HospitalStaffRole.receptionist: return '🗂️';
      case HospitalStaffRole.reportist:    return '🧪';
    }
  }
}

// ── Hospital profile ─────────────────────────────────────
class HospitalProfile {
  String name, tagline, address, city, state, pin;
  String phone, email, website;
  String registrationNo, type;
  List<String> specialities;
  List<String> imageUrls;
  int bedCount;
  String timings;

  HospitalProfile({
    required this.name,
    required this.tagline,
    required this.address,
    required this.city,
    required this.state,
    required this.pin,
    required this.phone,
    required this.email,
    required this.website,
    required this.registrationNo,
    required this.type,
    required this.specialities,
    required this.imageUrls,
    required this.bedCount,
    required this.timings,
  });
}

// ── Analytics ─────────────────────────────────────────────
class DailyStats {
  final String date;
  final int totalOps, newPatients, discharged, revenue;
  const DailyStats({
    required this.date,
    required this.totalOps,
    required this.newPatients,
    required this.discharged,
    required this.revenue,
  });
}

// ── Mock data ─────────────────────────────────────────────
class HospitalMockData {
  static HospitalProfile get hospital => HospitalProfile(
    name: 'AyurVanta General Hospital',
    tagline: 'Healing with care, advancing with technology',
    address: '123 Main Road, Near Bus Stand',
    city: 'Mācherla',
    state: 'Andhra Pradesh',
    pin: '522426',
    phone: '+91 98765 43210',
    email: 'admin@ayurvantahospital.in',
    website: 'www.ayurvantahospital.in',
    registrationNo: 'HRAP2019001234',
    type: 'Multi-Specialty',
    specialities: ['Cardiology', 'Orthopaedics', 'Paediatrics',
      'Gynaecology', 'General Medicine', 'Neurology'],
    imageUrls: [],
    bedCount: 120,
    timings: '24/7 Emergency | OPD: 8AM – 8PM',
  );

  static List<StaffMember> get staff => [
    const StaffMember(
      id: 's1', name: 'Dr. Ramesh Babu', empId: 'EMP-D-001',
      email: 'ramesh@ayurvantahospital.in', phone: '+91 98001 11111',
      specialization: 'General Medicine', role: HospitalStaffRole.doctor,
      joinDate: '01 Jan 2022',
    ),
    const StaffMember(
      id: 's2', name: 'Dr. Kavitha Reddy', empId: 'EMP-D-002',
      email: 'kavitha@ayurvantahospital.in', phone: '+91 98001 22222',
      specialization: 'Paediatrics', role: HospitalStaffRole.doctor,
      joinDate: '15 Mar 2021',
    ),
    const StaffMember(
      id: 's3', name: 'Dr. Suresh Kumar', empId: 'EMP-D-003',
      email: 'suresh@ayurvantahospital.in', phone: '+91 98001 33333',
      specialization: 'Cardiology', role: HospitalStaffRole.doctor,
      joinDate: '10 Jun 2020',
    ),
    const StaffMember(
      id: 's4', name: 'Priya Sharma', empId: 'EMP-R-001',
      email: 'priya@ayurvantahospital.in', phone: '+91 98001 44444',
      specialization: 'Front Desk', role: HospitalStaffRole.receptionist,
      joinDate: '20 Feb 2023',
    ),
    const StaffMember(
      id: 's5', name: 'Anand Rao', empId: 'EMP-R-002',
      email: 'anand@ayurvantahospital.in', phone: '+91 98001 55555',
      specialization: 'Lab Technician', role: HospitalStaffRole.reportist,
      joinDate: '05 Aug 2022',
    ),
    const StaffMember(
      id: 's6', name: 'Meena Devi', empId: 'EMP-R-003',
      email: 'meena@ayurvantahospital.in', phone: '+91 98001 66666',
      specialization: 'Radiology', role: HospitalStaffRole.reportist,
      joinDate: '12 Nov 2023',
    ),
  ];

  static List<DailyStats> get weekStats => [
    const DailyStats(date: 'Mon', totalOps: 42, newPatients: 18, discharged: 15, revenue: 38400),
    const DailyStats(date: 'Tue', totalOps: 56, newPatients: 24, discharged: 22, revenue: 52000),
    const DailyStats(date: 'Wed', totalOps: 38, newPatients: 12, discharged: 10, revenue: 31200),
    const DailyStats(date: 'Thu', totalOps: 61, newPatients: 30, discharged: 28, revenue: 58800),
    const DailyStats(date: 'Fri', totalOps: 74, newPatients: 35, discharged: 31, revenue: 70500),
    const DailyStats(date: 'Sat', totalOps: 88, newPatients: 42, discharged: 40, revenue: 85200),
    const DailyStats(date: 'Sun', totalOps: 33, newPatients: 10, discharged: 9, revenue: 27600),
  ];
}