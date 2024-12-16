import 'package:chatapp/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  static FirebaseAuth auth =FirebaseAuth.instance ;
  static FirebaseFirestore firebaseFirestore =FirebaseFirestore.instance ;

 static User user =auth.currentUser! ;

  static Future createUser() async{
    ChatUser chatUser =ChatUser(
        id: user.uid,
        name: user.displayName ?? "",
        email: user.email ?? "",
        about: "Hello, I'm Available",
        image: '',
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        lastActivated: DateTime.now().millisecondsSinceEpoch.toString(),
        puchToken: '',
        online: false,
        myUsers: []
    );
 await firebaseFirestore.collection('users').doc(user.uid).set(chatUser.toJson
      ());
  }
  Future getToken(String token)async{
    await firebaseFirestore.collection('users')
        .doc(auth.currentUser!.uid).update({
      'puch_token':token,
    });
  }
  Future updateActivate(bool online)async{
    await firebaseFirestore.collection('users')
        .doc(auth.currentUser!.uid).update({
      'last_activated': DateTime.now().millisecondsSinceEpoch.toString(),
      'online':online,/*it work only when i make it after last_activated , in
       the same order in Firebase */
    });
  }
}