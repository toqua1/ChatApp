import 'dart:io';
import 'package:path/path.dart';
import 'package:chatapp/firebase/fire_database.dart';
import 'package:chatapp/firebase/fire_storage.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/models/userModel.dart';
import 'package:chatapp/screens/chats/chatBubbleRecieve.dart';
import 'package:chatapp/screens/chats/chatBubbleSend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatRoomItem extends StatefulWidget {
  const ChatRoomItem({super.key, required this.roomId, required this.chatUser});
  final String roomId;
  final ChatUser chatUser;
  @override
  State<ChatRoomItem> createState() => _ChatRoomItemState();
}

class _ChatRoomItemState extends State<ChatRoomItem> {
  List<String> selectedMsg = [];
  List<String> copyMsg = [];
  late File _image;
  final _controller = ScrollController();
  TextEditingController msgController = TextEditingController();
  // Create a CollectionReference called users that references the firestore collection
  CollectionReference messages = FirebaseFirestore.instance
      .collection('messages'); /*we can use it to read and write messages*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assetsEdited/toqua5.jpg"),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatUser.name!,
                  /*using widget as we are
                          inside stateful widget */
                  style: const TextStyle(
                      fontSize: 20,
                      fontFamily: "serif",
                      fontWeight: FontWeight.w500),
                ),
                Text(
                    DateFormat.MMMMEEEEd()
                        .add_jm()
                        .format(DateTime.parse(widget.chatUser.lastActivated!)),
                    style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ],
        ),
        actions: selectedMsg.isEmpty
            ? [
                Icon(Icons.call),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.videocam),
                SizedBox(
                  width: 10,
                ),
              ]
            : [
                IconButton(
                    onPressed: () {
                      FireData().deleteMsg(widget.roomId, selectedMsg);
                      setState(() {
                        selectedMsg.clear();
                        copyMsg.clear();
                      });
                    },
                    icon: const Icon(Iconsax.trash)),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text: copyMsg.join(
                              '\n') /*join will convert list to
                            string*/
                          ));
                      setState(() {
                        copyMsg.clear();
                        selectedMsg.clear();
                      });
                    },
                    icon: const Icon(Iconsax.copy)),
              ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(widget.roomId)
                  .collection('messages')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Message> messageItems = snapshot.data!.docs
                      .map((e) => Message.fromJason(e.data()))
                      .toList()
                    ..sort(
                      (a, b) => b.createdAt!.compareTo(a.createdAt!),
                    );
                  return messageItems.isNotEmpty
                      ? ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            bool isMe = messageItems[index].fromId ==
                                FirebaseAuth.instance.currentUser!.uid;
                            if (isMe) {
                              return GestureDetector(
                                child: ChatBubbleSend(
                                  messageItem: messageItems[index],
                                  selected: selectedMsg
                                      .contains(messageItems[index].id),
                                ),
                                onLongPress: () {
                                  setState(() {
                                    selectedMsg.contains(messageItems[index].id)
                                        ? selectedMsg
                                            .remove(messageItems[index].id)
                                        : selectedMsg
                                            .add(messageItems[index].id!);
                                    messageItems[index].type == 'text'
                                        ? copyMsg.contains(
                                                messageItems[index].message)
                                            ? copyMsg.remove(
                                                messageItems[index].message)
                                            : copyMsg.add(
                                                messageItems[index].message!)
                                        : null;
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                    selectedMsg.length > 0
                                        ? selectedMsg.contains(
                                                messageItems[index].id)
                                            ? selectedMsg
                                                .remove(messageItems[index].id)
                                            : selectedMsg
                                                .add(messageItems[index].id!)
                                        : null;
                                    copyMsg.isNotEmpty
                                        ? messageItems[index].type == 'text'
                                            ? copyMsg.contains(
                                                    messageItems[index].message)
                                                ? copyMsg.remove(
                                                    messageItems[index].message)
                                                : copyMsg.add(
                                                    messageItems[index]
                                                        .message!)
                                            : null
                                        : null;
                                  });
                                },
                              );
                            } else {
                              return GestureDetector(
                                child: ChatBubbleRecieve(
                                  messageItem: messageItems[index],
                                  roomId: widget.roomId,
                                  selected: selectedMsg
                                      .contains(messageItems[index].id),
                                ),
                                onLongPress: () {
                                  setState(() {
                                    selectedMsg.contains(messageItems[index].id)
                                        ? selectedMsg
                                            .remove(messageItems[index].id)
                                        : selectedMsg
                                            .add(messageItems[index].id!);
                                    messageItems[index].type == 'text'
                                        ? copyMsg.contains(
                                                messageItems[index].message)
                                            ? copyMsg.remove(
                                                messageItems[index].message)
                                            : copyMsg.add(
                                                messageItems[index].message!)
                                        : null;
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                    selectedMsg.length > 0
                                        ? selectedMsg.contains(
                                                messageItems[index].id)
                                            ? selectedMsg
                                                .remove(messageItems[index].id)
                                            : selectedMsg
                                                .add(messageItems[index].id!)
                                        : null;
                                    copyMsg.isNotEmpty
                                        ? messageItems[index].type == 'text'
                                            ? copyMsg.contains(
                                                    messageItems[index].message)
                                                ? copyMsg.remove(
                                                    messageItems[index].message)
                                                : copyMsg.add(
                                                    messageItems[index]
                                                        .message!)
                                            : null
                                        : null;
                                  });
                                },
                              );
                            }
                          },
                          itemCount: messageItems.length,
                          // messagesList.length,
                          controller: _controller,
                        )
                      : Center(
                          child: GestureDetector(
                            onTap: () => FireData().sendMessage(
                                widget.chatUser.id!, " HEY !! ", widget.roomId),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      "assetsEdited/hiSticker1"
                                      ".gif",
                                      width: 200,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                } else {
                  return Center(
                    child: Container(),
                  );
                }
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: TextField(
                    maxLines: 6,
                    minLines: 1,
                    controller: msgController,
                    onSubmitted: (data) {
                      /*data here is object type so it refers to different data types but in add to firestore we use map to refer which data fields to use */
                      messages
                          .add({
                            'message': data,
                            /*message here is the key(field) */
                            'createdAt': DateTime.now()
                          })
                          .then((value) => print("Message Added"))
                          .catchError((error) =>
                              print("Failed to add message: $error"));
                      msgController.clear();
                      _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          duration: Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn); /*or easeIn*/
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      hintText: "Message",
                      hintStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Iconsax.emoji_happy)),
                          IconButton(
                              onPressed: () async {
                                ImagePicker picker = ImagePicker();
                                XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (image != null) {
                                  FireStorage().sendImage(
                                      file: File(image.path),
                                      roomId: widget.roomId,
                                      uid: widget.chatUser.id!);
                                  // print(image.path);
                                }
                              },
                              icon: const Icon(Iconsax.camera)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              IconButton.filled(
                onPressed: () {
                  if (msgController.text.isNotEmpty) {
                    FireData()
                        .sendMessage(widget.chatUser.id!, msgController.text,
                            widget.roomId)
                        .then((value) => setState(() {
                              msgController.text = "";
                              // Navigator.pop(context);
                            }));
                  }
                },
                icon: const Icon(Iconsax.send_21),
              ),
            ],
          ),
        ],
      ),
    );

    //   Scaffold(
    //   appBar: AppBar(
    //     title: Row(
    //       children: [
    //         const CircleAvatar(
    //           radius: 20,
    //           backgroundImage: AssetImage("assetsEdited/toqua5.jpg"),
    //         ),
    //         const SizedBox(
    //           width: 10,
    //         ),
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //              Text(
    //                widget.chatUser.name!,/*using widget as we are
    //                inside stateful widget */
    //               style: TextStyle(
    //                 fontSize: 20,
    //                 fontFamily: "serif",
    //                 fontWeight: FontWeight.w500,
    //               ),
    //             ),
    //             Text(
    //               widget.chatUser.lastActivated!,
    //               style: Theme.of(context).textTheme.labelLarge,
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //     actions: const [
    //       Icon(Icons.call),
    //       SizedBox(
    //         width: 10,
    //       ),
    //       Icon(Icons.videocam),
    //       SizedBox(
    //         width: 10,
    //       ),
    //     ],
    //   ),
    //   body: Stack(
    //     children: [
    //       // Positioned.fill(
    //       //   child: Image.asset(
    //       //     "assetsEdited/img4.jpg",
    //       //     fit: BoxFit.cover,
    //       //   ),
    //       // ),
    //       SingleChildScrollView(
    //         child:
    //         Column(
    //           children: [
    //             StreamBuilder(
    //               stream: FirebaseFirestore.instance.collection
    //                 ('rooms').doc(widget.roomId).collection
    //                 ('messages').snapshots(),
    //               builder: (context, snapshot){
    //                 if(snapshot.hasData) {
    //                  return ListView.builder(
    //                     reverse: true,
    //                     shrinkWrap: true,
    //                     itemBuilder: (context, index) {
    //                       return ChatBubbleSend(
    //                         // message:
    //                         // messagesList[index]
    //                       );
    //                     },
    //                     itemCount: snapshot.data!.docs.length,
    //                     // messagesList.length,
    //                     controller: _controller,
    //                   );
    //                 }else{
    //                  return Center(
    //                     child: Container(
    //
    //                     ),
    //                   );
    //                 }
    //               },
    //             ),
    //             SizedBox(
    //               height: 100,
    //             ),
    //           ],
    //         ),
    //       ),
    //       Positioned(
    //         bottom: 5,
    //         left: 7,
    //         right: 10,
    //         child: Row(
    //           children: [
    //             Expanded(
    //                 child: Container(
    //                   decoration: BoxDecoration(
    //                     color: Theme.of(context).colorScheme.background,
    //                     borderRadius: BorderRadius.circular(25)
    //                   ),
    //                   child: TextField(
    //                     maxLines: 6,
    //                     minLines: 1,
    //                     controller: msgController,
    //                     onSubmitted: (data) {
    //                       messages.add({
    //                         'message': data,
    //                         'createdAt': DateTime.now()
    //                       }).then((value) => print("Message Added")).catchError(
    //                               (error) => print("Failed to add message: $error"));
    //                       msgController.clear();
    //                       _controller.animateTo(
    //                         _controller.position.maxScrollExtent,
    //                         duration: Duration(seconds: 1),
    //                         curve: Curves.fastOutSlowIn,
    //                       );
    //                     },
    //                     decoration: InputDecoration(
    //                       border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(25),
    //                       ),
    //                       hintText: "Message",
    //                       hintStyle: const TextStyle(
    //                         // color: Colors.grey,
    //                       ),
    //                       prefixIcon: IconButton(
    //                         onPressed: () {  },
    //                         icon: Icon(Icons.emoji_emotions_outlined ,
    //                             size: 25,),
    //
    //                       ),
    //                       suffixIcon: Row(
    //                         mainAxisAlignment: MainAxisAlignment.end,
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           IconButton(
    //                             onPressed: () {},
    //                             icon: const Icon(Icons
    //                                 .attach_file_outlined ,size: 27,),
    //                           ),
    //                           IconButton(
    //                             onPressed: () {},
    //                             icon: const Icon(Icons.photo_camera_outlined),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             IconButton.filled(
    //               onPressed: () {
    //                 if(msgController.text.isNotEmpty) {
    //                   FireData().sendMessage(widget.chatUser.id!,
    //                       msgController.text, widget.roomId).then((value) =>
    //                        setState(() {
    //                          msgController.text="";
    //                          // Navigator.pop(context);
    //                        })
    //                     );
    //                   }
    //                 },
    //               icon: const Icon(Iconsax.send_21),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    // }else{
    //          return const Text("Loading.....") ;
    //        }
    //       },
    //   ;
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
