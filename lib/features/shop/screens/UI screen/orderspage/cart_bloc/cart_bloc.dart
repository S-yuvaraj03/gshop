import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartSelectedItem extends Equatable {
  final Product product;
  final int quantity;

  CartSelectedItem(this.product, this.quantity);

  CartSelectedItem copyWith({int? quantity}) {
    return CartSelectedItem(
      product,
      quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartSelectedItem.fromMap(Map<String, dynamic> map) {
    return CartSelectedItem(
      Product.fromMap(map['product']),
      map['quantity'],
    );
  }

  @override
  List<Object> get props => [product, quantity];
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState()) {
    on<AddItem>((event, emit) {
      final itemIndex = state.items.indexWhere((item) => item.product == event.product);
      if (itemIndex >= 0) {
        final updatedItems = List<CartSelectedItem>.from(state.items);
        updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
          quantity: updatedItems[itemIndex].quantity + 1,
        );
        emit(CartState(items: updatedItems));
      } else {
        emit(CartState(items: [...state.items, CartSelectedItem(event.product, 1)]));
      }
    });

    on<RemoveItem>((event, emit) {
      final itemIndex = state.items.indexWhere((item) => item.product == event.product);
      if (itemIndex >= 0) {
        final updatedItems = List<CartSelectedItem>.from(state.items);
        final item = updatedItems[itemIndex];
        if (item.quantity > 1) {
          updatedItems[itemIndex] = item.copyWith(
            quantity: item.quantity - 1,
          );
        } else {
          updatedItems.removeAt(itemIndex);
        }
        emit(CartState(items: updatedItems));
      }
    });

    on<DeleteItem>((event, emit) {
      final updatedItems = List<CartSelectedItem>.from(state.items);
      updatedItems.removeWhere((item) => item.product == event.product);
      emit(CartState(items: updatedItems));
    });

    on<CartCleared>((event, emit) {
      emit(CartState(items: []));
    });
  }
}



