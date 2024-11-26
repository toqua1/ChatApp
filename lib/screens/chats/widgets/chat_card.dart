import 'package:chatapp/models/userModel.dart';
import 'package:chatapp/screens/chats/screens/chatRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../models/chat_room_model.dart';
import 'chat_card_row.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({
    super.key,
    required this.item
  });
  final ChatRoom item ;
  @override
  State<ChatCard> createState() => _ChatCardState();
}
class _ChatCardState extends State<ChatCard>{

  @override
  Widget build(BuildContext context) {
    List member=widget.item.members!.where((element) => element !=
        FirebaseAuth
            .instance.currentUser!.uid).toList() ;
    String userId= member.isEmpty ?
         FirebaseAuth.instance.currentUser!.uid
         : member.first; /*['id'] => 'id' */

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots() ,
      builder:(context ,snapshot){
        // ChatUser? chatUser=ChatUser.fromJson(snapshot.data!.data()!);
        ChatUser? chatUser = snapshot.data?.data() != null ?
        ChatUser.fromJson(snapshot.data!.data()!) : null;
        if(snapshot.hasData){
         return InkWell(
           onTap: (){
             Navigator.push(context,
                 MaterialPageRoute(builder: (context)=>ChatRoomItem(
                   roomId: widget.item.id!,
                   chatUser: chatUser!,
                 ))
             );
           },
           child :Padding(
             padding: const EdgeInsets.symmetric(vertical: 3.0),
             child: Card(
               child:Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                 child: ChatCardRow(chatUser: chatUser, widget: widget),
               ),
               ),
           ),
         );
        }else{
          return Container();
        }
      }
    );
  }
}

