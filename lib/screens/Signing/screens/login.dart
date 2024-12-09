import 'package:chatapp/screens/Signing/screens/signup.dart';
import 'package:chatapp/screens/Signing/widgets/logo_and_title.dart';
import 'package:chatapp/screens/Signing/widgets/outlined_button_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../Holding.dart';
import '../../../helper/Text/custom_textfield.dart';
import '../../../helper/snackBar.dart';
import 'forget_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController =TextEditingController() ;
  bool showPassword=false;
  String? email ;
  String? pass ;
  bool isLoading=false ;
  GlobalKey<FormState>formKey= GlobalKey() ;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              // Logo and title section
              const Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [LogoAndTitle()],
                ),
              ),
              // Form fields section
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomFormTextfield(
                        label: "Email",
                        name: false,
                        controller: emailController,
                        hintText: "Enter your email",
                        prefixIcon: const Icon(Iconsax.direct),
                        onChange: (data) {
                          email = data;
                        },
                      ),
                      const SizedBox(height: 5),
                      CustomFormTextfield(
                        label: "Password",
                        name: false,
                        controller: passwordController,
                        hintText: "Enter your password",
                        prefixIcon: const Icon(Iconsax.password_check),
                        onChange: (data) {
                          pass = data;
                        },
                        showPassword: showPassword,
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          child: showPassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Iconsax.eye),
                        ),
                      ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgetPass()),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                    ],
                  ),
                ),
              ),
              // Buttons section
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          try {
                            await LoginUser();
                            showSnackBar(context, 'Success!');
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Holding()));
                          } on FirebaseAuthException catch (e) {
                            String message = e.code == 'user-not-found'
                                ? 'No user found for that email.'
                                : e.code == 'wrong-password'
                                ? 'Wrong password provided for that user.'
                                : e.code;
                            showSnackBar(context, message);
                          }
                          setState(() => isLoading = false);
                        }
                      },
                      child: const Button(),
                    ),
                    const SizedBox(height: 20),
                    const OutlinedButtonUi(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> LoginUser() async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: pass! ,
    );
  }

}

class Button extends StatelessWidget {
  const Button({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
    // padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(left: 25,right: 25),
    alignment: Alignment.center,
    // width:64,
    height: 50,
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
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text("Login".toUpperCase(),style: const TextStyle(
        fontWeight: FontWeight.w600 ,color: Colors
        .white, fontSize: 20
    ),),
    );
  }
}