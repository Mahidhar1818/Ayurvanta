import 'package:flutter/material.dart';

class DoctorModel {
  final String id, initials, name, specialty, hospital;
  final double rating;
  final int reviews, experience, fee;
  final Color color;
  final List<String> slots;
  final List<String> bookedSlots;

  const DoctorModel({
    required this.id,
    required this.initials,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.reviews,
    required this.experience,
    required this.fee,
    required this.color,
    required this.slots,
    required this.bookedSlots,
  });
}
