import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/translations/tr_extension.dart';
import '../../../core/services/medicine_api_service.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class MedicineCatalogScreen extends StatefulWidget {
  const MedicineCatalogScreen({super.key});
  @override
  State<MedicineCatalogScreen> createState() =>
      _MedicineCatalogScreenState();
}

class _MedicineCatalogScreenState
    extends State<MedicineCatalogScreen> {
  final _searchCtrl = TextEditingController();
  String _query       = '';
  String _selectedCat = 'All';
  bool   _isLoading   = false;
  List<MedicineModel> _medicines = [];

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    setState(() => _isLoading = true);
    await Future.delayed(
        const Duration(milliseconds: 500));
    setState(() {
      _medicines = MedicineApiService.getAll();
      _isLoading = false;
    });
  }

  Future<void> _search(String q) async {
    setState(() { _query = q; _isLoading = true; });
    if (q.length > 2) {
      final results =
          await MedicineApiService.searchMedicines(q);
      setState(() {
        _medicines = results;
        _isLoading = false;
      });
    } else {
      setState(() {
        _medicines = _selectedCat == 'All'
            ? MedicineApiService.getAll()
            : MedicineApiService.byCategory(
                _selectedCat);
        _isLoading = false;
      });
    }
  }

  List<MedicineModel> get _filtered {
    if (_selectedCat == 'All') return _medicines;
    return _medicines
        .where((m) => m.category == _selectedCat)
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildTopBar(cart),
          _buildCategoryChips(),
          Expanded(
            child: _isLoading
                ? _buildShimmer()
                : _filtered.isEmpty
                    ? _buildEmpty()
                    : _buildMedicineList(cart),
          ),
        ],
      ),
      floatingActionButton: cart.items.isNotEmpty
          ? _buildCartFab(cart, context)
          : null,
    );
  }

  Widget _buildTopBar(CartProvider cart) {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 14, right: 14, bottom: 14,
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (Navigator.canPop(context)) ...[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 16),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              const Expanded(
                child: Text('Medicine Store',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  )),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const CartScreen())),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white, size: 20),
                    ),
                    if (cart.items.isNotEmpty)
                      Positioned(
                        top: -5, right: -5,
                        child: Container(
                          width: 18, height: 18,
                          decoration: const BoxDecoration(
                            color: AppColors.emergency,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${cart.items.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight:
                                    FontWeight.w800,
                              )),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12),
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
                    controller: _searchCtrl,
                    onChanged: _search,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13),
                    decoration: const InputDecoration(
                      hintText:
                          'Search 40+ medicines...',
                      hintStyle: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets
                          .symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 44,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
          vertical: 6, horizontal: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: MedicineApiService.categories.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 7),
        itemBuilder: (_, i) {
          final cat = MedicineApiService.categories[i];
          final isActive = cat == _selectedCat;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCat = cat;
                _medicines = cat == 'All'
                    ? MedicineApiService.getAll()
                    : MedicineApiService.byCategory(
                        cat);
              });
            },
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.blue
                    : const Color(0xFFF4F7FB),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? AppColors.blue
                      : const Color(0xFFE3EAF2),
                  width: 0.5,
                ),
              ),
              child: Text(cat,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isActive
                      ? Colors.white
                      : AppColors.navyLight,
                )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMedicineList(CartProvider cart) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
          14, 10, 14, 100),
      itemCount: _filtered.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: i * 30),
        child: _MedicineCard(
          medicine: _filtered[i],
          cart: cart,
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xFFE3EAF2),
        highlightColor: Colors.white,
        child: Container(
          height: 90,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.medication_outlined,
              size: 48, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text('No medicines found for "$_query"',
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCartFab(
      CartProvider cart, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(
            builder: (_) => const CartScreen())),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.teal,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.teal.withOpacity(0.3),
              blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_cart_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              '${cart.itemCount} items · ₹${cart.total}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              )),
            const SizedBox(width: 8),
            const Text('→',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

// ── Medicine Card ────────────────────────────────────────
class _MedicineCard extends StatelessWidget {
  final MedicineModel medicine;
  final CartProvider cart;
  const _MedicineCard(
      {required this.medicine, required this.cart});

  @override
  Widget build(BuildContext context) {
    final inCart = cart.contains(medicine.id);
    final qty    = cart.getQuantity(medicine.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: inCart
              ? AppColors.blue
              : const Color(0xFFE3EAF2),
          width: inCart ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: AppColors.blueLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(medicine.emoji,
                  style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(medicine.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  )),
                const SizedBox(height: 2),
                Text(medicine.genericName,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary)),
                Text(
                  '${medicine.manufacturer} · ${medicine.dosageForm}',
                  style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textHint)),
                if (medicine.requiresPrescription)
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAEEDA),
                      borderRadius:
                          BorderRadius.circular(5),
                    ),
                    child: const Text('Rx Required',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF854F0B),
                      )),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${medicine.price}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.blue,
                )),
              Row(
                children: [
                  Text('₹${medicine.mrp}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textHint,
                      decoration:
                          TextDecoration.lineThrough,
                    )),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3DE),
                      borderRadius:
                          BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${medicine.discount}% off',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B6D11),
                      )),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              inCart
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _QtyBtn(
                          icon: Icons.remove_rounded,
                          onTap: () =>
                              cart.decrement(medicine.id),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 8),
                          child: Text('$qty',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.blue,
                            )),
                        ),
                        _QtyBtn(
                          icon: Icons.add_rounded,
                          onTap: () =>
                              cart.increment(medicine),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () =>
                          cart.addItem(medicine),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.blueLight,
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        child: const Text('+ Add',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.blue,
                          )),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn(
      {required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26, height: 26,
        decoration: BoxDecoration(
          color: AppColors.blueLight,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon,
            size: 14, color: AppColors.blue),
      ),
    );
  }
}
