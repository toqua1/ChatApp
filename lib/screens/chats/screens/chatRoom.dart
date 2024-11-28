import 'package:universal_io/io.dart';
import 'package:chatapp/firebase/fire_database.dart';
import 'package:chatapp/firebase/fire_storage.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/models/userModel.dart';
import 'package:chatapp/screens/chats/widgets/chatBubbleRecieve.dart';
import 'package:chatapp/screens/chats/widgets/chatBubbleSend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
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
            Flexible(
              child: Column(
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
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      DateFormat.MMMMEEEEd().add_jm().format(
                          DateTime.fromMillisecondsSinceEpoch(int.parse(widget
                              .chatUser
                              .lastActivated!))), // Changed from DateTime.parse
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                            bool isMe = messageItems[index].fromId ==
                                FirebaseAuth.instance.currentUser!.uid;
                            if (isMe) {
                              return GestureDetector(
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    ChatBubbleSend(
                                      messageItem: messageItems[index],
                                      selected: selectedMsg
                                          .contains(messageItems[index].id),
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
                                child: Row(
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
                                widget.chatUser.id!,
                                " HEY !! ",
                                widget.roomId,
                                widget.chatUser,
                                context,
                                type: 'text'),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Row(
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
                        prefixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.emoji_emotions_outlined,
                            size: 25,
                          ),
                        ),
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  ImagePicker picker = ImagePicker();
                                  XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image != null) {
                                    FireStorage().sendImage(
                                        file: File(image.path),
                                        roomId: widget.roomId,
                                        uid: widget.chatUser.id!,
                                        context: context,
                                        chatUser: widget.chatUser
                                    );
                                    // print(image.path);
                                  }
                                },
                                icon: const Icon(Icons.photo_camera_outlined)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
