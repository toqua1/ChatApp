import 'package:flutter/material.dart';
import '../../../helper/size_config.dart';

class CustomButton extends StatelessWidget {
  final String txt ;
  final VoidCallback func;
  const CustomButton({super.key, required this.txt, required this.func});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final screenWidth = SizeConfig.width;
    double fontSize = SizeConfig.isMobile()? screenWidth * 0.05:
    SizeConfig.isDesktop() ? screenWidth*0.02 : screenWidth*0.03 ;

    return SizedBox(
      width:SizeConfig.isDesktop() ? SizeConfig.width*0.2: SizeConfig.width*0.4 ,
      height:SizeConfig.isMobile() ? 60 : 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: func,
        child: Text(
          txt,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
