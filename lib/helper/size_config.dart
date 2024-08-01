import 'package:flutter/material.dart';

class SizeConfig {
  static const double desktop = 1200;
  static const double tablet = 800;
  static late double width, height;

  static init(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;
  }

  static bool isDesktop(){
    return width>=desktop ;
  }
  static bool isTablet(){
    return width>=tablet && width<desktop ;
  }
  static bool isMobile(){
    return width<tablet ;
  }
}