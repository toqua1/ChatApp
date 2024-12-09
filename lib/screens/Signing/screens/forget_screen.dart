import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../helper/Text/custom_textfield.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass ({super.key});

  @override
  State<ForgetPass> createState() => _forgetpassState();
}

class _forgetpassState extends State<ForgetPass> {
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
                    const Center(
                      child: Column(
                        children: [
                                  Image(image: AssetImage("assetsEdited/logo2.png" )
                                    ,width: 150,
                                  ),
                                  Text("Reset Password",style: TextStyle(
                                    fontSize: 40,fontWeight: FontWeight.bold,
                                    // color: Colors.white,
                                  ),),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Please enter your email ",style: TextStyle(
                                    fontSize: 15,fontWeight: FontWeight.w400,
                                  ),),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding:const EdgeInsets.symmetric(horizontal: 10),
                      child:  Column(
                        children: [
                          CustomFormTextfield(
                            label: "Email",
                            name:false ,
                            controller: emailController ,
                            hintText:"enter your email" ,
                            prefixIcon: const Icon(Iconsax.direct),
                            onChange: (data){
                              email =data ;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async{
                       await FirebaseAuth.instance
                           .sendPasswordResetEmail(
                           email: emailController.text)
                           .then((value) => {
                       Navigator.pop(context),
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(
                             content:Text("Email sent check your email")
                           ))
                       }).onError((error, stackTrace) =>{
                        ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                        content:Text(error.toString())))});
                      }
                      ,child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(left: 25,right: 25),
                      alignment: Alignment.center,
                      width: 300,
                      height:65,
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
                      child: Text("send email".toUpperCase(),style: const
                      TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 25 ,color: Colors.white,
                      ),),
                    ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}