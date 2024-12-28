//     await firestore
//         .collection('rooms')
//         .doc(roomId)
//         .collection('messages')
//         .doc(msgId)
//         .update({
//       'read': DateTime.now().millisecondsSinceEpoch.toString()
//     }); /*
//          key and
//         value*/
//   }
//
//   deleteMsg(String roomId, List<String> msgs) async {
//     if (msgs.length == 1) {
//       await firestore
//           .collection('rooms')
//           .doc(roomId)
//           .collection('messages')
//           .doc(msgs.first)
//           .delete();
//     } else {
//       for (var element in msgs) {
//         await firestore
//             .collection('rooms')
//             .doc(roomId)
//             .collection('messages')
//             .doc(element)
//             .delete();
//       }
//     }
//   }
//   Future editGroup(String gId ,String name ,List members) async{
//     await firestore.collection('groups').doc(gId).update(
//       {
//         'name': name ,
//         'members': FieldValue.arrayUnion(members),
//       }
//     );
//   }
//   Future promptAdmin(String gId ,String memberId) async{
//     await firestore.collection('groups').doc(gId).update(
//         {
//           'admins_id': FieldValue.arrayUnion([memberId]),
//         }
//     );
//   }
//   Future removeAdmin(String gId ,String memberId) async{
//     await firestore.collection('groups').doc(gId).update(
//         {
//           'admins_id': FieldValue.arrayRemove([memberId]),
//         }
//     );
//   }
//   Future removeMember(String gId, String memberId) async{
//     await firestore.collection('groups').doc(gId).update({
//       'members': FieldValue.arrayRemove([memberId])
//     });
//   }
// }
import 'package:chatapp/helper/notification_helper.dart';
import 'package:chatapp/models/group_model.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/models/userModel.dart';
import 'package:chatapp/models/chat_room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';

class FireData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _myUid = FirebaseAuth.instance.currentUser!.uid;
  final String _currentTime = DateTime.now().millisecondsSinceEpoch.toString();

  // Create a chat room if it doesn't exist
  Future<void> createRoom(String email) async {
    try {
      final userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isEmpty) return;

      final String userId = userSnapshot.docs.first.id;
      final List<String> members = [_myUid, userId]..sort();

      final roomSnapshot = await _firestore
          .collection('rooms')
          .where('members', isEqualTo: members)
          .get();

      if (roomSnapshot.docs.isEmpty) {
        final ChatRoom chatRoom = ChatRoom(
          id: members.toString(),
          createdAt: _currentTime,
          lastMessage: "",
          lastMessageTime: _currentTime,
          members: members,
        );
        await _firestore.collection('rooms').doc(members.toString()).set(
              chatRoom.toJson(),
              SetOptions(merge: true), // Prevent overwriting if the room exists
            );
      }
    } catch (e) {
      debugPrint("Error creating room: $e");
    }
  }

  // Create a group chat
  Future<void> createGroup(String name, List<dynamic> members) async {
    try {
      if (!members.contains(_myUid)) {
        members.add(_myUid);
      }

      final String groupId = const Uuid().v1();
      final GroupChat groupChat = GroupChat(
        id: groupId,
        name: name,
        image: '',
        admin: [_myUid],
        members: members,
        createdAt: _currentTime,
        lastMessage: '',
        lastMessageTime: _currentTime,
      );
      await _firestore
          .collection('groups')
          .doc(groupId)
          .set(groupChat.toJson());

      // Fetch user details for the group
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('id', whereIn: members)
          .get();

      List<ChatUser> chatUsers = userSnapshot.docs
          .map((e) => ChatUser.fromJson(e.data() as Map<String, dynamic>))
          .toList();

      debugPrint("Group users fetched: ${chatUsers.length}");
    } catch (e) {
      debugPrint("Error creating group: $e");
    }
  }

  // Add a user to contacts
  Future<void> addContact(String email) async {
    try {
      final userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isEmpty) return;

      final String userId = userSnapshot.docs.first.id;
      await _firestore.collection('users').doc(_myUid).update({
        'my_users': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      debugPrint("Error adding contact: $e");
    }
  }

  // Send a message in a chat room
  Future<void> sendMessage(
    String uid,
    String msg,
    String roomId,
    ChatUser chatUser,
    BuildContext context, {
    String? type,
  }) async {
    try {
      final String msgId = const Uuid().v1();
      final Message message = Message(
        id: msgId,
        fromId: _myUid,
        toId: uid,
        createdAt: _currentTime,
        read: '',
        type: type ?? 'text',
        message: msg,
      );

      await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(msgId)
          .set(message.toJson());

      await NotificationsHelper().sendNotifications(
        chatUser: chatUser,
        context: context,
        msg: msg,
        userId: uid,
        type: type,
      );

      await _firestore.collection('rooms').doc(roomId).update({
        'last_message': type ?? msg,
        'last_message_time': _currentTime,
      });
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  // Mark message as read
  Future<void> readMessage(String roomId, String msgId) async {
    try {
      await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(msgId)
          .update({'read': _currentTime});
    } catch (e) {
      debugPrint("Error reading message: $e");
    }
  }

  // Delete one or multiple messages
  Future<void> deleteMsg(String roomId, List<String> msgIds) async {
    try {
      final batch = _firestore.batch();

      for (final msgId in msgIds) {
        final msgRef = _firestore
            .collection('rooms')
            .doc(roomId)
            .collection('messages')
            .doc(msgId);
        batch.delete(msgRef);
      }

      await batch.commit();
    } catch (e) {
      debugPrint("Error deleting messages: $e");
    }
  }

  // Update group name and add members
  Future<void> editGroup(
      String groupId, String name, List<dynamic> members) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'name': name,
        'members': FieldValue.arrayUnion(members),
      });
    } catch (e) {
      debugPrint("Error editing group: $e");
    }
  }

  // Promote a member to admin
  Future<void> promoteAdmin(String groupId, String memberId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'admin': FieldValue.arrayUnion([memberId]),
      });
    } catch (e) {
      debugPrint("Error promoting admin: $e");
    }
  }

  // Remove an admin from the group
  Future<void> removeAdmin(String groupId, String memberId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'admin': FieldValue.arrayRemove([memberId]),
      });
    } catch (e) {
      debugPrint("Error removing admin: $e");
    }
  }

  // Remove a member from the group
  Future<void> removeMember(String groupId, String memberId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayRemove([memberId]),
      });
    } catch (e) {
      debugPrint("Error removing member: $e");
    }
  }

  //edit profile
  Future<void> editProfile(String name, String about) async {
    try {
      await _firestore
          .collection('users')
          .doc(_myUid)
          .update({'name': name, 'about': about});
    } catch (e) {
      debugPrint("Error editing profile: $e");
    }
  }

  // Send a message in a group chat
  Future<void> sendGMessage({
    required String messageContent,
    required String groupId,
    required GroupChat groupChat,
    required BuildContext context,
    String? messageType,
  }) async {
    try {
      // Step 1: Prepare recipients - exclude the current user
      List recipients =
          groupChat.members.where((uid) => uid != _myUid).toList();

      // Step 2: Fetch user details of the group members
      List<ChatUser> chatUsers = await _fetchGroupMembers(recipients);

      // Step 3: Create the message
      String messageId = const Uuid().v1();
      Message message = Message(
        id: messageId,
        fromId: _myUid,
        toId: '',
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        read: '',
        type: messageType ?? 'text',
        message: messageContent,
      );

      // Step 4: Save message to Firestore
      await _saveMessageToFirestore(groupId, message, messageId);

      // Step 5: Send notifications to group members
      for (var user in chatUsers) {
        NotificationsHelper().sendNotifications(
          chatUser: user,
          context: context,
          msg: messageContent,
          userId: user.id!,
          groupName: groupChat.name,
        );
      }

      // Step 6: Update group with last message info
      await _updateGroupLastMessage(groupId, messageContent, messageType);
    } catch (e) {
      debugPrint("Error sending group message: $e");
    }
  }

  /// Helper method to fetch group members' details
  Future<List<ChatUser>> _fetchGroupMembers(List<dynamic> memberIds) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('id', whereIn: memberIds)
          .get();

      return snapshot.docs
          .map((doc) => ChatUser.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint("Error fetching group members: $e");
      return [];
    }
  }

  /// Helper method to save the message to Firestore
  Future<void> _saveMessageToFirestore(
      String groupId, Message message, String messageId) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());
  }

  /// Helper method to update the group's last message and time
  Future<void> _updateGroupLastMessage(
      String groupId, String lastMessage, String? messageType) async {
    await _firestore.collection('groups').doc(groupId).update({
      'last_message': messageType ?? lastMessage,
      'last_message_time': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }
}
