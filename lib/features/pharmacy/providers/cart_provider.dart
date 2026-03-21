import 'package:flutter/material.dart';
import '../../../core/services/medicine_api_service.dart';

class CartItem {
  final MedicineModel medicine;
  int quantity;
  CartItem({required this.medicine, this.quantity = 1});
  int get total => medicine.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  bool contains(String id) => _items.containsKey(id);

  int getQuantity(String id) =>
      _items[id]?.quantity ?? 0;

  int get total =>
      _items.values.fold(0, (s, i) => s + i.total);

  int get itemCount => _items.values
      .fold(0, (s, i) => s + i.quantity);

  void addItem(MedicineModel m) {
    if (_items.containsKey(m.id)) {
      _items[m.id]!.quantity++;
    } else {
      _items[m.id] = CartItem(medicine: m);
    }
    notifyListeners();
  }

  void increment(MedicineModel m) {
    if (_items.containsKey(m.id)) {
      _items[m.id]!.quantity++;
      notifyListeners();
    } else {
      addItem(m);
    }
  }

  void decrement(String id) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity--;
      if (_items[id]!.quantity <= 0) {
        _items.remove(id);
      }
      notifyListeners();
    }
  }

  void remove(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
