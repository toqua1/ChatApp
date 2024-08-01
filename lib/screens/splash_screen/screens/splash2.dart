import 'package:chatapp/helper/size_config.dart';
import 'package:chatapp/screens/splash_screen/widgets/auth_button.dart';
import 'package:chatapp/screens/splash_screen/widgets/logo_and_title.dart';
import 'package:flutter/material.dart';

class Splash2 extends StatefulWidget {
  const Splash2({super.key});

  @override
  State<Splash2> createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double maxHeight ;
    double maxWidth ;

    if (SizeConfig.isDesktop()) {
      maxHeight = SizeConfig.height * 0.6;
      maxWidth = SizeConfig.width * 0.4;
    }else if(SizeConfig.isTablet()){
      maxHeight = SizeConfig.height * 0.8;
      maxWidth = SizeConfig.width * 0.6;
    }else{
      maxHeight = SizeConfig.height * 0.6;
      maxWidth = SizeConfig.width * 0.8;
    }
    return Scaffold(
      appBar: null,
      body:
            Center(
            child:
          SingleChildScrollView(
            child: Container(
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                  maxWidth: maxWidth,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LogoAndTitle(),
                    SizedBox(height: SizeConfig.height * 0.01),
                    const AuthButton(),
                  ],
                ),
              ),
          ),
            ),
          // );
    );
  }
}
