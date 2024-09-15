import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gshop/features/shop/bloc/cart_bloc.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/OrderReviewPage.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/cart_bloc/cart_bloc.dart';
import 'package:gshop/utils/constant/sizes.dart';
import 'package:gshop/utils/formatters/starratings.dart';

class CartPage extends StatelessWidget {
  final String deliveryAddress;

  const CartPage({Key? key, required this.deliveryAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double kwidth = MediaQuery.of(context).size.width;
    double kheight = MediaQuery.of(context).size.height;
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Cart'),
          ),
          body: cartState.items.isEmpty
              ? Center(child: Text('Your cart is empty'))
              : ListView.builder(
                  itemCount: cartState.items.length,
                  itemBuilder: (context, index) {
                    final item = cartState.items[index];
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  child: Image.network(item.product.imageLink),
                                  height: kheight * 0.15,
                                  width: kwidth * 0.3,
                                ),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.product_name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: TSizes.fontLg,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        item.product.product_description,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        '₹${item.product.product_offerprice} x ${item.quantity}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          StarRating(
                                            rating: item.product.product_rating,
                                            color: Colors.yellow.shade800,
                                            starCount: 5,
                                            iconsize: TSizes.iconSm,
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(
                                            '${item.product.product_rating} (ratings)',
                                            style: TextStyle(
                                                fontSize: TSizes.fontSm),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          if (item.quantity > 0) {
                                            context
                                                .read<CartBloc>()
                                                .add(RemoveItem(item.product));
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text('${item.quantity}'),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          if (item.quantity <
                                              (item.product.Available_count ??
                                                  0)) {
                                            context
                                                .read<CartBloc>()
                                                .add(AddItem(item.product));
                                          } else if (item.quantity >=
                                              (item.product.Available_count ??
                                                  0)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Sorry for your inconvienence only ${item.product.Available_count} left')),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    context
                                        .read<CartBloc>()
                                        .add(DeleteItem(item.product));
                                  },
                                ),
                              ],
                            ),
                          ]),
                    );
                  }),
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text('Delivery Address: $deliveryAddress'),
                Text(
                  'Total: ₹${cartState.totalPrice}',
                  style: TextStyle(fontSize: TSizes.fontLg),
                ),
                MaterialButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderReviewPage(
                                confirmAddress: deliveryAddress,
                              )),
                    );
                  },
                  child: Text(
                    'Proceed to cart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
