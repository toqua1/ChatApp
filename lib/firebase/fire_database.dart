import 'package:chatapp/models/group_model.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_room_model.dart';

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

  Future sendMessage(String uid, String msg, String roomId,
      {String? type}) async {
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
        .set(message.toJson());

    await firestore.collection('rooms').doc(roomId).update({
      'last_message': type ?? msg,
      'last_message_time': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  Future sendGMessage( String msg, String groupId,
      {String? type}) async {
    /*{} to make type optional*/
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
        .set(message.toJson());

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
  Future removeMember(String gId, String memberId) async{
    await firestore.collection('groups').doc(gId).update({
      'members': FieldValue.arrayRemove([memberId])
    });
  }
}
