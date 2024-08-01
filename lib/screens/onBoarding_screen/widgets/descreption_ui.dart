import 'package:flutter/material.dart';

import '../../../helper/size_config.dart';

class DescreptionUi extends StatelessWidget {
  final String txt1 ,txt2 ;
  const DescreptionUi({super.key, required this.txt1, required this.txt2});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final screenWidth = SizeConfig.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.isDesktop() ?
          screenWidth*0.1
          : 5
      ),
      child: Column(
        children: [
          Text(
            txt1,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Text(
            txt2,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
