import 'package:chatapp/helper/notification_helper.dart';
import 'package:chatapp/models/group_model.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_room_model.dart';
import 'package:http/http.dart' as http;

class FireData {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String now =DateTime.now().millisecondsSinceEpoch.toString() ; /*not const
  as it always changes */
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

  Future createGroup(String name , List members) async {
    String gId =const Uuid().v1();
    members.add(myUid);
    GroupChat groupRoom = GroupChat(
        id: gId,
        name: name,
        image: '',
        admin: [myUid],
        members: members,
        createdAt: now,
        lastMessage: '',
        lastMessageTime: now,
        );
    await firestore.collection('groups').doc(gId).set(groupRoom.toJson());
  }

  Future addContact(String email) async {
    QuerySnapshot userEmail = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (userEmail.docs.isNotEmpty) {
      String userId = userEmail.docs.first.id;

      firestore.collection('users').doc(myUid).update({
        'my_users': FieldValue.arrayUnion([userId])
      });
    }
  }

  Future sendMessage(String uid, String msg, String roomId,ChatUser chatUser
  ,BuildContext context, {String? type}) async {
    /*{} to make type optional*/
    String msgId = const Uuid().v1(); /*unique time based id*/

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
        .set(message.toJson()).then((value){
          NotificationsHelper().sendNotifications(chatUser: chatUser,
              context: context, msg: msg, userId: uid ,type: type);
    });

    await firestore.collection('rooms').doc(roomId).update({
      'last_message': type ?? msg,
      'last_message_time': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  Future sendGMessage( String msg, String groupId,GroupChat chatGroup
  ,BuildContext context,{String? type}) async {
    /*{} to make type optional*/
    List<ChatUser> chatUsers = [];
    /*remove me from users that i should send msg to*/
    chatGroup.members = chatGroup.members.where((element) => element != myUid)
        .toList();
    firestore.collection('users').where('id' ,whereIn: chatGroup.members).get()
    .then((value) => chatUsers.addAll(value.docs.map((e) => ChatUser.fromJson
      (e.data()))));

    String msgId = const Uuid().v1(); /*unique time based id*/

    Message message = Message(
        id: msgId,
        fromId: myUid,
        toId: '',
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        read: '',
        type: type ?? 'text',
        message: msg);

    await firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(msgId)
        .set(message.toJson()).then((value){
          for (var element in chatUsers){
            NotificationsHelper().sendNotifications(
                chatUser: element,
                context: context,
                msg: msg,
              userId: element.id!,
              groupName: chatGroup.name
            );
          }
    });

    await firestore.collection('groups').doc(groupId).update({
      'last_message': type ?? msg,
      'last_message_time': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  Future readMessage(String roomId, String msgId) async {
    await firestore
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
    if (msgs.length == 1) {
      await firestore
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(msgs.first)
          .delete();
    } else {
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
  Future editGroup(String gId ,String name ,List members) async{
    await firestore.collection('groups').doc(gId).update(
      {
        'name': name ,
        'members': FieldValue.arrayUnion(members),
      }
    );
  }
  Future promptAdmin(String gId ,String memberId) async{
    await firestore.collection('groups').doc(gId).update(
        {
          'admins_id': FieldValue.arrayUnion([memberId]),
        }
    );
  }
  Future removeAdmin(String gId ,String memberId) async{
    await firestore.collection('groups').doc(gId).update(
        {
          'admins_id': FieldValue.arrayRemove([memberId]),
        }
    );
  }
  Future removeMember(String gId, String memberId) async{
    await firestore.collection('groups').doc(gId).update({
      'members': FieldValue.arrayRemove([memberId])
    });
  }
  Future editProfile(String name , String about)async{
    await firestore
        .collection('users')
        .doc(myUid)
        .update({
      'name':name,
      'about':about
    });

  }
}
