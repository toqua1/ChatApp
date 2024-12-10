import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key, required this.size, required this.t1,
  });
  final Size size ;
  final String t1 ;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(16),
      // margin: const EdgeInsets.only(left: 25,right: 25),
      alignment: Alignment.center,
      width:size.width - (0.25*size.width),
      height: 50,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            // offset: Offset(-5,-5),
            blurRadius: 20,
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.blue,
            Colors.purple,
          ],
        ),
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        t1,
        style: TextStyle(
            fontWeight: FontWeight.w600 ,
            color: Colors.white,
            fontSize: size.width *0.05
        ),),
    );
  }
}
