import 'package:chatapp/helper/snackBar.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../models/room_model.dart';
import 'package:uuid/uuid.dart';

class FireData {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String myUid = FirebaseAuth.instance.currentUser!.uid;

  createRoom(String email) async {
    QuerySnapshot userEmail = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (userEmail.docs.isNotEmpty) {
      String userId = userEmail.docs.first
          .id; /* here may return multiple emails
   but in my case , i have unique emails so i use first although value of
   first== last in my case but first is more accurate ,and id here is
   representation of doc id*/

      List<String> members = [myUid, userId]..sort((a, b) => a.compareTo(b));
      /*specify String type to appear compare to*/

      QuerySnapshot roomExits = await firestore
          .collection('rooms')
          .where('members', isEqualTo: members)
          .get();

      if (roomExits.docs.isEmpty) {
        ChatRoom chatRoom = ChatRoom(
          id: members.toString(),
          createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
          lastMessage: "",
          lastMessageTime: DateTime.now().millisecondsSinceEpoch.toString(),
          members: members,
        );
        await firestore
            .collection('rooms')
            .doc(members.toString())
            .set(chatRoom.toJson());
      }
    }
    // else {
    // showSnackBar(context, "Email doesn't exist");
    // }
  }

  Future sendMessage(String uid, String msg, String roomId,
      {String? type}) async {
    /*{} to make type optional*/
    String msgId = Uuid().v1(); /*unique time based id*/
    Message message = Message(
        id: msgId,
        fromId: myUid,
        toId: uid,
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        read: '',
        type: type ?? 'text',
        message: msg);
    await firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(msgId)
        .set(message.toJson());

    await firestore.collection('rooms').doc(roomId).update({
      'last_message':type ?? msg,
      'last_message_time': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  Future readMessage(String roomId, String msgId) async {
    firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(msgId)
        .update({
      'read': DateTime.now().millisecondsSinceEpoch.toString()
    }); /*
         key and
        value*/
  }

  deleteMsg(String roomId, List<String> msgs) async {
    for (var element in msgs) {
      await firestore
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(element)
          .delete();
    }
  }
}
