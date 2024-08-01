import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
class MainText extends StatelessWidget {
  String label ;
   MainText({
    required this.label
   });

  @override
  Widget build(BuildContext context) {
    return Text(label,style: TextStyle(
     fontWeight: FontWeight.w500,
      fontSize: 20,
    ),);
  }
}
