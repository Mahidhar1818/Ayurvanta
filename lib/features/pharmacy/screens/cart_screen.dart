import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/razorpay_service.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() =>
      _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late RazorpayService _rzp;
  bool _isPaying = false;
  bool _isPaid   = false;

  @override
  void initState() {
    super.initState();
    _rzp = RazorpayService(
      onSuccess: (id) {
        setState(() {
          _isPaying = false;
          _isPaid   = true;
        });
        Provider.of<CartProvider>(
            context, listen: false).clear();
        _showSuccess(id);
      },
      onFailure: (err) {
        setState(() => _isPaying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $err'),
            backgroundColor: AppColors.emergency),
        );
      },
      onExternalWallet: () =>
          setState(() => _isPaying = false),
    );
  }

  void _pay() {
    final cart =
        Provider.of<CartProvider>(context, listen: false);
    setState(() => _isPaying = true);
    _rzp.openCheckout(
      amountInPaise: cart.total * 100,
      description:
          'AyurVanta Medicines · ${cart.items.length} items',
      userName: 'Arjun Sharma',
      userEmail: 'arjun@ayurvanta.in',
      userPhone: '+919876543210',
      orderId:
          'MED${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  void _showSuccess(String paymentId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            ZoomIn(
              child: Container(
                width: 72, height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF3DE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.teal, size: 40),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Order Placed!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              )),
            const SizedBox(height: 8),
            const Text(
              'Your medicines will be delivered\nin 2-4 hours.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12)),
                ),
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _rzp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Cart (${cart.itemCount} items)',
          style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17)),
      ),
      body: cart.items.isEmpty
          ? _buildEmpty()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: cart.items.length,
                    itemBuilder: (_, i) {
                      final item = cart.items.values
                          .elementAt(i);
                      return FadeInUp(
                        delay:
                            Duration(milliseconds: i * 60),
                        child: _CartItemCard(
                            item: item, cart: cart),
                      );
                    },
                  ),
                ),
                _buildCheckoutBar(cart),
              ],
            ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined,
              size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          const Text('Your cart is empty',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          const Text('Add medicines to get started',
            style: TextStyle(
                color: AppColors.textHint,
                fontSize: 13)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Browse Medicines'),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar(CartProvider cart) {
    // Delivery & tax
    final delivery = cart.total > 500 ? 0 : 40;
    final tax = (cart.total * 0.05).round();
    final grandTotal = cart.total + delivery + tax;

    return Container(
      padding: EdgeInsets.only(
        left: 16, right: 16, top: 14,
        bottom: MediaQuery.of(context).padding.bottom
            + 14,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(
                color: Color(0xFFE3EAF2), width: 0.5)),
      ),
      child: Column(
        children: [
          // Price breakdown
          _PriceRow('Subtotal', '₹${cart.total}'),
          _PriceRow('Delivery',
              delivery == 0 ? 'FREE' : '₹$delivery'),
          _PriceRow('GST (5%)', '₹$tax'),
          const Divider(color: Color(0xFFE3EAF2)),
          _PriceRow('Grand Total', '₹$grandTotal',
              isBold: true),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isPaying ? null : _pay,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14)),
              ),
              child: _isPaying
                  ? const SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5))
                  : Text(
                      '🔒 Pay ₹$grandTotal via Razorpay',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      )),
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_rounded,
                  size: 12,
                  color: AppColors.textHint),
              SizedBox(width: 4),
              Text('Secured by Razorpay · 256-bit SSL',
                style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textHint)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final CartProvider cart;
  const _CartItemCard(
      {required this.item, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.blueLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(item.medicine.emoji,
                  style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(item.medicine.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  )),
                Text(
                  '${item.medicine.manufacturer} · '
                  '${item.medicine.dosageForm}',
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary)),
                Text('₹${item.medicine.price} × '
                    '${item.quantity} = '
                    '₹${item.total}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue,
                  )),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () =>
                    cart.remove(item.medicine.id),
                child: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.emergency, size: 18),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QtyBtn(
                    icon: Icons.remove_rounded,
                    onTap: () =>
                        cart.decrement(item.medicine.id),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8),
                    child: Text('${item.quantity}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blue,
                      )),
                  ),
                  _QtyBtn(
                    icon: Icons.add_rounded,
                    onTap: () =>
                        cart.increment(item.medicine),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label, value;
  final bool isBold;
  const _PriceRow(this.label, this.value,
      {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(label,
            style: TextStyle(
              fontSize: isBold ? 14 : 12,
              fontWeight: isBold
                  ? FontWeight.w800
                  : FontWeight.w400,
              color: isBold
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            )),
          const Spacer(),
          Text(value,
            style: TextStyle(
              fontSize: isBold ? 16 : 12,
              fontWeight: isBold
                  ? FontWeight.w900
                  : FontWeight.w600,
              color: isBold
                  ? AppColors.blue
                  : AppColors.textPrimary,
            )),
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
