import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:gshop/data/repositories/Product_service/ProductService.dart';
import 'package:gshop/features/shop/screens/BottomNavigator/bottomNavigator.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/cart_bloc/cart_bloc.dart';
import 'package:gshop/utils/constant/sizes.dart';

class ConfirmationOfOrderPage extends StatelessWidget {
  final double totalAmount;
  final List<CartSelectedItem> cartItems;
  final String deliveryAddress;

  const ConfirmationOfOrderPage({
    super.key,
    required this.totalAmount,
    required this.cartItems,
    required this.deliveryAddress,
  });

  // Method to update the available product count in the shop collection
  Future<void> updateShopProducts() async {
    ProductService productService = ProductService();

    for (var cartItem in cartItems) {
      await productService.updateProductAvailability(
        cartItem.product.product_id, // Product ID
        cartItem.quantity,           // Quantity purchased
      );
    }
  }

  Future<void> saveOrderToFirestore(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser; // Get the logged-in user

    if (user != null) {
      CollectionReference orders = FirebaseFirestore.instance
          .collection('users')
          .doc(user.email) // Use the user's email as the document ID
          .collection('orders'); // Create a subcollection for orders

      await orders.add({
        'totalAmount': totalAmount,
        'deliveryAddress': deliveryAddress,
        'items': cartItems.map((item) => item.toMap()).toList(),
        'timestamp': Timestamp.now(),
      });

      // Clear the cart
      context.read<CartBloc>().add(CartCleared());
    } else {
      // Handle the case where the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double kheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kheight * 0.08,
            ),
            Text('Order Confirmation',
                style: TextStyle(fontSize: TSizes.fontLg, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Delivery Address', style: TextStyle(fontSize: TSizes.fontLg)),
            SizedBox(height: 8),
            Text(deliveryAddress, style: TextStyle(fontSize: TSizes.fontLg)),
            Divider(thickness: 1, height: 32),
            Text('Order Details',
                style: TextStyle(fontSize: TSizes.fontLg, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    leading: Image.network(item.product.imageLink),
                    title: Text(item.product.product_name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.product.product_description),
                        Text('Qty ${item.quantity}'),
                        Text(
                            'Delivery by ${item.product.deliveryDays} Days, time: ${item.product.deliveryTime}'),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(thickness: 1, height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',
                    style:
                        TextStyle(fontSize: TSizes.fontLg, fontWeight: FontWeight.bold)),
                Text('₹${totalAmount}',
                    style:
                        TextStyle(fontSize: TSizes.fontLg, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16),
            MaterialButton(
              color: Colors.black,
              onPressed: () async {
                await saveOrderToFirestore(context);
                await updateShopProducts(); // Update available products in shop collection
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationMenu(),
                  ),
                ); // Optionally, navigate to a different page
              },
              child: Text(
                'Complete order',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
