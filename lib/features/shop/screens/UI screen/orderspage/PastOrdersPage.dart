import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/cart_bloc/cart_bloc.dart';
import 'package:gshop/utils/constant/sizes.dart';

class PastOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser; // Get the logged-in user

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Past Orders'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Text('User not logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Past Orders'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.email) // Use the user's email to filter orders
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No past orders found.'));
          }
          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final totalAmount = order['totalAmount'];
              final deliveryAddress = order['deliveryAddress'];
              final items = (order['items'] as List)
                  .map((item) => CartSelectedItem.fromMap(item))
                  .toList();

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #${order.id}',
                          style: TextStyle(
                              fontSize: TSizes.fontMd, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Delivery Address: $deliveryAddress',
                          style: TextStyle(fontSize: TSizes.fontMd)),
                      Divider(thickness: 1, height: 32),
                      Text('Order Details',
                          style: TextStyle(
                              fontSize: TSizes.fontLg, fontWeight: FontWeight.bold)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            leading: Image.network(item.product.imageLink),
                            title: Text(item.product.product_name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.product_description),
                                Row(
                                  children: [
                                    Text('Qty ${item.quantity}'),
                                  ],
                                ),
                                Text(
                                    'Delivery by ${item.product.deliveryDays} Days, time: ${item.product.deliveryTime}'),
                              ],
                            ),
                          );
                        },
                      ),
                      Divider(thickness: 1, height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total',
                              style: TextStyle(
                                  fontSize: TSizes.fontLg, fontWeight: FontWeight.bold)),
                          Text('₹${totalAmount}',
                              style: TextStyle(
                                  fontSize: TSizes.fontLg, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
