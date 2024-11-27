import 'package:chatapp/firebase/fire_auth.dart';
import 'package:chatapp/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderApp extends ChangeNotifier{
ThemeMode themeMode=ThemeMode.system;
int mainColor = 0xffA020F0;
ChatUser? me;

getUserDetails()async{
  String myId = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
  .collection('users')
  .doc(myId).get()
  .then((value) => me = ChatUser.fromJson(value.data()!));
  FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.getToken().then(
      (value){
        if(value != null){
          me!.puchToken = value ;
          FireAuth().getToken(value);
        }
      }
  );
  notifyListeners();
}
changeMode(bool dark)async{
  final SharedPreferences sharedPreferences=
  await SharedPreferences.getInstance();
   themeMode = dark ? ThemeMode.dark : ThemeMode.light;
   sharedPreferences.setBool('dark', themeMode == ThemeMode.dark);
  notifyListeners();
}
changeColor(int c)async{
  final SharedPreferences sharedPreferences=
  await SharedPreferences.getInstance();
  mainColor=c;
  sharedPreferences.setInt('color', mainColor);
  notifyListeners();
}
getValuesPref()async{
  final SharedPreferences sharedPreferences=
  await SharedPreferences.getInstance();
  bool isDark=sharedPreferences.getBool('dark') ?? false;
  themeMode = isDark ? ThemeMode.dark : ThemeMode.light ;
  mainColor=sharedPreferences.getInt('color') ?? 0xffA020F0;
 notifyListeners();/*as i still change in provider*/
}
}