import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubText extends StatelessWidget {
  String label ;
  SubText({
  required this.label
  });

  @override
  Widget build(BuildContext context) {
    return Text(label,style: const TextStyle(
      fontSize: 15 ,
      fontWeight: FontWeight.w400,
      color: Colors.grey,
    ),);
  }
}
