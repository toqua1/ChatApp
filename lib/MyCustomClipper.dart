import 'package:flutter/cupertino.dart';

class MyCustomClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path=Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height-100);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip( CustomClipper<Path> oldClipper) {
    return true;
  }
  
}