import 'package:chatapp/Signing/forget_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/Signing/signup.dart';
import 'package:iconsax/iconsax.dart';
import '../Holding.dart';
import '../Text/custom_textfield.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../helper/snackBar.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
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
              icon: const Icon(Icons.arrow_back_ios,
                  size: 20),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body:SingleChildScrollView(
            child: Stack(
              children :[
                Form(
                  key: formKey,
                  child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Column(

                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:[
                                Padding(
                                  padding:EdgeInsets.only(left: 40),
                             child:const Image(image: AssetImage("assetsEdited/logo2.png" )
                             ,width: 100,
                             ),
                            ),
                            SizedBox(
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
                            ),
                          ],
                        ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Padding(
                      padding:const EdgeInsets.symmetric(horizontal: 10),
                     child:  Column(
                      children: [
                        custom_FormTextfield(
                            label: "Email",
                          name:false ,
                            controller: emailController ,
                            hintText:"enter your email" ,
                          prefixIcon: const Icon(Iconsax.direct),
                          onChange: (data){
                              email =data ;
                          },
                            ),
                        const SizedBox(
                          height: 5,
                        ),
                        custom_FormTextfield(
                            label: "Password",
                          name:false ,
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
                                child:showPassword? const Icon(Icons.visibility_off)
                                    :const Icon(Iconsax.eye)
                            ),
                        ),
                      ],
                    ),
                ),
                     Row(
                      children: [
                        Spacer(),
                        Padding(
                          padding:const EdgeInsets.only(right: 5),
                        child:GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>const ForgetPass())
                            );
                          },
                          child: const Text("Forget Password?" ,style: TextStyle(
                            fontWeight: FontWeight.w500
                          ),),
                        ),),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: ()async{
                        if (formKey.currentState!.validate()) {
                          isLoading=true ;
                          setState(() {

                          });
                          try {
                            await LoginUser();
                            showSnackBar(context, 'Success!') ;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=> Holding())
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
                        isLoading=false;
                        setState(() {

                        });
                      }
                      ,child: Container(
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
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
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

                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     const Text("Don't have an account ?"),
                    //     TextButton(
                    //       onPressed: (){
                    //         Navigator.push(context,
                    //             MaterialPageRoute(builder: (context)=>const signup())
                    //         );
                    //       }
                    //       ,child:const Text("Sign up", style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.w600 ,
                    //         // color: Colors.black ,
                    //       decoration: TextDecoration.underline,
                    //     ),
                    //     ),
                    //     ),
                    //   ],
                    // ),
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