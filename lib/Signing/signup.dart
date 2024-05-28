import 'dart:ui';
import 'package:chatapp/firebase/fire_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Text/custom_textfield.dart';
import '../helper/snackBar.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController =TextEditingController() ;
  TextEditingController nameController =TextEditingController() ;
  bool showPassword=false;
  String? email ;
  String? pass ;
  bool isLoading =false;
  GlobalKey<FormState>formKey =GlobalKey() ;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assetsEdited/img6.jpg")
            ,fit:BoxFit.cover,
          ),
        ),
          child:BackdropFilter(
            filter: ImageFilter.blur( //not used here
              sigmaX:0,
              sigmaY:0,
            ),
            child:Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 20),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              body:SingleChildScrollView(
                child: Stack(
                  children :[ Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Column(
                          children: [
                            const Text("Sign Up",style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),),
                            const SizedBox(
                              height: 20,
                            ),
                            Text("Create your account",style: TextStyle(
                              fontSize: 15,color: Colors.grey[600],fontWeight: FontWeight.w400,
                            ),),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:Form(
                        key: formKey ,
                        child: Column(
                          children: [
                            custom_FormTextfield(
                              label: "Name",
                              name:true ,
                              controller: nameController ,
                              prefixIcon: const Icon(Iconsax.user),
                              hintText:"enter your name" ,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            custom_FormTextfield(
                              label: "Email",
                              name:true ,
                              controller: emailController ,
                              hintText:"enter your email" ,
                              prefixIcon: const Icon(Iconsax.direct),
                              onChange: (data){
                                email=data ;
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            custom_FormTextfield(
                              label: "Password",
                              name:true ,
                              controller: passwordController,
                              hintText: "enter your password",
                              prefixIcon: const Icon(Iconsax.password_check),
                              onChange: (data){
                                pass=data ;
                              },
                              showPassword: showPassword,
                              suffixIcon: InkWell(
                                  onTap: (){
                                    if(showPassword==false){
                                      showPassword=true;
                                    }
                                    else{
                                      showPassword=false;
                                    }
                                    showPassword=showPassword;
                                    setState(() {

                                    });
                                  },
                                  child:showPassword? const Icon(Icons.visibility_off,)
                                      :const Icon(Iconsax.eye)
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: ()async{
                           if (formKey.currentState!.validate()) {
                             isLoading =true ;
                             setState(() {

                             });
                           await FirebaseAuth.instance.createUserWithEmailAndPassword(
                         email: email!,
                         password: pass!
                         ).then((value) async {
                           await FirebaseAuth.instance.currentUser!
                               .updateDisplayName(nameController.text).then((value) =>FireAuth.createUser() );
                           showSnackBar(context, 'Created Successfully!') ;
                           Navigator.pop(context) ;
                           })
                         .onError((FirebaseAuthException error, stackTrace) {
                             // showSnackBar(context, error.toString()) ;
                             if (error.code == 'weak-password') {
                               showSnackBar(context ,'Weak Password.');
                             } else if (error.code == 'email-already-in-use') {
                               showSnackBar(context, 'The account already exists for that email.') ;
                             }else{
                               showSnackBar(context ,error.code);
                             }
                         });
                           // isLoading=false ;
                           // setState(() {
                           //
                           // });
                         } else{
                          showSnackBar(context,"Validation Error! ");
                          }
                           isLoading=false ;
                           setState(() {

                           });
                        },
                           child: Container(
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
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text("Register",style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 25 ,color: Colors.white,
                          ),),
                      ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account ?",style: TextStyle(
                            color: Colors.black
                          ),),
                          TextButton(
                            onPressed: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>const login())
                              );
                            }
                            ,child:const Text("Login", style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600 ,
                            color: Colors.black ,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black
                          ),
                          ),
                          ),
                        ],
                      ),
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
     UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email!,
      password:pass!,
    ).then((value) async =>await FireAuth.createUser());
  }
}
