import 'package:flutter/material.dart';

class LoginButtonUi extends StatelessWidget {
  const LoginButtonUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(left: 25,right: 25),
      alignment: Alignment.center,
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            offset: Offset(0.0,0.0),
            blurRadius: 10,
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
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text("Login".toUpperCase(),style: const TextStyle(
        fontWeight: FontWeight.w600, fontSize: 25 ,color: Colors.white,
      ),),
    );
  }
}
