import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  WishlistBloc() : super(WishlistInitial()) {
    on<AddProductToWishlist>(_onAddProductToWishlist);
    on<RemoveProductFromWishlist>(_onRemoveProductFromWishlist);
  }

  Future<void> _onAddProductToWishlist(
      AddProductToWishlist event, Emitter<WishlistState> emit) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Reference to user's wishlist
        final DocumentReference wishlistRef = _firestore
            .collection('users')
            .doc(user.email)
            .collection('wishlist')
            .doc(event.product.product_id); // Use product_id as document ID

        // Set the product details in Firestore
        await wishlistRef.set({
          'product_id': event.product.product_id,
          'product_name': event.product.product_name,
          'product_image': event.product.imageLink,
          'product_offerprice': event.product.product_offerprice,
          'product_price': event.product.product_price,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Update the wishlist state
        final updatedWishlist = List<Product>.from(state.wishlist)
          ..add(event.product);
        emit(WishlistUpdated(updatedWishlist));
      } catch (e) {
        print('Error adding to wishlist: $e');
      }
    }
  }

  Future<void> _onRemoveProductFromWishlist(
      RemoveProductFromWishlist event, Emitter<WishlistState> emit) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Reference to user's wishlist
        final DocumentReference wishlistRef = _firestore
            .collection('users')
            .doc(user.email)
            .collection('wishlist')
            .doc(event.product.product_id); // Use product_id as document ID

        // Delete the product from the wishlist
        await wishlistRef.delete();

        // Update the wishlist state
        final updatedWishlist = List<Product>.from(state.wishlist)
          ..remove(event.product);
        emit(WishlistUpdated(updatedWishlist));
      } catch (e) {
        print('Error removing from wishlist: $e');
      }
    }
  }
}
