import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/PaymentPage.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/cart_bloc/cart_bloc.dart';

class OrderReviewPage extends StatelessWidget {
  final String confirmAddress;

  const OrderReviewPage({super.key, required this.confirmAddress});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Order Review Page'),
          ),
          body: cartState.items.isEmpty
              ? Center(child: Text('Your cart is empty'))
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Address:',style:TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            Text('$confirmAddress'),
                          ],),
                      ),
                    ),
                    
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartState.items.length,
                        itemBuilder: (context, index) {
                          final item = cartState.items[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: Image.network(item.product.imageLink),
                                title: Text(item.product.product_name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.product_description),
                                    Text('Qty ${item.quantity}'),
                                    Text('Delivery by ${item.product.deliveryDays} Days, time: ${item.product.deliveryTime}'),
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Apply Coupons'),
                              Text('Select', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Divider(),
                          SizedBox(height: 8),
                          Text('Order Payment Details', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order Amounts'),
                              Text('₹${cartState.totalPrice}', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Convenience'),
                              Text('Apply Coupon', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Delivery Fee'),
                              Text('Free', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order Total', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('₹${cartState.totalPrice}', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('EMI Available', style: TextStyle(color: Colors.red)),
                          Divider(),
                          SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 48),
                              backgroundColor: Colors.black 
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                    totalAmount: cartState.totalPrice,
                                    cartItems: cartState.items,
                                    deliveryAddress: confirmAddress, // Pass the delivery address
                                  ),
                                ),
                              );
                            },
                            child: Text('Proceed to Payment',style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
