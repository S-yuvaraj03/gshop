import 'package:flutter/material.dart';
import 'package:gshop/features/shop/screens/UI%20screen/WishlistPage.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/CartPage.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/PaymentHistoryPage.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/PaymentPage.dart';
import 'package:gshop/utils/constant/sizes.dart';

class Appdrawer extends StatelessWidget {
  const Appdrawer({super.key});

  @override
  Widget build(BuildContext context) {
    double kheight = MediaQuery.of(context).size.height;
    double kwidth = MediaQuery.of(context).size.width;
    return Drawer(
      width: kwidth*0.7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListView(
        // Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: kheight*0.15,
            child: DrawerHeader(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  "assets/images/googlelogo.png",
                  height: kheight*0.055,
                  width: kwidth*0.2,
                ),
                Text(
                  ' Shopping',
                  style: TextStyle(color: Colors.grey, fontSize: TSizes.fontLg),
                ),
              ],
            ),
            ),
          ),
          ListTile(
            title: const Text('Go to Cart'),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(deliveryAddress: ''),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('payment history'),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentHistoryPage(paymentHistory: paymentHistory),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('wishlist'),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WishlistPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('settings'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}