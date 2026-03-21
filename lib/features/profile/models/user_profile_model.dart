class UserProfileModel {
  final String name, phone, email, ayurId;
  final String dob, bloodGroup, gender;
  final double height, weight;
  final List<String> allergies;
  final bool isAadharVerified;
  final String memberSince;
  final int appointments, records, prescriptions;

  const UserProfileModel({
    required this.name,      required this.phone,
    required this.email,     required this.ayurId,
    required this.dob,       required this.bloodGroup,
    required this.gender,    required this.height,
    required this.weight,    required this.allergies,
    required this.isAadharVerified,
    required this.memberSince,
    required this.appointments,
    required this.records,   required this.prescriptions,
  });
}
