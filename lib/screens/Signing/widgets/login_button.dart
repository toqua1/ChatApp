import 'package:chatapp/screens/Signing/widgets/login_button_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../Holding.dart';
import '../../../helper/snackBar.dart';

class LoginButton extends StatefulWidget {
  bool isLoading;
   final ValueNotifier<String?> email;
   final ValueNotifier<String?> pass;
  final GlobalKey<FormState>formKey;

   LoginButton({super.key, required this.isLoading, required this.formKey, required this.email, required this.pass});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: ()async{
        if (widget.formKey.currentState!.validate()) {
          widget.isLoading=true ;
          setState(() {

          });
          try {
            await LoginUser();
            showSnackBar(context, 'Success!') ;
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=> const Holding())
            );
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              showSnackBar(context,'No user found for that email.' ) ;
            } else if (e.code == 'wrong-password') {
              showSnackBar(context,'Wrong password provided for that user.' );
            }else{
              showSnackBar(context ,e.code);
            }
          }
        }
        widget.isLoading=false;
        setState(() {

        });
      }
      ,child: const LoginButtonUi(),
    );
  }

  Future<void> LoginUser() async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: widget.email.value!,
      password: widget.pass.value! ,
    );
  }
}
