import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Wishlist_bloc/wishlist_bloc.dart';
import 'package:gshop/utils/constant/sizes.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: user != null
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.email)
                  .collection('wishlist')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No items in wishlist'));
                }

                final wishlistItems = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: wishlistItems.length,
                  itemBuilder: (context, index) {
                    final productData = wishlistItems[index].data() as Map<String, dynamic>?;
                    
                    // Check if productData is null or missing fields
                    if (productData == null || !productData.containsKey('product_id')) {
                      return ListTile(
                        title: Text('Invalid product data'),
                      );
                    }

                    // Extract and map the product data
                    final product = Product(
                      product_id: productData['product_id'] ?? '',
                      product_name: productData['product_name'] ?? 'Unknown',
                      imageLink: productData['product_image'] ?? '',
                      product_offerprice: (productData['product_offerprice'] ?? 0.0).toDouble(),
                      product_description: productData['product_description'] ?? '',
                      product_quantity: productData['product_quantity'] ?? 0,
                      product_price: (productData['product_price'] ?? 0.0).toDouble(),
                      product_cateogory: productData['product_category'] ?? '',
                      product_availability: productData['product_availability'] ?? false,
                      product_rating: (productData['product_rating'] ?? 0.0).toDouble(),
                      Available_count: productData['Available_count'] ?? 0,
                    );

                    return ListTile(
                      leading: Image.network(product.imageLink),
                      title: Text(product.product_name),
                      subtitle: Text('₹${product.product_offerprice.round()}'),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red, size: TSizes.iconLg),
                        onPressed: () {
                          context.read<WishlistBloc>().add(RemoveProductFromWishlist(product));
                        },
                      ),
                    );
                  },
                );
              },
            )
          : Center(child: Text('Please log in to view wishlist')),
    );
  }
}

