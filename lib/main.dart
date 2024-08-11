import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gshop/common/widgets/Notification.dart';
import 'package:gshop/features/shop/screens/BottomNavigator/bottomNavigator.dart';
import 'package:gshop/common/widgets/searchfield.dart';
import 'package:gshop/features/shop/screens/Landinpage.dart';
import 'package:gshop/features/shop/screens/OnboardingScreen.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
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

class AppEntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkOnboardingComplete(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData && !snapshot.data!) {
          // Show onboarding screen if onboarding is not complete
          return OnboardingScreen();
        }

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data == null) {
              return Landingpage();
            }

            return NavigationMenu(); // Home screen after sign-in
          },
        );
      },
    );
  }

  Future<bool> _checkOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingComplete') ?? false;
  }
}

