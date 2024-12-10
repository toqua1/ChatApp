import 'package:chatapp/screens/splash_screen/widgets/button.dart';
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
    var size=MediaQuery.of(context).size;

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
                      child: LogoAndTitleForgetPass(size: size),
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
                      height: 20,
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
                      ,child: Button(size: size, t1: "Send Email"),
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

class LogoAndTitleForgetPass extends StatelessWidget {
  const LogoAndTitleForgetPass({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
                Image(image: const AssetImage("assetsEdited/logo2.png" )
                  ,width: size.width*0.5,
                ),
                Text("Reset Password",style: TextStyle(
                  fontSize: size.width*0.09,
                  fontWeight: FontWeight.bold,
                  // color: Colors.white,
                ),),
                const SizedBox(
                  height: 20,
                ),
                Text("Please enter your email ",style: TextStyle(
                  fontSize: size.width*0.045,fontWeight:
                FontWeight.w400,color: Colors.black54
                ),),
      ],
    );
  }
}