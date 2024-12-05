import 'package:chatapp/helper/date_time.dart';
import 'package:universal_io/io.dart';
import 'package:chatapp/firebase/fire_database.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/models/userModel.dart';
import 'package:chatapp/screens/chats/widgets/chatBubbleRecieve.dart';
import 'package:chatapp/screens/chats/widgets/chatBubbleSend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../widgets/chat_card_title.dart';
import '../widgets/gif_hey.dart';
import '../widgets/message_textfield.dart';

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
        title: ChatCardTitle(widget: widget),
        actions: selectedMsg.isEmpty
            ? [
                const Icon(Icons.call),
                const SizedBox(
                  width: 10,
                ),
                const Icon(Icons.videocam),
                const SizedBox(
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
                            //handlig date part//////////////////////////////
                           String newDate ='';
                           bool isSameDate = false;
                           if((index == 0 && messageItems.length == 1)
                               || index == messageItems.length -1 ){
                             newDate = MyDateTime.dateAndTime(
                                 messageItems[index].createdAt.toString()
                             );
                           }else{
                             final DateTime date =MyDateTime.dateFormate(
                                 messageItems[index].createdAt.toString()
                             );
                             final DateTime prevDate = MyDateTime.dateFormate(
                                 messageItems[index + 1].createdAt.toString()
                             );
                             isSameDate = date.isAtSameMomentAs(prevDate);
                             newDate = isSameDate ? "" :MyDateTime.dateAndTime(messageItems[index].createdAt.toString());
                           }
                            ////////////////////////////////////////////
                           bool isMe = messageItems[index].fromId ==
                                FirebaseAuth.instance.currentUser!.uid;
                            if (isMe) {
                              return GestureDetector(
                                child: Column(
                                  children: [
                                    if(newDate != "")
                                    Center(
                                      child: Text(newDate),
                                    ),
                                    Row(
                                      children: [
                                        const Spacer(),
                                        ChatBubbleSend(
                                          messageItem: messageItems[index],
                                          selected: selectedMsg
                                              .contains(messageItems[index].id),
                                        ),
                                      ],
                                    ),
                                  ],
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
                                child: Column(
                                  children: [
                                    if(newDate != "")
                                      Center(
                                        child: Text(newDate),
                                      ),
                                    Row(
                                      children: [
                                        ChatBubbleRecieve(
                                          messageItem: messageItems[index],
                                          roomId: widget.roomId,
                                          selected: selectedMsg
                                              .contains(messageItems[index].id),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ],
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
                      : GifHey(widget: widget);
                } else {
                  return Center(
                    child: Container(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Row(
              children: [
                MessageTextField(msgController: msgController, messages: messages, controller: _controller, widget: widget),
                IconButton.filled(
                  onPressed: () {
                    if (msgController.text.isNotEmpty) {
                      FireData().sendMessage(
                          widget.chatUser.id!,
                          msgController.text,
                          widget.roomId,
                        widget.chatUser,
                        context
                      ).then((value) => setState(() {
                                msgController.text = "";
                                // Navigator.pop(context);
                              }));
                    }
                  },
                  icon: const Icon(Iconsax.send_21),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



