part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartSelectedItem> items;
  final String message;

  CartState({this.items = const [],this.message = ''});

  double get totalPrice {
    return items.fold(0, (total, current) => total + (current.product.product_offerprice * current.quantity));
  }

  // Optional: Add a copyWith method for convenience
  CartState copyWith({List<CartSelectedItem>? items, String? message}) {
    return CartState(
      items: items ?? this.items,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [items, message];
}