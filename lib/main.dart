import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gshop/AppEntrypoint.dart';
import 'package:gshop/common/widgets/Notification.dart';
import 'package:gshop/features/shop/screens/BottomNavigator/bottomNavigator.dart';
import 'package:gshop/common/widgets/searchfield.dart';
import 'package:gshop/features/shop/screens/NetworkConnectivity/Connectivity_bloc/connectivity_bloc.dart';
import 'package:gshop/features/shop/screens/NetworkConnectivity/connectivity_indicator.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Homepage/homepage.dart';
import 'package:gshop/features/shop/screens/UI%20screen/Wishlist_bloc/wishlist_bloc.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/cart_bloc/cart_bloc.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/order_bloc/order_bloc.dart';
// import 'package:gshop/features/shop/screens/login_screen.dart';
import 'package:gshop/features/shop/screens/UI%20screen/shoppage/shoplistscreen.dart';
import 'package:gshop/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'features/shop/screens/BottomNavigator/bloc/navigation_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  await Permission.camera.request();
  await Permission.microphone.request();
  await Permission.manageExternalStorage.request();
  await Permission.notification.request();
  PermissionStatus locationaccessStatus = await Permission.location.request();
  if (locationaccessStatus.isGranted) {
    runApp(ProviderScope(child: MyApp()));
  } else if (locationaccessStatus.isDenied ||
      locationaccessStatus.isPermanentlyDenied) {
    // Permission denied
    await openAppSettings(); // Optional: Open app settings to allow permission
  }
}

class MyApp extends StatelessWidget {
  // ignore: unused_field
  final PushNotificationService _notificationService =
      PushNotificationService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => ConnectivityBloc()..checkInitialConnectivity(),
        ),
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
        BlocProvider(create: (context) => OrderBloc()),
        BlocProvider(create: (_) => WishlistBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              child!,
              ConnectivityIndicator(), // Add this to show connectivity status globally
            ],
          );
        },
        routes: {
          '/': (BuildContext context) => AppEntryPoint(),
          '/Navigator': (BuildContext context) => NavigationMenu(),
          '/Shoplist': (BuildContext context) => ShopListScreen(),
          '/Search': (BuildContext context) => Searchfield(),
          '/Home': (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}