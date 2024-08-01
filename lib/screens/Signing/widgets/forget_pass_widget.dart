import 'package:flutter/material.dart';
import '../screens/forget_screen.dart';

class ForgetPassWidget extends StatelessWidget {
  const ForgetPassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        const Spacer(),
        Padding(
          padding:const EdgeInsets.only(right: 5),
          child:GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>const ForgetPass())
              );
            },
            child: const Text("Forget Password?" ,style: TextStyle(
                fontWeight: FontWeight.w500
            ),),
          ),),
      ],
    );
  }
}
