import 'package:flutter/material.dart';

// void showSnackBar(BuildContext context ,String message) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message))) ;
// }
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.purple.withOpacity(0.6),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(16.0),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: Colors.black,
        onPressed: () {
          // Add your undo logic here
        },
      ),
    ),
  );
}
