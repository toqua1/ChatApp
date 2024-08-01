import 'package:chatapp/models/group_model.dart';
import 'package:chatapp/screens/groups/widgets/create_group.dart';
import 'package:chatapp/screens/groups/widgets/group_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupsHome extends StatefulWidget {
  const GroupsHome({super.key});

  @override
  State<GroupsHome> createState() => _GroupsHomeState();
}

class _GroupsHomeState extends State<GroupsHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
         Navigator.push(
             context ,
             MaterialPageRoute(builder: (context)
             =>const CreateGroupScreen())
         );
        },
        child: const Icon(Iconsax.message_add),
      ),
      appBar: AppBar(
        title: const Text("Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                    .collection('groups')
                    .where('members',
                    arrayContains:
                      FirebaseAuth.instance.currentUser!.uid
                  ).snapshots(),

                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      List<GroupChat> items =snapshot.data!.docs
                          .map((e) => GroupChat.fromJson(e.data()))
                          .toList()..sort(
                              (a,b) => b.lastMessageTime!.compareTo(a.lastMessageTime!)
                      ); /*to make latest message in the top */

                      if(snapshot.hasData){
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context,index){
                              return GroupCard(groupChat: items[index]);
                            }
                        );
                      }else{
                        return Container();
                      }
                    }else{
                      return Container();
                    }
                  }
                ),
            ),
          ],
        ),
      ),
    );
  }
}
