import 'package:flutter/material.dart';
import 'package:gshop/features/shop/model/CartModel.dart';

class Order {
  final List<CartItem> items;
  final double totalPrice;

  Order({required this.items, required this.totalPrice});
}

class OrderModel extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(List<CartItem> items, double totalPrice) {
    _orders.add(Order(items: items, totalPrice: totalPrice));
    notifyListeners();
  }
}
