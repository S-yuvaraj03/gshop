// part of 'order_bloc.dart';

// class OrderState {
//   final List<Order> orders;

//   OrderState(this.orders);
// }

part of 'order_bloc.dart';

class OrderState extends Equatable {
  final List<Order> orders;

  const OrderState(this.orders);

  @override
  List<Object> get props => [orders];
}

class Order {
  final List<CartSelectedItem> items;
  final double totalPrice;

  Order({required this.items, required this.totalPrice});
}
