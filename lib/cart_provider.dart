import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/global_variables.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cart = [];
  final SharedPreferences _prefs;

  CartProvider(this._prefs) {
    _loadCart();
  }

  List<Map<String, dynamic>> get cart => _cart;

  double get totalPrice {
    return _cart.fold(
        0,
        (sum, item) =>
            sum + (item['price'] as double) * (item['quantity'] as int));
  }

  void _loadCart() {
    final cartJson = _prefs.getString('cart');
    if (cartJson != null) {
      final loadedCart = List<Map<String, dynamic>>.from(json.decode(cartJson));
      _cart = _validateCartItems(loadedCart);
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> _validateCartItems(
      List<Map<String, dynamic>> cartItems) {
    return cartItems.where((item) {
      final product = products.firstWhere(
        (p) => p['id'] == item['id'],
        orElse: () => {},
      );
      if (product.isEmpty) return false;
      final sizes = (product['sizes'] as List<int>?) ?? [];
      return sizes.contains(item['size']);
    }).toList();
  }

  void _saveCart() {
    _prefs.setString('cart', json.encode(_cart));
  }

  void addProduct(Map<String, dynamic> product, int quantity) {
    final existingItemIndex = _cart.indexWhere((item) =>
        item['id'] == product['id'] && item['size'] == product['size']);
    if (existingItemIndex != -1) {
      _cart[existingItemIndex]['quantity'] =
          (_cart[existingItemIndex]['quantity'] as int) + quantity;
    } else {
      _cart.add({...product, 'quantity': quantity});
    }
    _saveCart();
    notifyListeners();
  }

  void removeProduct(Map<String, dynamic> product) {
    _cart.removeWhere((item) =>
        item['id'] == product['id'] && item['size'] == product['size']);
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(Map<String, dynamic> product, int newQuantity) {
    if (newQuantity <= 0) {
      removeProduct(product);
      return;
    }
    final index = _cart.indexWhere((item) =>
        item['id'] == product['id'] && item['size'] == product['size']);
    if (index != -1) {
      _cart[index]['quantity'] = newQuantity;
      _saveCart();
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    _saveCart();
    notifyListeners();
  }
}
