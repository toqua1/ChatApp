import 'dart:io';
import 'package:chatapp/firebase/fire_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  final FirebaseStorage fireStorage = FirebaseStorage.instance;

  sendImage(
      {required File file, required String roomId, required String uid}) async {
    String ext = file.path.split('.').last;

    final ref = fireStorage.ref().child('image/$roomId/'
        '${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref.putFile(file);

    String imageUrl = await ref.getDownloadURL();
    // print(imageUrl);

    await FireData().sendMessage(uid, imageUrl, roomId, type: 'Photo');
  }

  updateProfileImage(
      {required File file}) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String ext = file.path.split('.').last;

    final ref = fireStorage.ref().child('profile/$uid/'
        '${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref.putFile(file);

    String imageUrl = await ref.getDownloadURL();
    // print(imageUrl);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'image' : imageUrl});

  }
}
