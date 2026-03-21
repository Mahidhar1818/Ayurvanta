import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  static const _keyId = 'rzp_test_YOUR_KEY_HERE';

  late Razorpay _razorpay;
  final Function(String paymentId) onSuccess;
  final Function(String error) onFailure;
  final VoidCallback onExternalWallet;

  RazorpayService({
    required this.onSuccess,
    required this.onFailure,
    required this.onExternalWallet,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS,
        _handleSuccess);
    _razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR,
        _handleError);
    _razorpay.on(
        Razorpay.EVENT_EXTERNAL_WALLET,
        _handleExternalWallet);
  }

  void openCheckout({
    required int amountInPaise,
    required String description,
    required String userName,
    required String userEmail,
    required String userPhone,
    required String orderId,
  }) {
    final options = {
      'key': _keyId,
      'amount': amountInPaise,
      'currency': 'INR',
      'name': 'AyurVanta',
      'description': description,
      'order_id': orderId,
      'prefill': {
        'contact': userPhone,
        'email': userEmail,
        'name': userName,
      },
      'theme': {'color': '#185FA5'},
      'modal': {'confirm_close': true},
      'method': {
        'upi': true,
        'card': true,
        'netbanking': true,
        'wallet': true,
        'emi': true,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      onFailure(e.toString());
    }
  }

  void _handleSuccess(PaymentSuccessResponse r) =>
      onSuccess(r.paymentId ?? '');

  void _handleError(PaymentFailureResponse r) =>
      onFailure(r.message ?? 'Payment failed');

  void _handleExternalWallet(
          ExternalWalletResponse r) =>
      onExternalWallet();

  void dispose() => _razorpay.clear();
}
