import 'package:chatapp/screens/Signing/widgets/animated_gradient_border.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key, required this.size, required this.t1,
  });
  final Size size ;
  final String t1 ;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width - (0.3*size.width),
      height: 55,
      child: AnimatedGradientBorder(
        topColor: Color(0xffad5389),
        bottomColor: Colors.black,
        thickness: 7,
        radius: 20,
        blurRadius: 15,
        spreadRadius: 2,
        duration: const Duration(seconds: 2),
        child: Container(
          alignment: Alignment.center,
          width:size.width - (0.25*size.width),
          height: 60,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                // offset: Offset(0,0),
                blurRadius: 20,
              ),
            ],
            gradient:  LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.pink.shade300,
                Colors.deepPurpleAccent
                // Color(0xffad5389),
                // Color(0xff3c1053)
                // Color(Provider.of<ProviderApp>(context).mainColor),
              ],
            ),
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            t1,
            style: TextStyle(
                fontWeight: FontWeight.w600 ,
                color: Colors.white,
                fontSize: size.width *0.05
            ),),
        ),
      ),
    );
  }
}
