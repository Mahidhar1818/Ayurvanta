enum OPStatus { waiting, withDoctor, inLab, billing, completed, cancelled }
enum PaymentStatus { pending, partial, paid }

extension OPStatusX on OPStatus {
  String get label {
    switch (this) {
      case OPStatus.waiting:    return 'Waiting';
      case OPStatus.withDoctor: return 'With Doctor';
      case OPStatus.inLab:      return 'In Lab';
      case OPStatus.billing:    return 'Billing';
      case OPStatus.completed:  return 'Completed';
      case OPStatus.cancelled:  return 'Cancelled';
    }
  }
}

class OPRecord {
  final String id, patientName, ayurId, phone, age, gender;
  final String tokenNo, timeSlot;
  OPStatus status;
  String? assignedDoctorId, assignedDoctorName;
  double consultFee, reportFee, medicineFee, totalBill;
  PaymentStatus paymentStatus;
  String? description, diagnosis;
  List<String> prescribedTests;
  List<PrescriptionItem> medicines;

  OPRecord({
    required this.id,
    required this.patientName,
    required this.ayurId,
    required this.phone,
    required this.age,
    required this.gender,
    required this.tokenNo,
    required this.timeSlot,
    this.status = OPStatus.waiting,
    this.assignedDoctorId,
    this.assignedDoctorName,
    this.consultFee = 300,
    this.reportFee = 0,
    this.medicineFee = 0,
    this.totalBill = 300,
    this.paymentStatus = PaymentStatus.pending,
    this.description,
    this.diagnosis,
    this.prescribedTests = const [],
    this.medicines = const [],
  });
}

class PrescriptionItem {
  final String name, dosage, duration, timing;
  const PrescriptionItem({
    required this.name,
    required this.dosage,
    required this.duration,
    required this.timing,
  });
}

List<OPRecord> mockOPs = [
  OPRecord(
    id: 'op1', patientName: 'Ravi Teja', ayurId: 'AYR2024001',
    phone: '9876500001', age: '34', gender: 'Male',
    tokenNo: 'T-001', timeSlot: '09:00 AM',
    status: OPStatus.completed, assignedDoctorName: 'Dr. Ramesh Babu',
    consultFee: 300, totalBill: 850, paymentStatus: PaymentStatus.paid,
  ),
  OPRecord(
    id: 'op2', patientName: 'Lakshmi Devi', ayurId: 'AYR2024002',
    phone: '9876500002', age: '28', gender: 'Female',
    tokenNo: 'T-002', timeSlot: '09:30 AM',
    status: OPStatus.withDoctor, assignedDoctorName: 'Dr. Kavitha Reddy',
    consultFee: 300, totalBill: 300, paymentStatus: PaymentStatus.pending,
  ),
  OPRecord(
    id: 'op3', patientName: 'Gopal Rao', ayurId: 'AYR2024003',
    phone: '9876500003', age: '55', gender: 'Male',
    tokenNo: 'T-003', timeSlot: '10:00 AM',
    status: OPStatus.inLab, assignedDoctorName: 'Dr. Suresh Kumar',
    consultFee: 500, reportFee: 1200, totalBill: 1700,
    paymentStatus: PaymentStatus.partial,
    prescribedTests: ['CBC', 'Lipid Profile', 'ECG'],
  ),
  OPRecord(
    id: 'op4', patientName: 'Sunitha Reddy', ayurId: 'AYR2024004',
    phone: '9876500004', age: '41', gender: 'Female',
    tokenNo: 'T-004', timeSlot: '10:30 AM',
    status: OPStatus.waiting,
    consultFee: 300, totalBill: 300, paymentStatus: PaymentStatus.pending,
  ),
  OPRecord(
    id: 'op5', patientName: 'Mohan Das', ayurId: 'AYR2024005',
    phone: '9876500005', age: '62', gender: 'Male',
    tokenNo: 'T-005', timeSlot: '11:00 AM',
    status: OPStatus.billing, assignedDoctorName: 'Dr. Ramesh Babu',
    consultFee: 300, reportFee: 600, medicineFee: 450, totalBill: 1350,
    paymentStatus: PaymentStatus.pending,
  ),
];