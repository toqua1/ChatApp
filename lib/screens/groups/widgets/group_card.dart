import 'package:chatapp/models/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/messageModel.dart';
import '../screens/group_room.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key, required this.groupChat});
 final GroupChat groupChat ;
  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child:Card(
          child: ListTile(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>
                   GroupRoom(chatGroup: groupChat))
              );
            },

            title: Text(groupChat.name ,style: const TextStyle(
                fontSize: 20 ,fontFamily: "serif" ,fontWeight: FontWeight.w500
            ),),
            leading: CircleAvatar(
              radius: 30,
             child: Text(groupChat.name.characters.first),
              // backgroundImage: AssetImage("assetsEdited/toqua5.jpg"),
            ),
            trailing: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(groupChat.id)
                  .collection('messages').snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).colorScheme.primaryContainer,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    label: Text(unReadList.length.toString()),
                    largeSize: 20,/*30*/
                  )
                    :Text(
                      DateFormat.yMMMEd().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(groupChat.lastMessageTime)
                          )).toString()
                  );

                }else{
                  return const CircularProgressIndicator();
                }
              }
            ),
            subtitle: Text(groupChat.lastMessage =='' ?
              'send first message' : groupChat.lastMessage,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.grey
            ),),
          ),
        ),
      );
  }
}
