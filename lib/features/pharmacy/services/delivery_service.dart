import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/delivery_models.dart';
import '../../../core/services/api_service.dart';

class DeliveryService {
  final ApiService _apiService;

  DeliveryService() : _apiService = ApiService();

  Future<DeliveryPartner?> loginDeliveryPartner(Map<String, dynamic> credentials) async {
    try {
      final response = await _apiService.post('/delivery/login/', data: credentials);
      if (response.data['success']) {
        return DeliveryPartner.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<List<DeliveryOrder>> getAvailableOrders() async {
    try {
      final response = await _apiService.get('/delivery/available-orders/');
      if (response.data['success']) {
        final List<dynamic> ordersJson = response.data['data'];
        return ordersJson.map((json) => DeliveryOrder.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load available orders: $e');
    }
  }

  Future<List<DeliveryOrder>> getActiveOrders(String partnerId) async {
    try {
      final response = await _apiService.get('/delivery/active-orders/?partner_id=$partnerId');
      if (response.data['success']) {
        final List<dynamic> ordersJson = response.data['data'];
        return ordersJson.map((json) => DeliveryOrder.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load active orders: $e');
    }
  }

  Future<List<DeliveryOrder>> getCompletedOrders(String partnerId) async {
    try {
      final response = await _apiService.get('/delivery/completed-orders/?partner_id=$partnerId');
      if (response.data['success']) {
        final List<dynamic> ordersJson = response.data['data'];
        return ordersJson.map((json) => DeliveryOrder.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load completed orders: $e');
    }
  }

  Future<bool> acceptOrder(String orderId, String partnerId) async {
    try {
      final response = await _apiService.post('/delivery/accept-order/', data: {
        'order_id': orderId,
        'partner_id': partnerId,
      });
      return response.data['success'] ?? false;
    } catch (e) {
      throw Exception('Failed to accept order: $e');
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status, String partnerId) async {
    try {
      final response = await _apiService.post('/delivery/update-status/', data: {
        'order_id': orderId,
        'status': status,
        'partner_id': partnerId,
      });
      return response.data['success'] ?? false;
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<bool> updateLocation(String partnerId, LatLng location) async {
    try {
      final response = await _apiService.post('/delivery/update-location/', data: {
        'partner_id': partnerId,
        'latitude': location.latitude,
        'longitude': location.longitude,
      });
      return response.data['success'] ?? false;
    } catch (e) {
      throw Exception('Failed to update location: $e');
    }
  }

  Future<bool> setAvailability(String partnerId, bool isAvailable) async {
    try {
      final response = await _apiService.post('/delivery/set-availability/', data: {
        'partner_id': partnerId,
        'is_available': isAvailable,
      });
      return response.data['success'] ?? false;
    } catch (e) {
      throw Exception('Failed to update availability: $e');
    }
  }
}
