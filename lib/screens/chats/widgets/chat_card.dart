import 'package:chatapp/models/userModel.dart';
import 'package:chatapp/screens/chats/screens/chatRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/chat_room_model.dart';
import '../../../models/messageModel.dart';

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
                   chatUser: chatUser,
                 ))
             );
           },
           child :Padding(
             padding: const EdgeInsets.symmetric(vertical: 3.0),
             child: Card(
               child: ListTile(
                 title: Text(chatUser!.name! ,style: const TextStyle(
                     fontSize: 20 ,fontFamily: "serif" ,fontWeight: FontWeight.w500
                 ),),
                 leading: const CircleAvatar(
                   radius: 30,
                   backgroundImage: AssetImage("assetsEdited/toqua5.jpg"),
                 ),
                 trailing: StreamBuilder(/*we use it as we need to get data*/
                   stream:FirebaseFirestore.instance
                   .collection('rooms')
                       .doc(widget.item.id)
                   .collection('messages').snapshots(),
                   builder: (context,snapshot) {
                     if (snapshot.hasData) {
                       final unReadList = snapshot.data!.docs
                           .map((e) => Message.fromJason(e.data()))
                           .where((element) => element.read == "")
                           .where((element) =>
                       element.fromId !=
                           FirebaseAuth.instance.currentUser!.uid) ?? [];

                       return unReadList.isNotEmpty ?
                       Badge(
                         textStyle: const TextStyle(
                             fontWeight: FontWeight.w500
                         ),
                         backgroundColor: Theme
                             .of(context)
                             .colorScheme
                             .primary,
                         textColor: Theme
                             .of(context)
                             .colorScheme
                             .primaryContainer,
                         padding: const EdgeInsets.symmetric(horizontal: 12),
                         label: Text(unReadList.length.toString()),
                         largeSize: 30, /*30*/
                       ) :
                       Text(
                           DateFormat.yMMMEd().format(
                               DateTime.fromMillisecondsSinceEpoch(
                                   int.parse(widget.item.lastMessageTime!)
                               )).toString()
                       );
                     }else{
                       return const CircularProgressIndicator();
                     }
                   }
                 ),
                 subtitle:
                     Text(
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                       widget.item.lastMessage! == "" ?
                       chatUser.about! : widget.item.lastMessage! ,
                       style: const TextStyle(
                           color: Colors.grey
                       ),)
               ),
             ),
           ),
         );
        }else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}
