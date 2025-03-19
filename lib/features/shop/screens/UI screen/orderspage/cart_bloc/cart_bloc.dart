import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartSelectedItem extends Equatable {
  final Product product;
  int quantity;

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
  final String userEmail;
  final FirebaseFirestore _firestore;

  CartBloc(this.userEmail, this._firestore) : super(CartState()) {
    on<AddItem>((event, emit) async {
      final itemIndex = state.items.indexWhere(
          (item) => item.product.product_id == event.product.product_id);

      // Check if item already exists in cart
      if (itemIndex >= 0) {
        final existingItem = state.items[itemIndex];

        // Check if we can add more items based on available stock
        if (existingItem.quantity >= existingItem.product.Available_count!) {
          // If the item quantity in the cart has reached available stock, do nothing
          emit(CartState(
              items: state.items, message: "Max stock limit reached"));
          return;
        }

        // Update quantity if we haven't reached the stock limit
        final updatedItems = List<CartSelectedItem>.from(state.items);
        updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
          quantity: updatedItems[itemIndex].quantity + 1,
        );
        emit(CartState(items: updatedItems));

        // Update Firestore with the updated quantity
        await _firestore
            .collection('users')
            .doc(userEmail)
            .collection('cartitems')
            .doc(event.product.product_id)
            .set({
          'quantity': updatedItems[itemIndex].quantity,
        }, SetOptions(merge: true));
      } else {
        // Add new item to cart with quantity 1 if it doesn't exist and stock is available
        if (event.product.Available_count! > 0) {
          emit(CartState(
              items: [...state.items, CartSelectedItem(event.product, 1)]));

          // Add to Firestore for the first time
          await _firestore
              .collection('users')
              .doc(userEmail)
              .collection('cartitems')
              .doc(event.product.product_id)
              .set({
            'product': event.product.toMap(),
            'quantity': 1,
          });
        } else {
          emit(CartState(items: state.items, message: "Stock unavailable"));
        }
      }
    });

    on<RemoveItem>((event, emit) async {
      final itemIndex = state.items.indexWhere(
          (item) => item.product.product_id == event.product.product_id);

      if (itemIndex >= 0) {
        final updatedItems = List<CartSelectedItem>.from(state.items);
        final item = updatedItems[itemIndex];

        if (item.quantity > 1) {
          // Reduce quantity by 1
          updatedItems[itemIndex] = item.copyWith(quantity: item.quantity - 1);
        } else {
          // Remove the item from the cart if quantity reaches 0
          updatedItems.removeAt(itemIndex);
        }

        emit(CartState(items: updatedItems));

        // Update Firestore with reduced quantity or remove item if quantity is 0
        if (item.quantity > 1) {
          await _firestore
              .collection('users')
              .doc(userEmail)
              .collection('cartitems')
              .doc(event.product.product_id)
              .set({
            'quantity': item.quantity - 1,
          }, SetOptions(merge: true));
        } else {
          await _firestore
              .collection('users')
              .doc(userEmail)
              .collection('cartitems')
              .doc(event.product.product_id)
              .delete();
        }
      } else {}
    });

    on<DeleteItem>((event, emit) async {
      final updatedItems = List<CartSelectedItem>.from(state.items);
      updatedItems.removeWhere((item) => item.product == event.product);
      emit(CartState(items: updatedItems));

      // Remove from Firestore
      await _firestore
          .collection('users')
          .doc(userEmail)
          .collection('cartitems')
          .doc(event.product.product_id)
          .delete();
    });

    on<LoadCart>((event, emit) async {
      final cartItems = await _firestore
          .collection('users')
          .doc(userEmail)
          .collection('cartitems')
          .get();
      final List<CartSelectedItem> items = cartItems.docs.map((doc) {
        return CartSelectedItem.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      emit(state.copyWith(items: items));
    });

    // Handle CartCleared event
    on<CartCleared>((event, emit) async {
      // Clear the cart in state
      emit(CartState(items: []));

      // Clear the cart in Firestore
      final cartItems = await _firestore
          .collection('users')
          .doc(userEmail)
          .collection('cartitems')
          .get();
      for (var doc in cartItems.docs) {
        await doc.reference.delete();
      }
    });

    
  }
}
