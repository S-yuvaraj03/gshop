import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/OrderReviewPage.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/cart_bloc/cart_bloc.dart';
import 'package:gshop/utils/constant/sizes.dart';
import 'package:gshop/utils/formatters/starratings.dart';

class CartPage extends StatefulWidget {
  final String deliveryAddress;

  const CartPage({Key? key, required this.deliveryAddress}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isRemoveButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    double kwidth = MediaQuery.of(context).size.width;
    double kheight = MediaQuery.of(context).size.height;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('cartitems')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final cartItems = snapshot.data!.docs.map((doc) {
          return CartSelectedItem.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

        // Function to save the updated cart items back to Firestore
        Future<void> _saveCartItems() async {
          final cartRef = FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection('cartitems');

          for (var item in cartItems) {
            await cartRef.doc(item.product.product_id).set(item.toMap());
          }
        }

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop)
              return; // If the system already popped the route, do nothing
            // Save the cart items before navigating back
            await _saveCartItems();
            // Navigate to homepage
            Navigator.of(context).pushReplacementNamed('/homepage');
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('My Cart'),
              leading: BackButton(
                onPressed: () async {
                  await _saveCartItems();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
              automaticallyImplyLeading: false,
            ),
            body: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
              final cartItems = state.items;

              return cartItems.isEmpty
                  ? Center(child: Text('Your cart is empty'))
                  : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Container(
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    child:
                                        Image.network(item.product.imageLink),
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
                                              rating:
                                                  item.product.product_rating,
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
                                        Text(
                                            "Only ${item.product.Available_count} Left in Stock")
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
                                          onPressed: isRemoveButtonDisabled
                                              ? null
                                              : () {
                                                  if (item.quantity > 1) {
                                                    setState(() {
                                                      isRemoveButtonDisabled =
                                                          true;
                                                      item.quantity - 1;
                                                    });

                                                    context
                                                        .read<CartBloc>()
                                                        .add(RemoveItem(
                                                            item.product));

                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .email)
                                                        .collection('cartitems')
                                                        .doc(item
                                                            .product.product_id)
                                                        .update({
                                                      'quantity': item.quantity
                                                    });

                                                    Future.delayed(
                                                        Duration(
                                                            milliseconds: 300),
                                                        () {
                                                      setState(() {
                                                        isRemoveButtonDisabled =
                                                            false;
                                                      });
                                                    });
                                                  }
                                                },
                                        ),
                                        SizedBox(width: 8.0),
                                        Text('${item.quantity}'),
                                        SizedBox(width: 8.0),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            if (item.quantity <
                                                (item.product.Available_count ??
                                                    0)) {
                                              setState(() {
                                                item.quantity + 1;
                                              });

                                              context
                                                  .read<CartBloc>()
                                                  .add(AddItem(item.product));

                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.email)
                                                  .collection('cartitems')
                                                  .doc(item.product.product_id)
                                                  .update({
                                                'quantity': item.quantity
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'only ${item.product.Available_count} Left in stock'),
                                                  // duration: Duration(milliseconds: 120),
                                                ),
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
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.email)
                                          .collection('cartitems')
                                          .doc(item.product.product_id)
                                          .delete();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
            }),
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total: ₹${cartItems.fold<int>(0, (total, current) => total + (current.product.product_offerprice * current.quantity).toInt())}',
                    style: TextStyle(fontSize: TSizes.fontLg),
                  ),
                  MaterialButton(
                    color: Colors.black,
                    onPressed: () async {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      // Save the cart items before proceeding to the order review page
                      await _saveCartItems();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderReviewPage(
                            initialAddress: widget.deliveryAddress,
                            cartItems: cartItems,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Proceed to Checkout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
