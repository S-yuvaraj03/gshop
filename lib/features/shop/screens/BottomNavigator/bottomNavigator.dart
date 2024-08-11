import 'package:gshop/features/shop/screens/BottomNavigator/bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gshop/features/shop/screens/Geminiai_Chat/AiChatscreen.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Homepage/homepage.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/PastOrdersPage.dart';
import 'package:gshop/features/shop/screens/UI%20screen/shoppage/shoplistscreen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<NavigationBloc, int>(
        builder: (context, selectedIndex) {
          return NavigationBar(
            height: 80,
            elevation: 0,
            backgroundColor: Colors.white,
            indicatorColor: Colors.white70,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              switch (index) {
                case 0:
                  context.read<NavigationBloc>().add(NavigationEvent.home);
                  break;
                case 1:
                  context.read<NavigationBloc>().add(NavigationEvent.wishlist);
                  break;
                case 2:
                  context.read<NavigationBloc>().add(NavigationEvent.cart);
                  break;
                // case 3:
                //   context.read<NavigationBloc>().add(NavigationEvent.settings);
                //   break;
              }
            },
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.home,
                  color: selectedIndex == 0 ? Colors.black87 : Colors.grey,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.shopping_bag,
                  color: selectedIndex == 1 ? Colors.black87 : Colors.grey,
                ),
                label: 'shop',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.shopping_cart,
                  color: selectedIndex == 2 ? Colors.black87 : Colors.grey,
                ),
                label: 'Orders',
              ),
              // NavigationDestination(
              //   icon: Icon(
              //     Icons.settings,
              //     color: selectedIndex == 3 ? Colors.black87 : Colors.grey,
              //   ),
              //   label: 'Settings',
              // ),
            ],
          );
        },
      ),
      body: BlocBuilder<NavigationBloc, int>(
        builder: (context, selectedIndex) {
          final screens = [
            HomePage(),
            ShopListScreen(),
            PastOrdersPage()
          ];
          return screens[selectedIndex];
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AichatScreen()));
        },
        child: Image.asset("assets/images/google-gemini-icon.png"),
      ),
    );
  }
}
