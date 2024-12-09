import 'package:flutter/material.dart';
import '../../Signing/screens/login.dart';
import '../widgets/description_lists.dart';
import 'onboarding_screen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  String img = "assetsEdited/boarding0.png";
  int index = 0;
  String txt1 = "Welcome !";
  String txt2 = "Make your profile page with your full information";

  void change() {
    txt1 = description1[index];
    txt2 = description2[index];
    index++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      img: img,
      txt1: txt1,
      txt2: txt2,
      onSkip: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      },
      onNext: () {
        if (index == 0) {
          change();
          img = "assetsEdited/boarding1.png";
        } else if (index == 1) {
          change();
          img = "assetsEdited/boarding3.png";
        } else if (index == 2) {
          change();
          img = "assetsEdited/boarding2.png";
        } else if (index > 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }
      },
    );
  }
}
