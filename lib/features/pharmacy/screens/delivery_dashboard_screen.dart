import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../models/delivery_models.dart';
import '../services/delivery_service.dart';
import 'delivery_order_details_screen.dart';

class DeliveryDashboardScreen extends StatefulWidget {
  final DeliveryPartner partner;

  const DeliveryDashboardScreen({Key? key, required this.partner}) : super(key: key);

  @override
  _DeliveryDashboardScreenState createState() => _DeliveryDashboardScreenState();
}

class _DeliveryDashboardScreenState extends State<DeliveryDashboardScreen> {
  int _currentIndex = 0;
  bool _isOnline = false;
  List<DeliveryOrder> _availableOrders = [];
  List<DeliveryOrder> _activeOrders = [];
  List<DeliveryOrder> _completedOrders = [];
  bool _isLoading = true;
  final DeliveryService _deliveryService = DeliveryService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final available = await _deliveryService.getAvailableOrders();
      final active = await _deliveryService.getActiveOrders(widget.partner.id);
      final completed = await _deliveryService.getCompletedOrders(widget.partner.id);
      
      setState(() {
        _availableOrders = available;
        _activeOrders = active;
        _completedOrders = completed;
        // In a real app, we'd fetch actual status from the partner object
        _isOnline = widget.partner.isAvailable;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }
  
  Future<void> _toggleAvailability() async {
    setState(() => _isLoading = true);
    try {
      final newState = !_isOnline;
      final success = await _deliveryService.setAvailability(widget.partner.id, newState);
      
      if (success) {
        setState(() {
          _isOnline = newState;
        });
        if (_isOnline) {
          await _loadData();
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: _currentIndex == 0 ? _buildAppBar() : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.hospitalBlue))
          : IndexedStack(
              index: _currentIndex,
              children: [
                _buildOrdersTab(),
                _buildEarningsTab(),
                _buildProfileTab(),
              ],
            ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _currentIndex == 0 ? _buildDutyToggle() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.hospitalBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.medical_services_rounded, color: AppColors.hospitalBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.partner.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              Text(_isOnline ? 'Active Duty • Pharmacy Network' : 'Off-Duty', 
                style: TextStyle(color: _isOnline ? AppColors.medicalGreen : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary), onPressed: () {}),
      ],
    );
  }

  Widget _buildOrdersTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              indicatorColor: AppColors.hospitalBlue,
              labelColor: AppColors.hospitalBlue,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: [
                Tab(text: 'NEW GIGS'),
                Tab(text: 'ACTIVE'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildOrderList(_availableOrders, isNew: true),
                _buildOrderList(_activeOrders, isNew: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<DeliveryOrder> orders, {required bool isNew}) {
    if (!_isOnline && isNew) {
      return _buildOfflineView();
    }
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isNew ? Icons.inbox_outlined : Icons.motorcycle_rounded, size: 64, color: AppColors.bgMuted),
            const SizedBox(height: 16),
            Text(isNew ? 'Searching for medical gigs...' : 'No active prescriptions', 
              style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: orders.length,
      itemBuilder: (context, index) => _buildGigCard(orders[index], isNew),
    );
  }

  Widget _buildGigCard(DeliveryOrder order, bool isNew) {
    return FadeInUp(
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoChip(Icons.timer_outlined, 'Expedited Delivery', AppColors.hospitalBlue),
                      Text('₹${(order.deliveryFee + 15).toStringAsFixed(0)}', 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.medicalGreen)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRouteIndicator(order),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${order.items.length} Medical Items', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('RX-ID: ${order.orderId}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  if (isNew)
                    ElevatedButton(
                      onPressed: () => _acceptOrder(order),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.hospitalBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('ACCEPT GIG', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, color: Colors.white)),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.hospitalBlue),
                      onPressed: () => _goToDetails(order),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteIndicator(DeliveryOrder order) {
    return Row(
      children: [
        Column(
          children: [
            const Icon(Icons.circle, color: AppColors.hospitalBlue, size: 12),
            Container(width: 2, height: 30, color: AppColors.bgMuted),
            const Icon(Icons.location_on, color: AppColors.emergency, size: 16),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order.storeName ?? 'City Pharmacy', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const Text('Pickup Location', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 16),
              Text(order.customerAddress, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const Text('Patient Address', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildDutyToggle() {
    return FadeInUp(
      child: GestureDetector(
        onTap: _toggleAvailability,
        child: Container(
          width: 220,
          height: 60,
          decoration: BoxDecoration(
            color: _isOnline ? Colors.white : AppColors.hospitalBlue,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
            border: Border.all(color: AppColors.hospitalBlue, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_isOnline ? Icons.power_settings_new : Icons.power, 
                color: _isOnline ? AppColors.hospitalBlue : Colors.white),
              const SizedBox(width: 12),
              Text(_isOnline ? 'END SHIFT' : 'START SHIFT', 
                style: TextStyle(color: _isOnline ? AppColors.hospitalBlue : Colors.white, 
                fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfflineView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services_outlined, size: 80, color: AppColors.bgMuted),
          const SizedBox(height: 20),
          const Text('Off-Duty Mode', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          const Text('Go online to receive medical deliveries', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildEarningsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PHARMACY NETWORK EARNINGS', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 8),
          const Text('₹1,240.00', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildStatCard('Prescriptions', '18', Icons.receipt_long_rounded, AppColors.hospitalBlue),
              const SizedBox(width: 12),
              _buildStatCard('Total KM', '64.5', Icons.location_on_rounded, AppColors.medicalGreen),
            ],
          ),
          const SizedBox(height: 24),
          const Text('WEEKLY MILESTONES', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.bgMuted)),
            child: const Center(child: Text('Performance Chart', style: TextStyle(color: AppColors.textHint))),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.bgMuted)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(radius: 50, backgroundColor: AppColors.hospitalBlue, 
            child: Icon(Icons.health_and_safety_rounded, size: 50, color: Colors.white)),
          const SizedBox(height: 16),
          Text(widget.partner.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          const Text('Senior Logistics Executive', style: TextStyle(color: AppColors.hospitalBlue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildProfileItem(Icons.badge_outlined, 'Ayur ID', widget.partner.deliveryPartnerId),
          _buildProfileItem(Icons.motorcycle, 'Registered Vehicle', 'TS 09 EZ 1234'),
          _buildProfileItem(Icons.star_rounded, 'Partner Rating', '4.95 / 5.0'),
          _buildProfileItem(Icons.help_outline_rounded, 'Medical Dispatch Support', 'Priority Helpline'),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
          Text(value, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      selectedItemColor: AppColors.hospitalBlue,
      unselectedItemColor: AppColors.textHint,
      backgroundColor: Colors.white,
      elevation: 20,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.medical_services_rounded), label: 'Duty'),
        BottomNavigationBarItem(icon: Icon(Icons.payments_rounded), label: 'Earnings'),
        BottomNavigationBarItem(icon: Icon(Icons.person_pin_rounded), label: 'Account'),
      ],
    );
  }

  Future<void> _acceptOrder(DeliveryOrder order) async {
    setState(() => _isLoading = true);
    final success = await _deliveryService.acceptOrder(order.id, widget.partner.id);
    if (success) _loadData();
  }

  void _goToDetails(DeliveryOrder order) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => DeliveryOrderDetailsScreen(order: order, partner: widget.partner, onOrderUpdated: _loadData)));
  }
}
