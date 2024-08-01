import 'package:flutter/material.dart';
import '../../../helper/size_config.dart';

class LogoAndTitle extends StatelessWidget {
  const LogoAndTitle({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final screenWidth = SizeConfig.width;
    double fontSize = SizeConfig.isDesktop()? screenWidth * 0.05 :
    screenWidth*0.1 ; // 10% of the screen width

    return
    Column(
        children: [
          Image.asset(
            "assetsEdited/logo2.png",
            width:SizeConfig.isDesktop()? screenWidth * 0.1 : screenWidth * 0.3,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 30),
          Text(
            "chathub".toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: fontSize,
            ),
          ),
        ],
    );
  }
}
