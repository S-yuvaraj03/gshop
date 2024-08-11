import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gshop/features/shop/screens/BottomNavigator/bottomNavigator.dart';
import 'package:gshop/utils/constant/sizes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gshop/features/Providers/providers.dart';

class Landingpage extends ConsumerWidget {
  const Landingpage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/landingpage.png'),
              fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('You want \n Authentic, here \n you go!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors
                            .grey.shade700, // Choose the color of the shadow
                        blurRadius:
                            0.8, // Adjust the blur radius for the shadow effect
                        offset: Offset(2.0,
                            2.0), // Set the horizontal and vertical offset for the shadow
                      ),
                    ])),
            SizedBox(height: 10),
            Text(
              'Find it here, buy it now!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  final user = await ref.read(authProvider).signInWithGoogle();
                  if (user != null) {
                    // Optionally, show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Successfully signed in!')),
                    );
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context)=> NavigationMenu()));
                  } else {
                    // Optionally, show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sign-in failed.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.pink, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: TSizes.fontLg,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                child: Text(
                  "By clicking Get Started, you consent to our use of data from your Google account and agree to our company’s policies",
                  style: TextStyle(
                    fontSize: TSizes.fontSm,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.black, // Set background color to match the image
    );
  }
}
