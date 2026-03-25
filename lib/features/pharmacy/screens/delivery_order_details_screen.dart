import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import '../models/delivery_models.dart';
import '../services/delivery_service.dart';
import '../../../core/widgets/loading_widget.dart';

class DeliveryOrderDetailsScreen extends StatefulWidget {
  final DeliveryOrder order;
  final DeliveryPartner partner;
  final VoidCallback onOrderUpdated;

  const DeliveryOrderDetailsScreen({
    Key? key,
    required this.order,
    required this.partner,
    required this.onOrderUpdated,
  }) : super(key: key);

  @override
  _DeliveryOrderDetailsScreenState createState() => _DeliveryOrderDetailsScreenState();
}

class _DeliveryOrderDetailsScreenState extends State<DeliveryOrderDetailsScreen> {
  final DeliveryService _deliveryService = DeliveryService();
  bool _isLoading = false;
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  final Set<Marker> _markers = {};
  String _currentStatus = '';

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.orderStatus;
    _initLocation();
  }

  void _initLocation() {
    setState(() {
      _currentLocation = widget.partner.currentLocation;
      _addMarkers();
    });
  }

  void _addMarkers() {
    _markers.clear();
    
    // Store marker
    if (widget.order.storeLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('store'),
          position: widget.order.storeLocation!,
          infoWindow: InfoWindow(
            title: widget.order.storeName ?? 'Store',
            snippet: 'Pickup Location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }
    
    // Customer marker
    _markers.add(
      Marker(
        markerId: const MarkerId('customer'),
        position: widget.order.customerLocation,
        infoWindow: InfoWindow(
          title: widget.order.customerName,
          snippet: widget.order.customerAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    
    _updateMarker();
  }

  void _updateMarker() {
    if (_currentLocation != null) {
      _markers.remove(const MarkerId('partner'));
      _markers.add(
        Marker(
          markerId: const MarkerId('partner'),
          position: _currentLocation!,
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Delivery Partner',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  void _animateCamera() {
    if (_mapController != null && _currentLocation != null) {
      final bounds = LatLngBounds(
        southwest: LatLng(
          min(_currentLocation!.latitude, widget.order.customerLocation.latitude),
          min(_currentLocation!.longitude, widget.order.customerLocation.longitude),
        ),
        northeast: LatLng(
          max(_currentLocation!.latitude, widget.order.customerLocation.latitude),
          max(_currentLocation!.longitude, widget.order.customerLocation.longitude),
        ),
      );
      
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  Future<void> _updateOrderStatus(String status) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final updated = await _deliveryService.updateOrderStatus(
        widget.order.id,
        status,
        widget.partner.id,
      );
      
      if (updated) {
        setState(() {
          _currentStatus = status;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order status updated to ${_getStatusText(status)}'),
              backgroundColor: Colors.green,
            ),
          );
        }
        
        widget.onOrderUpdated();
        
        if (status == 'delivered' && mounted) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'accepted': return 'Accepted';
      case 'picked_up': return 'Picked Up';
      case 'in_transit': return 'In Transit';
      case 'delivered': return 'Delivered';
      default: return status;
    }
  }

  Future<void> _callCustomer() async {
    final Uri callUri = Uri(scheme: 'tel', path: widget.order.customerPhone);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    }
  }

  Future<void> _sendMessage() async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: widget.order.customerPhone,
      queryParameters: {'body': 'Hello, I am your delivery partner for order ${widget.order.orderId}. I will be there shortly.'},
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

  void _verifyOTP() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Delivery'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter the OTP provided by the customer:'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter 6-digit OTP',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value == widget.order.otpCode) {
                  Navigator.pop(context);
                  _updateOrderStatus('delivered');
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.order.orderId}'),
        backgroundColor: const Color(0xFFFF6B6B),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: _callCustomer,
            tooltip: 'Call Customer',
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: _sendMessage,
            tooltip: 'Message Customer',
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : Column(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildMap(),
                ),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusStepper(),
                        const SizedBox(height: 20),
                        _buildCustomerDetails(),
                        const SizedBox(height: 20),
                        _buildOrderItems(),
                        const SizedBox(height: 20),
                        _buildPaymentDetails(),
                        const SizedBox(height: 20),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMap() {
    if (_currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.order.customerLocation,
        zoom: 14,
      ),
      markers: _markers,
      onMapCreated: (controller) {
        _mapController = controller;
        _animateCamera();
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }

  Widget _buildStatusStepper() {
    final statuses = ['accepted', 'picked_up', 'in_transit', 'delivered'];
    final currentIndex = statuses.indexOf(_currentStatus);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStep(0, 'Accepted', currentIndex >= 0),
              Expanded(child: _buildConnector(currentIndex >= 1)),
              _buildStep(1, 'Picked Up', currentIndex >= 1),
              Expanded(child: _buildConnector(currentIndex >= 2)),
              _buildStep(2, 'In Transit', currentIndex >= 2),
              Expanded(child: _buildConnector(currentIndex >= 3)),
              _buildStep(3, 'Delivered', currentIndex >= 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int index, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFFFF6B6B) : Colors.grey[300],
          ),
          child: Center(
            child: Icon(
              isActive ? Icons.check : Icons.circle_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? const Color(0xFFFF6B6B) : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildConnector(bool isActive) {
    return Container(
      height: 2,
      color: isActive ? const Color(0xFFFF6B6B) : Colors.grey[300],
    );
  }

  Widget _buildCustomerDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person, color: Color(0xFFFF6B6B)),
              SizedBox(width: 8),
              Text(
                'Customer Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.1),
              child: const Icon(Icons.person, color: Color(0xFFFF6B6B)),
            ),
            title: Text(widget.order.customerName),
            subtitle: Text(widget.order.customerPhone),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.1),
              child: const Icon(Icons.location_on, color: Color(0xFFFF6B6B)),
            ),
            title: const Text('Delivery Address'),
            subtitle: Text(widget.order.customerAddress),
          ),
          if (widget.order.specialInstructions != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.order.specialInstructions!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItems() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shopping_bag, color: Color(0xFFFF6B6B)),
              SizedBox(width: 8),
              Text(
                'Order Items',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...widget.order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      image: item.image.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(item.image),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: item.image.isEmpty
                        ? const Icon(Icons.medication, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Qty: ${item.quantity}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B6B),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.payment, color: Color(0xFFFF6B6B)),
              SizedBox(width: 8),
              Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPaymentRow('Subtotal', '₹${widget.order.totalAmount.toStringAsFixed(2)}'),
          _buildPaymentRow('Delivery Fee', '₹${widget.order.deliveryFee.toStringAsFixed(2)}'),
          const Divider(),
          _buildPaymentRow(
            'Total',
            '₹${(widget.order.totalAmount + widget.order.deliveryFee).toStringAsFixed(2)}',
            isTotal: true,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.order.isCod ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  widget.order.isCod ? Icons.attach_money : Icons.payment,
                  color: widget.order.isCod ? Colors.orange : Colors.green,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.order.isCod ? 'Cash on Delivery' : 'Prepaid',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.order.isCod ? Colors.orange : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 14 : 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 14 : 12,
              color: isTotal ? const Color(0xFFFF6B6B) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (_currentStatus == 'delivered') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'Order Delivered Successfully',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: [
        if (_currentStatus == 'accepted')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _updateOrderStatus('picked_up'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Mark as Picked Up'),
            ),
          ),
        if (_currentStatus == 'picked_up')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _updateOrderStatus('in_transit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Start Delivery'),
            ),
          ),
        if (_currentStatus == 'in_transit')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Complete Delivery with OTP'),
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _updateOrderStatus('cancelled'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: Colors.red),
          ),
          child: const Text('Report Issue'),
        ),
      ],
    );
  }
}
