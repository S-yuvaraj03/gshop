import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/cart_bloc/cart_bloc.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(String userEmail, CartSelectedItem cartItem) async {
    final cartItemDoc = _firestore.collection('users').doc(userEmail).collection('cartitems').doc(cartItem.product.product_id);
    final cartItemData = cartItem.toMap();
    
    await cartItemDoc.set(cartItemData, SetOptions(merge: true));
  }

  Future<List<CartSelectedItem>> fetchCartItems(String userEmail) async {
    final cartItemsSnapshot = await _firestore.collection('users').doc(userEmail).collection('cartitems').get();
    
    return cartItemsSnapshot.docs
        .map((doc) => CartSelectedItem.fromMap(doc.data()))
        .toList();
  }

  Future<void> removeFromCart(String userEmail, String productId) async {
    final cartItemDoc = _firestore.collection('users').doc(userEmail).collection('cartitems').doc(productId);
    await cartItemDoc.delete();
  }
}
