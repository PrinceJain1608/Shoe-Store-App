import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];
  final SharedPreferences _prefs;

  OrderProvider(this._prefs) {
    _loadOrders();
  }

  List<Map<String, dynamic>> get orders => _orders;

  void _loadOrders() {
    final ordersJson = _prefs.getString('orders');
    if (ordersJson != null) {
      _orders = List<Map<String, dynamic>>.from(json.decode(ordersJson));
    }
    notifyListeners();
  }

  void _saveOrders() {
    _prefs.setString('orders', json.encode(_orders));
  }

  void addOrder(List<Map<String, dynamic>> cartItems, double totalPrice) {
    _orders.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'items': cartItems,
      'totalPrice': totalPrice,
      'date': DateTime.now().toIso8601String(),
    });
    _saveOrders();
    notifyListeners();
  }
}
