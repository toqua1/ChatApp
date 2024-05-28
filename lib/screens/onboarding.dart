import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Signing/login.dart';
class onboarding extends StatefulWidget {
  const onboarding({super.key});
State<onboarding> createState()=> _onboardingState();
}
  @override
  class _onboardingState extends State<onboarding>{

    String img="assetsEdited/boarding0.png";
    int index=0 ;
    String txt1="Welcome !";
    String txt2= "Make your profile page with your full information";

    void change(){
      txt1=description1[index];
      txt2=description2[index];
      index++;
      setState((){

      });
    }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Color.fromRGBO(234,228,251,1),
      ),
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                // color: Colors.black
                 size: 20),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body:Container(
          child: Column(
            children: [
             SizedBox(
               height: 60,
             ),
              Center(
                // child: CircleAvatar(
                //   radius: 150,
                child: Container(
                  child: Image.asset(img),
                    // backgroundImage: AssetImage(img),
                ),
                // ),
              ),
              SizedBox(
                height: 60,
              ),
              Column(
                children: [
                  Text(txt1,
                    style: TextStyle(
                     fontSize: 30,fontWeight:FontWeight.w900,
                    ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(txt2,
                          style: TextStyle(
                            // color: Colors.grey ,
                            fontSize: 20,fontWeight: FontWeight.w600 ,
                            color: Theme.of(context).colorScheme.secondary
                          ),
                    textAlign: TextAlign.center,
                    ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                width: 1,
                                color: Theme.of(context).colorScheme.primary
                            ),
                            // backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("SKIP"
                            ,style: TextStyle(
                              fontWeight: FontWeight.bold ,fontSize: 20 ,
                              // color: Colors.black ,
                            ),
                          ),
                          onPressed: (){
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context)=>login())
                            );
                          }
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 130,
                      height: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                width: 1,
                                style: BorderStyle.none,
                                // color: Color.fromRGBO(0, 125, 254,1)
                            ),
                            // backgroundColor: Color.fromRGBO(0, 125, 254,1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("NEXT"
                            ,style: TextStyle(
                              fontWeight: FontWeight.bold ,fontSize: 20 ,
                              // color: Colors.white ,
                            ),
                          ),
                          onPressed: (){
                            if(index==0){
                              change();
                              img="assetsEdited/boarding1.png" ;
                            }
                            else if(index==1){
                              change();
                              img="assetsEdited/boarding3.png" ;
                            }
                            else if(index==2){
                              change();
                              img="assetsEdited/boarding2.png" ;
                            }
                            else if(index>2) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>login())
                              );
                            }
                          }
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
List description1=[
  "Show Your Skills",
  "Get to Know You",
  "Let's Start !"
];
List description2=[
  "Mention your skills from technical to soft skills ,and show your proficiency ",
  "Take a closer look at who you are and your journey. Learn about your background, experiences, and the unique qualities that make you a valuable asset to any team",
  ""
];