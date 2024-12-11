
import 'dart:ui';

import 'package:chatapp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomFormTextfield extends StatelessWidget {
 String label ;
 TextEditingController controller ;
 String hintText ;
 bool showPassword= false ;
 bool name=false ;
 Widget? suffixIcon ;
 Widget? prefixIcon ;
 void Function(String)?onChange ;
 CustomFormTextfield({super.key,
   required this.label ,
   required this.controller,
   required this.hintText,
    this.showPassword=false,
     this.suffixIcon ,
   this.prefixIcon,
   this.onChange,
   required this.name
 });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withOpacity(0.3), // Adjust glow
                  // color
                  blurRadius: 12, // Spread of the glow
                  spreadRadius: 3, // Intensity of the glow
                  offset: Offset(0, 0), // Centered glow
                ),
              ],
            ),
            child: TextFormField(
              validator: (data){
                if(data!.isEmpty)
                  return "Field is required" ;
              },
              // style: TextStyle(
              //     color:name? Colors.black54:Theme.of(context).colorScheme.outline
              // ),
              decoration: InputDecoration(
                contentPadding:const EdgeInsets.all(16),
                 focusedBorder:
                 OutlineInputBorder(
                   borderRadius: BorderRadius.circular(15),
                   // borderSide: const BorderSide(width: 2),
                 ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  // borderSide: BorderSide(color:name? Colors.black54:Theme.of(context).colorScheme.outline,width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.red,width: 2),
                ),
                suffixIcon: suffixIcon,
                // suffixIconColor: kPrimaryColor,
                prefixIcon: prefixIcon,
                // prefixIconColor: kPrimaryColor,
                fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
                label: Text(label),
                // labelStyle: TextStyle(color:name? Colors.black54:Theme.of(context).colorScheme.outline),
                hintText: hintText,
                // hintStyle: TextStyle(
                //   color:name? Colors.black54:Theme.of(context).colorScheme.outline
                //   ,fontWeight: FontWeight.w300,
                //   // color: Colors.grey,
                //   fontSize: 15,
                // ),
              ),
              onChanged: onChange,
              controller: controller,
              obscureText: showPassword,

            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
