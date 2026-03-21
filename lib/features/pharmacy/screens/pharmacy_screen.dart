import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../models/medicine_model.dart';
import '../widgets/medicine_card.dart';
import '../widgets/order_card.dart';
import '../widgets/cart_sheet.dart';
import 'upload_rx_screen.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});
  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _query         = '';
  String _selectedCat   = 'All';
  final Set<String> _cart = {};

  final _medicines = const [
    MedicineModel(
      id: '1', name: 'Amlodipine 5mg', brand: 'Norvasc',
      pack: 'Strip of 10', emoji: '💊',
      price: 48, originalPrice: 62,
      requiresPrescription: true, category: 'Cardiac',
    ),
    MedicineModel(
      id: '2', name: 'Atorvastatin 10mg', brand: 'Lipitor',
      pack: 'Strip of 10', emoji: '💊',
      price: 85, originalPrice: 110,
      requiresPrescription: true, category: 'Cardiac',
    ),
    MedicineModel(
      id: '3', name: 'Aspirin 75mg', brand: 'Ecosprin',
      pack: 'Strip of 14', emoji: '💊',
      price: 22, originalPrice: 30,
      requiresPrescription: true, category: 'Cardiac',
    ),
    MedicineModel(
      id: '4', name: 'Vitamin D3 1000IU', brand: 'HealthVit',
      pack: '60 tablets', emoji: '🧴',
      price: 199, originalPrice: 249,
      requiresPrescription: false, category: 'Vitamins',
    ),
    MedicineModel(
      id: '5', name: 'Metformin 500mg', brand: 'Glucophage',
      pack: 'Strip of 10', emoji: '💊',
      price: 35, originalPrice: 45,
      requiresPrescription: true, category: 'Diabetes',
    ),
    MedicineModel(
      id: '6', name: 'Cetirizine 10mg', brand: 'Zyrtec',
      pack: 'Strip of 10', emoji: '💊',
      price: 28, originalPrice: 38,
      requiresPrescription: false, category: 'Allergy',
    ),
  ];

  final _orders = const [
    OrderModel(
      id: '1', orderNumber: 'AYR-8821', date: 'Mar 15, 2026',
      totalAmount: 155,
      medicines: ['Amlodipine 5mg', 'Aspirin 75mg', 'Vitamin D3'],
      status: OrderStatus.delivered,
    ),
    OrderModel(
      id: '2', orderNumber: 'AYR-9043', date: 'Mar 20, 2026',
      totalAmount: 107,
      medicines: ['Atorvastatin 10mg', 'Metformin 500mg'],
      status: OrderStatus.shipped,
    ),
  ];

  static const _categories = [
    'All', 'Cardiac', 'Diabetes', 'Skin', 'Vitamins', 'Allergy',
  ];

  static const _catIcons = {
    'All': '💊', 'Cardiac': '❤️', 'Diabetes': '🩸',
    'Skin': '🧴', 'Vitamins': '🧘', 'Allergy': '🤧',
  };

  List<MedicineModel> get _filtered => _medicines.where((m) {
    final matchCat = _selectedCat == 'All' ||
        m.category == _selectedCat;
    final matchQ = m.name.toLowerCase()
        .contains(_query.toLowerCase()) ||
        m.brand.toLowerCase().contains(_query.toLowerCase());
    return matchCat && matchQ;
  }).toList();

  int get _cartTotal => _cart.fold(0, (sum, id) {
    final m = _medicines.firstWhere((m) => m.id == id,
        orElse: () => _medicines.first);
    return sum + m.price;
  });

  void _toggleCart(String id) =>
      setState(() => _cart.contains(id)
          ? _cart.remove(id) : _cart.add(id));

  void _openCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CartSheet(
        cartIds: _cart.toList(),
        medicines: _medicines,
        onRemove: (id) {
          setState(() => _cart.remove(id));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _TopBar(
            cartCount: _cart.length,
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v),
            tabController: _tabController,
            onCartTap: _openCart,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ShopTab(
                  medicines: _filtered,
                  categories: _categories,
                  catIcons: _catIcons,
                  selectedCat: _selectedCat,
                  onCatSelect: (c) =>
                      setState(() => _selectedCat = c),
                  cart: _cart,
                  onToggleCart: _toggleCart,
                ),
                _OrdersTab(orders: _orders),
                const UploadRxScreen(isEmbedded: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Top Bar ──────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final int cartCount;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TabController tabController;
  final VoidCallback onCartTap;

  const _TopBar({
    required this.cartCount,
    required this.controller,
    required this.onChanged,
    required this.tabController,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Pharmacy',
                  style: TextStyle(color: Colors.white,
                      fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              GestureDetector(
                onTap: onCartTap,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.shopping_cart_outlined,
                              color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text('Cart',
                            style: TextStyle(color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    if (cartCount > 0)
                      Positioned(
                        top: -6, right: -6,
                        child: Container(
                          width: 18, height: 18,
                          decoration: const BoxDecoration(
                            color: AppColors.emergency,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('$cartCount',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.search,
                    color: AppColors.textHint, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Search medicines, vitamins…',
                      hintStyle: TextStyle(
                          color: AppColors.textHint, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TabBar(
            controller: tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppColors.blue,
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700),
            padding: const EdgeInsets.all(4),
            overlayColor:
                MaterialStateProperty.all(Colors.transparent),
            tabs: const [
              Tab(text: 'Shop'),
              Tab(text: 'My Orders'),
              Tab(text: 'Upload Rx'),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shop Tab ─────────────────────────────────────────────
class _ShopTab extends StatelessWidget {
  final List<MedicineModel> medicines;
  final List<String> categories;
  final Map<String, String> catIcons;
  final String selectedCat;
  final ValueChanged<String> onCatSelect;
  final Set<String> cart;
  final ValueChanged<String> onToggleCart;

  const _ShopTab({
    required this.medicines,
    required this.categories,
    required this.catIcons,
    required this.selectedCat,
    required this.onCatSelect,
    required this.cart,
    required this.onToggleCart,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upload Rx Banner
          FadeInDown(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.teal,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Upload Prescription',
                            style: TextStyle(color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                          SizedBox(height: 4),
                          Text('Get medicines delivered in 2 hrs',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12)),
                        ],
                      ),
                    ),
                    Text('💊',
                        style: TextStyle(fontSize: 36)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Categories
          const Text('Categories',
            style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          SizedBox(
            height: 70,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = categories[i];
                final isActive = cat == selectedCat;
                return GestureDetector(
                  onTap: () => onCatSelect(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.blueLight
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive
                            ? AppColors.blue
                            : const Color(0xFFE3EAF2),
                        width: isActive ? 1 : 0.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(catIcons[cat] ?? '💊',
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(cat,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isActive
                                ? AppColors.blue
                                : AppColors.navyLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Medicines grid
          const Text('Your Prescribed Medicines',
            style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemCount: medicines.length,
            itemBuilder: (_, i) => FadeInUp(
              delay: Duration(milliseconds: i * 60),
              child: MedicineCard(
                medicine: medicines[i],
                inCart: cart.contains(medicines[i].id),
                onToggle: () => onToggleCart(medicines[i].id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Orders Tab ───────────────────────────────────────────
class _OrdersTab extends StatelessWidget {
  final List<OrderModel> orders;
  const _OrdersTab({required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: i * 80),
        child: OrderCard(order: orders[i]),
      ),
    );
  }
}
