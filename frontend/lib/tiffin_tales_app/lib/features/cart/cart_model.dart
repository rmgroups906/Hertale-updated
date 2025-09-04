import 'package:flutter/material.dart';
import '../meals/meal_model.dart';

class CartItem {
  final Meal meal;
  int quantity;
  CartItem({required this.meal, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  double get deliveryFee => 40.0;
  double get subtotal {
    return items.fold(0, (sum, item) => sum + (item.meal.price * item.quantity));
  }
  double get deliveryCharge {
    // Replace with your actual delivery charge logic if needed
    return 50.0;
  }

  List<CartItem> get items => List.unmodifiable(_items);

  void addToCart(Meal meal, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.meal.id == meal.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(meal: meal, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(String mealId) {
    _items.removeWhere((item) => item.meal.id == mealId);
    notifyListeners();
  }

  void updateQuantity(String mealId, int quantity) {
    final index = _items.indexWhere((item) => item.meal.id == mealId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.meal.price * item.quantity);
} 