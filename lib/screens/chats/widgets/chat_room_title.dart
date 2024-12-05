import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../helper/date_time.dart';
import '../screens/chatRoom.dart';
import 'chat_card_profile.dart';

class ChatRoomTitle extends StatelessWidget {
  const ChatRoomTitle({
    super.key,
    required this.widget,
  });

  final ChatRoomItem widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ChatCardProfile(chatUser: widget.chatUser),
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
                child: StreamBuilder(
                    stream:FirebaseFirestore.instance.collection('users')
                        .doc(widget.chatUser.id!).snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return Text(
                          snapshot.data!.data()!['online']
                              ? 'Online'
                              :"Last seen ${MyDateTime.dateAndTime(widget.chatUser.lastActivated!)}"
                              " at ${MyDateTime.timeDate(widget.chatUser.lastActivated!)}", // Changed from
                          // DateTime.parse
                          style: Theme.of(context).textTheme.labelLarge,
                        );
                      }else{
                        return const SizedBox(width:300 ,height: 300,);
                      }
                    }
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
