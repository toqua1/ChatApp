import 'dart:io';
import 'package:chatapp/firebase/fire_database.dart';
import 'package:path/path.dart';

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

    await FireData().sendMessage(uid, imageUrl, roomId, type: 'image');
  }
}
