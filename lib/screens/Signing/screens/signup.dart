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
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      // child: Container(
      //   decoration: const BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage("assetsEdited/back2.jpg"),
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      //   child: BackdropFilter(
      //     filter: ImageFilter.blur(
      //       sigmaX: 0,
      //       sigmaY: 0,
      //     ),
          child: Scaffold(
            // backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const Center(
                        child: SignTitleAndSub(),
                      ),
                      SizedBox(
                        height: size.height * 0.1,
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
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                  child: Icon(
                                    showPassword ? Icons.visibility_off : Iconsax.eye,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() => isLoading = true);
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                  email: email!, password: pass!)
                                  .then((value) async {
                                await FirebaseAuth.instance.currentUser!
                                    .updateDisplayName(nameController.text);
                                FireAuth.createUser();
                                showSnackBar(context, 'Created Successfully!');
                                Navigator.pop(context);
                              });
                            } on FirebaseAuthException catch (error) {
                              if (error.code == 'weak-password') {
                                showSnackBar(context, 'Weak Password.');
                              } else if (error.code == 'email-already-in-use') {
                                showSnackBar(context,
                                    'The account already exists for that email.');
                              } else {
                                showSnackBar(context, error.code);
                              }
                            } finally {
                              setState(() => isLoading = false);
                            }
                          } else {
                            showSnackBar(context, "Validation Error!");
                          }
                        },
                        child: Button(size: size, t1: "Register"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AlreadyHaveAccount(size: size),
                    ],
                  ),
                ),
              ],
            ),
          ),
        // ),
      // ),
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

class SignTitleAndSub extends StatelessWidget {
  const SignTitleAndSub({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            // color: Colors.white,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Create your account",
          style: TextStyle(
            fontSize: 13,
            // color: Colors.grey[100],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
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
          // style: TextStyle(color: Colors.white70),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Login()));
          },
          child: Text(
            "Login",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.purple.shade300,
            ),
          ),
        ),
      ],
    );
  }
}
