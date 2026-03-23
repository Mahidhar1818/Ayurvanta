import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/hospital_model.dart';
import '../core/services/api_service.dart';

class HospitalService {
  final ApiService _apiService;
  
  HospitalService() : _apiService = ApiService();
  
  Future<List<Hospital>> getHospitalsBySpecialization(String? specialization) async {
    try {
      String endpoint = '/hospitals/';
      if (specialization != null) {
        endpoint += '?specialization=$specialization';
      }
      
      final response = await _apiService.get(endpoint);
      if (response.data['success']) {
        final List<dynamic> hospitalsJson = response.data['data'];
        return hospitalsJson.map((json) => Hospital.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to load hospitals');
    } catch (e) {
      throw Exception('Error loading hospitals: $e');
    }
  }
  
  Future<Map<String, dynamic>> bookEmergencyAppointment({
    required String hospitalId,
    required String patientId,
    required String symptoms,
    required String condition,
    required String location,
    required String notes,
  }) async {
    try {
      final response = await _apiService.post('/emergency/book/', data: {
        'hospital_id': hospitalId,
        'patient_id': patientId,
        'symptoms': symptoms,
        'condition': condition,
        'location': location,
        'notes': notes,
        'booking_type': 'emergency',
      });
      
      if (response.data['success']) {
        return response.data['data'];
      }
      throw Exception(response.data['message'] ?? 'Failed to book emergency appointment');
    } catch (e) {
      throw Exception('Error booking emergency: $e');
    }
  }
  
  Future<Map<String, dynamic>> getHospitalETA(String hospitalId, LatLng currentLocation) async {
    try {
      final response = await _apiService.post('/hospitals/eta/', data: {
        'hospital_id': hospitalId,
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
      });
      
      if (response.data['success']) {
        return response.data['data'];
      }
      throw Exception('Failed to calculate ETA');
    } catch (e) {
      throw Exception('Error calculating ETA: $e');
    }
  }
}
