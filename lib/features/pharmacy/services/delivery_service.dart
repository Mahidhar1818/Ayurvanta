import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/delivery_models.dart';
import '../../../core/services/api_service.dart';

class DeliveryService {
  final ApiService _apiService;

  DeliveryService() : _apiService = ApiService();

  // Session state for Demo
  static bool _currentAvailability = false;
  static final List<DeliveryOrder> _demoAvailableOrders = [
    DeliveryOrder(
      id: 'demo_ord_1',
      orderId: 'RX-88291',
      customerId: 'cust_001',
      customerName: 'Arjun Sharma',
      customerPhone: '9876543210',
      customerAddress: 'Flat 402, Green Heights, Hitech City',
      customerLocation: const LatLng(17.4486, 78.3908),
      items: [
        DeliveryOrderItem(id: 'i1', name: 'Amoxicillin 500mg', quantity: 1, price: 120, image: ''),
        DeliveryOrderItem(id: 'i2', name: 'Paracetamol 650mg', quantity: 2, price: 30, image: ''),
      ],
      totalAmount: 180,
      deliveryFee: 45,
      paymentMethod: 'Prepaid',
      orderStatus: 'pending',
      orderTime: DateTime.now(),
      storeName: 'Apollo Pharmacy',
      storeLocation: const LatLng(17.4448, 78.3748),
      isCod: false,
      otpCode: '123456',
    ),
  ];

  static final List<DeliveryOrder> _demoActiveOrders = [];
  static final List<DeliveryOrder> _demoCompletedOrders = [];

  Future<DeliveryPartner?> loginDeliveryPartner(Map<String, dynamic> credentials) async {
    return DeliveryPartner(
      id: 'p_001',
      deliveryPartnerId: 'AYURDEL001',
      name: 'Rajesh Kumar',
      phoneNumber: '9988776655',
      email: 'rajesh@ayurvanta.com',
      vehicleType: 'Bike',
      vehicleNumber: 'TS 09 EZ 1234',
      profileImage: '',
      isAvailable: _currentAvailability,
      rating: 4.9,
      totalDeliveries: 124,
      currentLocation: const LatLng(17.4400, 78.3800),
      status: _currentAvailability ? 'online' : 'offline',
      joinedDate: DateTime.now(),
      deliveryZones: ['Hitech City'],
    );
  }

  Future<List<DeliveryOrder>> getAvailableOrders() async {
    return _demoAvailableOrders;
  }

  Future<List<DeliveryOrder>> getActiveOrders(String partnerId) async {
    return _demoActiveOrders;
  }

  Future<List<DeliveryOrder>> getCompletedOrders(String partnerId) async {
    return _demoCompletedOrders;
  }

  Future<bool> acceptOrder(String orderId, String partnerId) async {
    final index = _demoAvailableOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = _demoAvailableOrders.removeAt(index);
      _demoActiveOrders.add(order);
    }
    return true;
  }

  Future<bool> updateOrderStatus(String orderId, String status, String partnerId) async {
    if (status == 'delivered') {
      final index = _demoActiveOrders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        final order = _demoActiveOrders.removeAt(index);
        _demoCompletedOrders.add(order);
      }
    }
    return true;
  }

  Future<bool> setAvailability(String partnerId, bool isAvailable) async {
    _currentAvailability = isAvailable;
    return true;
  }
}
