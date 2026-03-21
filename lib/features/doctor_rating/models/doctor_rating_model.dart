import 'package:flutter/material.dart';

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final String imageInitials;
  final Color color;
  double averageRating;
  int totalReviews;
  List<Review> reviews;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.imageInitials,
    required this.color,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.reviews = const [],
  });

  void updateRating() {
    if (reviews.isEmpty) {
      averageRating = 0.0;
      totalReviews = 0;
    } else {
      totalReviews = reviews.length;
      averageRating =
          reviews.map((r) => r.rating).reduce((a, b) => a + b) / totalReviews;
    }
  }
}

class Review {
  final String id;
  final String doctorId;
  final String patientName;
  final String patientId;
  final double rating;
  final String feedback;
  final List<String> tags;
  final DateTime date;
  final bool anonymous;

  Review({
    required this.id,
    required this.doctorId,
    required this.patientName,
    required this.patientId,
    required this.rating,
    required this.feedback,
    required this.tags,
    required this.date,
    required this.anonymous,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctorId': doctorId,
        'patientName': anonymous ? 'Anonymous' : patientName,
        'patientId': patientId,
        'rating': rating,
        'feedback': feedback,
        'tags': tags,
        'date': date.toIso8601String(),
        'anonymous': anonymous,
      };
}

class DoctorRanking {
  final String specialty;
  final List<Doctor> doctors;
  final int totalDoctors;
  final double averageSpecialtyRating;

  DoctorRanking({
    required this.specialty,
    required this.doctors,
    required this.totalDoctors,
    required this.averageSpecialtyRating,
  });
}
