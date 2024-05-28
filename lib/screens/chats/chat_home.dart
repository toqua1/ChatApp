import 'package:chatapp/Text/custom_textfield.dart';
import 'package:chatapp/firebase/fire_auth.dart';
import 'package:chatapp/firebase/fire_database.dart';
import 'package:chatapp/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'chat_card.dart';

class chats extends StatefulWidget {
  const chats({super.key});
  @override
  State<chats> createState() => _chatsState();
}
class _chatsState extends State<chats>{
  final TextEditingController _emailController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: const Text("ChatApp" ,style: TextStyle(
          color: Colors.white ,fontSize: 25 ,fontFamily: "exo" ,letterSpacing: 4
        ),),
        actions: [
          IconButton(
          onPressed: (){

          },
              icon: const Icon(Icons.camera_alt_outlined ,color: Colors.white,size: 27,)
          ),
          IconButton(
              onPressed: (){

              },
              icon: const Icon(Icons.search,color: Colors.white, size: 30,)
          ),
          IconButton(
              onPressed: (){

              },
              icon: const Icon(Icons.more_vert,color: Colors.white,size: 30,),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('rooms')
              .where('members', arrayContains:FirebaseAuth.instance
              .currentUser!.uid )/*we don't need to restore all rooms ,so we
              get only rooms that contain my user id*/
              .snapshots(),

          builder: (BuildContext context, snapshot) {

            if(snapshot.hasData){
              List<ChatRoom> items =snapshot.data!.docs.map((e) => ChatRoom
                  .fromJson(e.data())).toList()..sort(
                  (a,b)=>b.lastMessageTime!.compareTo(a.lastMessageTime!)
              ) ;
              return  ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context ,index){
                    return ChatCard(
                      item: items[index]
                    ) ;
                  }
              );

            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }

          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
              context: context,
              builder: (context){
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text("Enter friend name" ,style: Theme.of
                        (context).textTheme.bodyLarge,
                          ),
                          Spacer(),
                          IconButton.filled(
                              onPressed: (){

                              },
                              icon: Icon(Iconsax.scan_barcode),
                          )
                        ],
                      ),
                      custom_FormTextfield(
                          label: "Email",
                          controller: _emailController ,
                          hintText:"Enter your friend email"
                         , name: false ,
                        prefixIcon: const Icon(Iconsax.direct),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(
                              right: 20 ,left: 20
                              ,bottom: 16 ,top: 16),
                          shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                          ),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer ,
                        ),
                          onPressed: (){
                          if(_emailController.text!="") {
                            FireData().createRoom(_emailController.text);
                           setState(() {
                             _emailController.text="" ;
                           });
                           Navigator.pop(context);
                          }
                            },
                          child:const Center(child: Text("Create Chat")),
                      )
                    ],
                  ),
                );
              }
          );
        },
        child: const Icon(Iconsax.message_add_1),
      ),
    );
  }
}
