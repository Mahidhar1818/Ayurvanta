class HospitalModel {
  final String id, name, address, distance;
  final double rating;
  final int reviews, consultationFee;
  final List<String> specializations;
  final bool isOpen;
  final String imageEmoji, waitTime;

  const HospitalModel({
    required this.id, required this.name,
    required this.address, required this.distance,
    required this.rating, required this.reviews,
    required this.specializations,
    required this.isOpen,
    required this.consultationFee,
    required this.imageEmoji, required this.waitTime,
  });
}
