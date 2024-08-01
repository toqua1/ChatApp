import 'package:chatapp/screens/onBoarding_screen/widgets/custom_button.dart';
import 'package:chatapp/screens/onBoarding_screen/widgets/descreption_ui.dart';
import 'package:flutter/material.dart';

import '../../../helper/size_config.dart';

class OnboardingScreen extends StatelessWidget {
  final String img;
  final String txt1;
  final String txt2;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const OnboardingScreen({
    required this.img,
    required this.txt1,
    required this.txt2,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final screenWidth = SizeConfig.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: SizeConfig.isDesktop()? 30 :60 ) ,
          Center(
            child: Image.asset(
              img,
              fit: BoxFit.contain,
              width: SizeConfig.isDesktop()? screenWidth * 0.4 : screenWidth
                  * 0.8,
            ),
          ),
          const SizedBox(height: 20),
         DescreptionUi(txt1: txt1, txt2: txt2),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(txt: "Skip", func: onSkip),
                const SizedBox(width: 20),
                CustomButton(txt: "Next", func: onNext),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
