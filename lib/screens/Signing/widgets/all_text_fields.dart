import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../helper/Text/custom_textfield.dart';

class AllTextFields extends StatefulWidget {
  final ValueNotifier<String?> email;
  final ValueNotifier<String?> pass;
   const AllTextFields({super.key, required this.email, required this.pass});

  @override
  State<AllTextFields> createState() => _AllTextFieldsState();
}

class _AllTextFieldsState extends State<AllTextFields> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController=TextEditingController();
    TextEditingController passwordController =TextEditingController() ;
    bool showPassword=false;

    return Column(
      children: [
        CustomFormTextfield(
          label: "Email",
          name:false ,
          controller: emailController ,
          hintText:"enter your email" ,
          prefixIcon: const Icon(Iconsax.direct),
          onChange: (data){
            widget.email.value =data ;
          },
        ),
        const SizedBox(
          height: 5,
        ),
        CustomFormTextfield(
          label: "Password",
          name:false ,
          controller: passwordController,
          hintText: "enter your password",
          prefixIcon: const Icon(Iconsax.password_check),
          onChange: (data){
            widget.pass.value=data ;
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
    );
  }
}
