import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import '../models/delivery_models.dart';
import '../services/delivery_service.dart';
import 'delivery_order_details_screen.dart';

class DeliveryHomeScreen extends StatefulWidget {
  final DeliveryPartner partner;
  const DeliveryHomeScreen({super.key, required this.partner});

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  int _currentIndex = 0;
  bool _isOnline = true;
  List<DeliveryOrder> _availableOrders = [];
  List<DeliveryOrder> _activeOrders = [];
  bool _isLoading = true;
  final DeliveryService _deliveryService = DeliveryService();
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.partner.currentLocation;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final available = await _deliveryService.getAvailableOrders();
      final active = await _deliveryService.getActiveOrders(widget.partner.id);
      setState(() {
        _availableOrders = available;
        _activeOrders = active;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _toggleAvailability() async {
    setState(() => _isOnline = !_isOnline);
    await _deliveryService.setAvailability(widget.partner.id, _isOnline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : IndexedStack(
            index: _currentIndex,
            children: [
              _buildOrdersTab(),
              const Center(child: Text('Earnings Screen')),
              const Center(child: Text('Profile Screen')),
            ],
          ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: const Color(0xFFFF6B6B),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleAvailability,
        backgroundColor: _isOnline ? Colors.red : Colors.green,
        label: Text(_isOnline ? 'Go Offline' : 'Go Online'),
        icon: Icon(_isOnline ? Icons.power_settings_new : Icons.power),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildOrdersTab() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('Welcome, ${widget.partner.name}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            labelColor: Color(0xFFFF6B6B),
            indicatorColor: Color(0xFFFF6B6B),
            tabs: [
              Tab(text: 'Available'),
              Tab(text: 'Active'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList(_availableOrders, true),
            _buildOrderList(_activeOrders, false),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<DeliveryOrder> orders, bool isAvailable) {
    if (orders.isEmpty) {
      return Center(child: Text(isAvailable ? 'No orders available' : 'No active deliveries'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, i) => _buildOrderCard(orders[i], isAvailable),
    );
  }

  Widget _buildOrderCard(DeliveryOrder order, bool isAvailable) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text('Order #${order.orderId}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.person, size: 14), const SizedBox(width: 4), Text(order.customerName)]),
            Row(children: [const Icon(Icons.location_on, size: 14), const SizedBox(width: 4), Expanded(child: Text(order.customerAddress, maxLines: 1, overflow: TextOverflow.ellipsis))]),
            const SizedBox(height: 8),
            Text('₹${order.totalAmount} · ${order.paymentMethod}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        trailing: isAvailable 
          ? ElevatedButton(
              onPressed: () => _acceptOrder(order),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B6B)),
              child: const Text('Accept'),
            )
          : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DeliveryOrderDetailsScreen(order: order, partner: widget.partner))),
      ),
    );
  }

  void _acceptOrder(DeliveryOrder order) async {
    setState(() => _isLoading = true);
    final success = await _deliveryService.acceptOrder(order.id, widget.partner.id);
    if (success) _loadData();
  }
}
