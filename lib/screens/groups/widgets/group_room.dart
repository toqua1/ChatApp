import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/screens/groups/widgets/group_member_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

import 'group_message_card.dart';

class GroupRoom extends StatefulWidget {
  const GroupRoom({super.key});

  @override
  State<GroupRoom> createState() => _GroupRoomState();
}

class _GroupRoomState extends State<GroupRoom> {
  final _controller =ScrollController() ;
  TextEditingController controller=TextEditingController() ;
  // Create a CollectionReference called users that references the firestore collection
  CollectionReference messages = FirebaseFirestore.instance.collection('messages'); /*we can use it to read and write messages*/

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt').snapshots() , /*Request*/
      builder:(context, snapshot){
        if(snapshot.hasData){
          List<Message>messagesList =[]; /*of type Message model*/
          for(int i=0; i< snapshot.data!.docs.length ;i++){
            messagesList.add(Message.fromJason(snapshot.data!.docs[i]));
          }
          return  Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                   child: Text("G"),
                    // backgroundImage: AssetImage("assetsEdited/toqua5.jpg"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Group Name",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "serif",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Toqua, Eman, Yara,...",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupMemberScreen()));
                  },
                  icon:Icon(Iconsax.user) ,
                ),
                SizedBox(
                  width: 20,
                ),
                // Icon(Icons.videocam),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assetsEdited/img4.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                SingleChildScrollView(
                  child:
                  Column(
                    children: [
                      ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GroupBubbleSend(message: messagesList[index]);
                        },
                        itemCount: messagesList.length,
                        controller: _controller,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 7,
                  right: 10,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(25)
                          ),
                          child: TextField(
                            maxLines: 6,
                            minLines: 1,
                            controller: controller,
                            onSubmitted: (data) {
                              messages.add({
                                'message': data,
                                'createdAt': DateTime.now()
                              }).then((value) => print("Message Added")).catchError(
                                      (error) => print("Failed to add message: $error"));
                              controller.clear();
                              _controller.animateTo(
                                _controller.position.maxScrollExtent,
                                duration: Duration(seconds: 1),
                                curve: Curves.fastOutSlowIn,
                              );
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              hintText: "Message",
                              hintStyle: const TextStyle(
                                // color: Colors.grey,
                              ),
                              prefixIcon: IconButton(
                                onPressed: () {  },
                                icon: Icon(Icons.emoji_emotions_outlined ,
                                  size: 25,),

                              ),
                              suffixIcon: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons
                                        .attach_file_outlined ,size: 27,),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.photo_camera_outlined),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () {},
                        icon: const Icon(Iconsax.send_21),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );


          //    Scaffold (
          //      appBar: AppBar(
          //        title: Row(
          //          children: [
          //            const CircleAvatar(
          //              radius: 20,
          //              backgroundImage: AssetImage("assetsEdited/toqua5.jpg"),
          //            ),
          //            const SizedBox(
          //              width: 10,
          //            ),
          //            Column(
          //              crossAxisAlignment: CrossAxisAlignment.start,
          //              children: [
          //                const Text("Toqua" ,style: TextStyle(
          //                    fontSize: 20 ,fontFamily: "serif" ,fontWeight: FontWeight.w500
          //                ),),
          //                Text("online" ,style: Theme.of(context).textTheme.labelLarge),
          //              ],
          //            ),
          //          ],
          //        ),
          //        actions: const [
          //          Icon(Icons.call) ,
          //          SizedBox(
          //            width: 20,
          //          ),
          //          Icon(Icons.videocam),
          //          SizedBox(
          //            width: 10,
          //          ),
          //        ],
          //      ),
          //      body:
          //        Column(
          //          children: [
          //            Expanded(
          //                child:
          //                ListView.builder(itemBuilder: (context, index) {
          //                  return ChatBubbleSend(message: messagesList[index],);
          //                },
          //                  itemCount: messagesList.length,
          //                   controller: _controller,
          //                   reverse: true,
          //                )
          //            ),
          //            Row(
          //              children: [
          //                Expanded(
          //                  child: Card(
          //                      child: TextField(
          //                        controller: controller,
          //                        onSubmitted: (data){/*data here is object type so it refers to different data types but in add to firestore we use map to refer which data fields to use */
          //                          messages.add({
          //                            'message' :data , /*message here is the key(field) */
          //                            'createdAt' : DateTime.now()
          //                          }).then((value) => print("Message Added"))
          //                              .catchError((error) => print("Failed to add message: $error")) ;
          //                          controller.clear() ;
          //                          _controller.animateTo(
          //                              _controller.position.maxScrollExtent,
          //                              duration: Duration(seconds: 1),
          //                              curve:Curves.fastOutSlowIn ) ;/*or easeIn*/
          //                        },
          //                        decoration: InputDecoration(
          //                          border: OutlineInputBorder(
          //                              borderRadius: BorderRadius.circular(16)
          //                          ),
          //                          hintText: "Message" ,
          //                          hintStyle: const TextStyle(
          //                              color: Colors.grey
          //                          ),
          //                          suffixIcon: Row(
          //                            mainAxisAlignment: MainAxisAlignment.end,
          //                            mainAxisSize: MainAxisSize.min,
          //                            children: [
          //                              IconButton(
          //                                  onPressed: (){
          //
          //                                  },
          //                                  icon: const Icon(Iconsax.emoji_happy)
          //                              ),
          //                              IconButton(
          //                                  onPressed: (){
          //
          //                                  },
          //                                  icon: const Icon(Iconsax.camera)
          //                              ),
          //                            ],
          //                          ),
          //                        ),
          //                      ),
          //                    ),
          //                ),
          //                IconButton.filled(
          //                    onPressed: (){
          //
          //                    },
          //                    icon: const Icon(Iconsax.send_21),
          //                ),
          //              ],
          //            ),
          //        ],
          // ),
          //  );
        }else{
          return const Text("Loading.....") ;
        }
      },
    );
  }
}


// Spacer(),
// Container(
// decoration: const BoxDecoration(
// image: DecorationImage(
//     image: AssetImage("assetsEdited/img4.jpg") ,
//     fit:BoxFit.cover,
//   ),
// ),
//  child: