import 'package:flutter/material.dart';

class LogoAndTitle extends StatelessWidget {
  const LogoAndTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children:[
        const Padding(
          padding:EdgeInsets.only(left: 40),
          child:Image(
            image: AssetImage("assetsEdited/logo2.png" )
            ,width: 100,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Column(
          children: [
            const Text("Login",style: TextStyle(
              fontSize: 40,fontWeight: FontWeight.bold,
              // color: Colors.white,
            ),),
            const SizedBox(
              height: 20,
            ),
            Text("Login to your account",style: TextStyle(
              fontSize: 15,color: Colors.grey[700],fontWeight: FontWeight.w400,
            ),),
          ],
        ),
      ],
    );
  }
}
