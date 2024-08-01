import 'package:flutter/material.dart';
import '../screens/signup.dart';

class OutlinedButtonUi extends StatelessWidget {
  const OutlinedButtonUi({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
        ),
        padding: const EdgeInsets.symmetric(vertical: 18,horizontal: 110),
      ),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>const signup())
        );
      },
      child: Text(
        "create account".toUpperCase(), style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground ,
          fontWeight: FontWeight.bold
      ),
      ),

    );
  }
}
