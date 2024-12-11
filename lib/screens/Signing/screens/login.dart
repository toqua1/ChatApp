import 'package:chatapp/screens/Signing/screens/signup.dart';
import 'package:chatapp/screens/Signing/widgets/logo_and_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../Holding.dart';
import '../../../helper/Text/custom_textfield.dart';
import '../../../helper/snackBar.dart';
import '../../splash_screen/widgets/button.dart';
import 'forget_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  String? email;
  String? pass;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
         automaticallyImplyLeading: false,
        ),
        resizeToAvoidBottomInset: true, // Ensure body resizes with keyboard
        body: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                // Main layout using Expanded inside SliverFillRemaining
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      // Logo and title section (flex: 3)
                      const Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [LogoAndTitle()],
                        ),
                      ),
                      // Form fields section (flex: 4)
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
                              const Align(
                                alignment: Alignment.centerRight,
                                child: ForgetPassPart(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Buttons section (flex: 2)
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
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>const Holding
                                            ()),
                                          (Route<dynamic> route) => false, // Removes all routes
                                    );
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
                              child:Center(
                             child: Button(size: size, t1: 'Login'),
                              ),
                            ),
                            const SizedBox(height: 20),
                            NotHaveAccount(size: size),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
            ),
      ),
    );
  }

  Future<void> LoginUser() async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: pass!,
    );
  }
}

class ForgetPassPart extends StatelessWidget {
  const ForgetPassPart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          style: TextStyle(fontWeight: FontWeight.w500,),
        ),
      ),
    );
  }
}

class NotHaveAccount extends StatelessWidget {
  const NotHaveAccount({
    super.key,
    required this.size,
  });
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account ?",
          // style: TextStyle(color: Colors.black54),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUp()));
          },
          child: Text(
            "Sign up",
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
