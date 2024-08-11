// part of 'order_bloc.dart';

// class Order {
//   final List<CartSelectedItem> items;
//   final double totalPrice;

//   Order({required this.items, required this.totalPrice});
// }

// class OrderEvent {}

// class AddOrder extends OrderEvent {
//   final List<CartSelectedItem> items;
//   final double totalPrice;

//   AddOrder(this.items, this.totalPrice);
// }


part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class AddOrder extends OrderEvent {
  final List<CartSelectedItem> items;
  final double totalPrice;

  const AddOrder(this.items, this.totalPrice);

  @override
  List<Object> get props => [items, totalPrice];
}

