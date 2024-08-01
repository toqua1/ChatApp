import 'package:chatapp/firebase/fire_database.dart';
import 'package:chatapp/models/group_model.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/screens/groups/widgets/group_member_screen.dart';
import 'package:chatapp/screens/groups/widgets/hey_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import '../widgets/group_message_card.dart';

class GroupRoom extends StatefulWidget {
  const GroupRoom({super.key, required this.chatGroup});
  final GroupChat chatGroup;
  @override
  State<GroupRoom> createState() => _GroupRoomState();
}

class _GroupRoomState extends State<GroupRoom> {
  final _controller = ScrollController();
  TextEditingController msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              child: Text(widget.chatGroup.name.characters.first),
              // backgroundImage: AssetImage("assetsEdited/toqua5.jpg"),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatGroup.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "serif",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('id', whereIn: widget.chatGroup.members)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        List membersNames = [];
                        for (var element in snapshot.data!.docs){
                          membersNames.add(element.data()['name']) ;
                        }
                        return Text(
                          membersNames.join(', '),
                          style: Theme.of(context).textTheme.labelLarge,
                        );
                      }else{
                        return Container();
                      }
                    }),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupMemberScreen(chatGroup:
                      widget.chatGroup ,
                      )));
            },
            icon: const Icon(Iconsax.user),
          ),
          const SizedBox(
            width: 20,
          ),
          // Icon(Icons.videocam),
          const SizedBox(
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
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('groups')
                        .doc(widget.chatGroup.id)
                        .collection('messages')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<Message> msgs = snapshot.data!.docs
                            .map((e) => Message.fromJason(e.data()))
                            .toList()
                          ..sort(
                              (a, b) => b.createdAt!.compareTo(a.createdAt!));
                        if (msgs.isNotEmpty) {
                          return ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              bool isMe = msgs[index].fromId ==
                                  FirebaseAuth.instance.currentUser!.uid;
                              if (isMe) {
                                return GroupBubbleSend(message: msgs[index]);
                              } else {
                                return GroupBubbleRecieve(message: msgs[index]);
                              }
                            },
                            itemCount: msgs.length,
                            controller: _controller,
                          );
                        } else {
                          return HeyWidget(
                            groupChat: widget.chatGroup,
                          );
                        }
                      } else {
                        return Container();
                      }
                    }),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
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
                        borderRadius: BorderRadius.circular(25)),
                    child: TextField(
                      maxLines: 6,
                      minLines: 1,
                      controller: msgController,
                      // onSubmitted: (data) {
                      //   messages
                      //       .add({
                      //         'message': data,
                      //         'createdAt': DateTime.now()
                      //       })
                      //       .then((value) => print("Message Added"))
                      //       .catchError((error) =>
                      //           print("Failed to add message: $error"));
                      //   msgController.clear();
                      //   _controller.animateTo(
                      //     _controller.position.maxScrollExtent,
                      //     duration: const Duration(seconds: 1),
                      //     curve: Curves.fastOutSlowIn,
                      //   );
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        hintText: "Message",
                        hintStyle: const TextStyle(
                            // color: Colors.grey,
                            ),
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
                              onPressed: () {},
                              icon: const Icon(
                                Icons.attach_file_outlined,
                                size: 27,
                              ),
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
                  onPressed: () {
                    if (msgController.text.isNotEmpty) {
                      FireData()
                          .sendGMessage(msgController.text, widget.chatGroup.id)
                          .then((value) => msgController.text = '');
                      _controller.animateTo(
                        _controller.position.maxScrollExtent,
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn,
                      );
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
