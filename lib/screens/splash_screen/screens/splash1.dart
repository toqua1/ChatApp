import 'dart:async';
import 'package:chatapp/Holding.dart';
import 'package:chatapp/screens/onBoarding_screen/screen/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../helper/size_config.dart';
import '../widgets/logo_and_title.dart';

class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6),
            ()=> Navigator.push(context,
            MaterialPageRoute(builder: (context)=>
            FirebaseAuth.instance.currentUser != null?
            const Holding():
            const Onboarding())
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: null,
      body:
            Center(
              child:AspectRatio(
                aspectRatio:SizeConfig.isDesktop()? 650 / 150 : 1,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LogoAndTitle(),
                    ],
                  ),
              ),
          ),
    );
  }
}
