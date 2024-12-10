import 'dart:ui';
import 'package:chatapp/firebase/fire_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../helper/Text/custom_textfield.dart';
import '../../../helper/snackBar.dart';
import '../../splash_screen/widgets/button.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool showPassword = false;
  String? email;
  String? pass;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assetsEdited/img6.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            //not used here
            sigmaX: 0,
            sigmaY: 0,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.black, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Create your account",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              CustomFormTextfield(
                                label: "Name",
                                name: true,
                                controller: nameController,
                                prefixIcon: const Icon(Iconsax.user),
                                hintText: "enter your name",
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomFormTextfield(
                                label: "Email",
                                name: true,
                                controller: emailController,
                                hintText: "enter your email",
                                prefixIcon: const Icon(Iconsax.direct),
                                onChange: (data) {
                                  email = data;
                                },
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomFormTextfield(
                                label: "Password",
                                name: true,
                                controller: passwordController,
                                hintText: "enter your password",
                                prefixIcon: const Icon(Iconsax.password_check),
                                onChange: (data) {
                                  pass = data;
                                },
                                showPassword: showPassword,
                                suffixIcon: InkWell(
                                    onTap: () {
                                      if (showPassword == false) {
                                        showPassword = true;
                                      } else {
                                        showPassword = false;
                                      }
                                      showPassword = showPassword;
                                      setState(() {});
                                    },
                                    child: showPassword
                                        ? const Icon(
                                            Icons.visibility_off,
                                          )
                                        : const Icon(Iconsax.eye)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {});
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email!, password: pass!)
                                .then((value) async {
                              await FirebaseAuth.instance.currentUser!
                                  .updateDisplayName(nameController.text)
                                  .then((value) => FireAuth.createUser());
                              showSnackBar(context, 'Created Successfully!');
                              Navigator.pop(context);
                            }).onError(
                                    (FirebaseAuthException error, stackTrace) {
                              // showSnackBar(context, error.toString()) ;
                              if (error.code == 'weak-password') {
                                showSnackBar(context, 'Weak Password.');
                              } else if (error.code == 'email-already-in-use') {
                                showSnackBar(context,
                                    'The account already exists for that email.');
                              } else {
                                showSnackBar(context, error.code);
                              }
                            });
                            // isLoading=false ;
                            // setState(() {
                            //
                            // });
                          } else {
                            showSnackBar(context, "Validation Error! ");
                          }
                          isLoading = false;
                          setState(() {});
                        },
                        child: Button(size: size, t1:  "Register",),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AlreadyHaveAccount(size: size),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> RegisterUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: email!,
          password: pass!,
        )
        .then((value) async => await FireAuth.createUser());
  }
}

class AlreadyHaveAccount extends StatelessWidget {
  const AlreadyHaveAccount({
    super.key, required this.size,
  });
  final Size size ;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Already have an account ?",
          style: TextStyle(color: Colors.black54),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Login()));
          },
          child: const Text(
            "Login",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
