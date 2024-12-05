import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../firebase/fire_storage.dart';
import '../screens/chatRoom.dart';

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    super.key,
    required this.msgController,
    required this.messages,
    required ScrollController controller,
    required this.widget,
  }) : _controller = controller;

  final TextEditingController msgController;
  final CollectionReference<Object?> messages;
  final ScrollController _controller;
  final ChatRoomItem widget;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: TextField(
          maxLines: 6,
          minLines: 1,
          controller: msgController,
          onSubmitted: (data) {
            /*data here is object type so it refers to different data types but in add to firestore we use map to refer which data fields to use */
            messages.add({
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
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn); /*or easeIn*/
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20) ,
              borderSide: BorderSide.none
            ),
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
    );
  }
}
