import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';
import '../../../Holding.dart';
import '../../onBoarding_screen/screen/onboarding.dart';
import '../screens/splash1.dart';
import '../../../helper/size_config.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    double buttonSize = SizeConfig.isDesktop()? 60 : 40;

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Splash1();
          } else {
            return IconButton(
              onPressed: () {
                if (snapshot.hasData) {
                  // User is authenticated, navigate to the Holding screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Holding()),
                  );
                } else {
                  // User is not authenticated, navigate to the Onboarding screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Onboarding()),
                  );
                }
              },
              icon: Icon(Iconsax.arrow_circle_right, size: buttonSize),
            );
          }
        },
      ),
    );
  }
}
