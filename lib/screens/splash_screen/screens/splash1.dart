import 'dart:async';
import 'package:chatapp/Holding.dart';
import 'package:chatapp/firebase/fire_auth.dart';
import 'package:chatapp/helper/notification_helper.dart';
import 'package:chatapp/screens/onBoarding_screen/screen/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../helper/size_config.dart';
import '../../../provider/provider.dart';
import '../widgets/logo_and_title.dart';

class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  @override
  void initState() {
    Provider.of<ProviderApp>(context, listen: false).getValuesPref();
   Provider.of<ProviderApp>(context , listen: false).getUserDetails();
    SystemChannels.lifecycle.setMessageHandler((message){

      if(message.toString() == 'AppLifecycleState.resumed'){
        FireAuth().updateActivate(true);
      }
      else if(message.toString() == 'AppLifecycleState.paused'
          || message.toString() == 'AppLifecycleState.inactive'){
        FireAuth().updateActivate(false);
      }
      // print(message);
      return Future.value(message);
    });
   super.initState();
    Timer(const Duration(seconds: 6),
            ()=> Navigator.pushReplacement(context,
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
