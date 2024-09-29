import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gshop/features/shop/screens/NetworkConnectivity/Connectivity_bloc/connectivity_bloc.dart';
import 'package:gshop/features/shop/screens/NetworkConnectivity/NetworkDialogscreen.dart';
import 'package:gshop/features/shop/screens/Landinpage.dart';

import 'package:gshop/features/shop/screens/OnboardingScreen.dart';
import 'package:gshop/features/shop/screens/BottomNavigator/bottomNavigator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppEntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        if (state is ConnectivityOffline) {
          // Show the network error screen if there's no connectivity
          return NetworkErrorDialog();
        }

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
      },
    );
  }

  Future<bool> _checkOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingComplete') ?? false;
  }
}
