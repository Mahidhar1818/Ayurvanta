import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryPartner {
  final String id;
  final String deliveryPartnerId;
  final String name;
  final String phoneNumber;
  final String email;
  final String vehicleType;
  final String vehicleNumber;
  final String profileImage;
  final bool isAvailable;
  final double rating;
  final int totalDeliveries;
  final LatLng currentLocation;
  final String status; // online, offline, busy
  final DateTime joinedDate;
  final List<String> deliveryZones;

  DeliveryPartner({
    required this.id,
    required this.deliveryPartnerId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.profileImage,
    required this.isAvailable,
    required this.rating,
    required this.totalDeliveries,
    required this.currentLocation,
    required this.status,
    required this.joinedDate,
    required this.deliveryZones,
  });

  factory DeliveryPartner.fromJson(Map<String, dynamic> json) {
    return DeliveryPartner(
      id: json['id'] ?? '',
      deliveryPartnerId: json['delivery_partner_id'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      profileImage: json['profile_image'] ?? '',
      isAvailable: json['is_available'] ?? false,
      rating: json['rating']?.toDouble() ?? 0.0,
      totalDeliveries: json['total_deliveries'] ?? 0,
      currentLocation: LatLng(
        json['current_latitude'] ?? 0.0,
        json['current_longitude'] ?? 0.0,
      ),
      status: json['status'] ?? 'offline',
      joinedDate: DateTime.parse(json['joined_date'] ?? DateTime.now().toIso8601String()),
      deliveryZones: List<String>.from(json['delivery_zones'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'delivery_partner_id': deliveryPartnerId,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'profile_image': profileImage,
      'is_available': isAvailable,
      'rating': rating,
      'total_deliveries': totalDeliveries,
      'current_latitude': currentLocation.latitude,
      'current_longitude': currentLocation.longitude,
      'status': status,
      'joined_date': joinedDate.toIso8601String(),
      'delivery_zones': deliveryZones,
    };
  }
}

class DeliveryOrder {
  final String id;
  final String orderId;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final LatLng customerLocation;
  final List<DeliveryOrderItem> items;
  final double totalAmount;
  final double deliveryFee;
  final String paymentMethod;
  final String orderStatus; // pending, accepted, picked_up, in_transit, delivered, cancelled
  final DateTime orderTime;
  final DateTime? pickupTime;
  final DateTime? deliveryTime;
  final String? specialInstructions;
  final String? storeId;
  final String? storeName;
  final LatLng? storeLocation;
  final DeliveryPartner? assignedPartner;
  final String? otpCode;
  final bool isCod;

  DeliveryOrder({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerLocation,
    required this.items,
    required this.totalAmount,
    required this.deliveryFee,
    required this.paymentMethod,
    required this.orderStatus,
    required this.orderTime,
    this.pickupTime,
    this.deliveryTime,
    this.specialInstructions,
    this.storeId,
    this.storeName,
    this.storeLocation,
    this.assignedPartner,
    this.otpCode,
    required this.isCod,
  });

  factory DeliveryOrder.fromJson(Map<String, dynamic> json) {
    return DeliveryOrder(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      customerAddress: json['customer_address'] ?? '',
      customerLocation: LatLng(
        json['customer_latitude'] ?? 0.0,
        json['customer_longitude'] ?? 0.0,
      ),
      items: (json['items'] as List?)
          ?.map((i) => DeliveryOrderItem.fromJson(i))
          .toList() ?? [],
      totalAmount: json['total_amount']?.toDouble() ?? 0.0,
      deliveryFee: json['delivery_fee']?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] ?? '',
      orderStatus: json['order_status'] ?? 'pending',
      orderTime: DateTime.parse(json['order_time'] ?? DateTime.now().toIso8601String()),
      pickupTime: json['pickup_time'] != null 
          ? DateTime.parse(json['pickup_time']) 
          : null,
      deliveryTime: json['delivery_time'] != null 
          ? DateTime.parse(json['delivery_time']) 
          : null,
      specialInstructions: json['special_instructions'],
      storeId: json['store_id'],
      storeName: json['store_name'],
      storeLocation: json['store_latitude'] != null 
          ? LatLng(json['store_latitude'], json['store_longitude'])
          : null,
      assignedPartner: json['assigned_partner'] != null 
          ? DeliveryPartner.fromJson(json['assigned_partner'])
          : null,
      otpCode: json['otp_code'],
      isCod: json['is_cod'] ?? false,
    );
  }
}

class DeliveryOrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String image;
  final String? prescriptionRequired;

  DeliveryOrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
    this.prescriptionRequired,
  });

  factory DeliveryOrderItem.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: json['price']?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      prescriptionRequired: json['prescription_required'],
    );
  }
}

class DeliveryEarnings {
  final double todayEarnings;
  final double thisWeekEarnings;
  final double thisMonthEarnings;
  final double totalEarnings;
  final int todayDeliveries;
  final int thisWeekDeliveries;
  final int thisMonthDeliveries;
  final int totalDeliveries;
  final double rating;

  DeliveryEarnings({
    required this.todayEarnings,
    required this.thisWeekEarnings,
    required this.thisMonthEarnings,
    required this.totalEarnings,
    required this.todayDeliveries,
    required this.thisWeekDeliveries,
    required this.thisMonthDeliveries,
    required this.totalDeliveries,
    required this.rating,
  });

  factory DeliveryEarnings.fromJson(Map<String, dynamic> json) {
    return DeliveryEarnings(
      todayEarnings: json['today_earnings']?.toDouble() ?? 0.0,
      thisWeekEarnings: json['this_week_earnings']?.toDouble() ?? 0.0,
      thisMonthEarnings: json['this_month_earnings']?.toDouble() ?? 0.0,
      totalEarnings: json['total_earnings']?.toDouble() ?? 0.0,
      todayDeliveries: json['today_deliveries'] ?? 0,
      thisWeekDeliveries: json['this_week_deliveries'] ?? 0,
      thisMonthDeliveries: json['this_month_deliveries'] ?? 0,
      totalDeliveries: json['total_deliveries'] ?? 0,
      rating: json['rating']?.toDouble() ?? 0.0,
    );
  }
}

class DeliveryNotification {
  final String id;
  final String type; // new_order, order_accepted, order_picked, order_delivered, customer_message
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;
  final Map<String, dynamic>? data;

  DeliveryNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    this.data,
  });

  factory DeliveryNotification.fromJson(Map<String, dynamic> json) {
    return DeliveryNotification(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      time: DateTime.parse(json['time'] ?? DateTime.now().toIso8601String()),
      isRead: json['is_read'] ?? false,
      data: json['data'],
    );
  }
}
