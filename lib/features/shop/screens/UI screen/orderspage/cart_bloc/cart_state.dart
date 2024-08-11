part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartSelectedItem> items;

  CartState({this.items = const []});

  double get totalPrice {
    return items.fold(0, (total, current) => total + (current.product.product_offerprice * current.quantity));
  }

  @override
  List<Object> get props => [items];
}