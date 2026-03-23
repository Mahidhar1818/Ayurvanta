class Hospital {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> specializations;
  final String emergencyPhone;
  final String receptionPhone;
  final bool hasEmergencyWard;
  final bool hasICU;
  final double? distance;
  final int? rating;
  
  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.specializations,
    required this.emergencyPhone,
    required this.receptionPhone,
    required this.hasEmergencyWard,
    required this.hasICU,
    this.distance,
    this.rating,
  });
  
  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      specializations: List<String>.from(json['specializations'] ?? []),
      emergencyPhone: json['emergency_phone'] ?? '',
      receptionPhone: json['reception_phone'] ?? '',
      hasEmergencyWard: json['has_emergency_ward'] ?? false,
      hasICU: json['has_icu'] ?? false,
      distance: json['distance']?.toDouble(),
      rating: json['rating'],
    );
  }
}
