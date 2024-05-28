import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../firebase/fire_database.dart';
import '../../models/messageModel.dart';

class ChatBubbleRecieve extends StatefulWidget {
  const ChatBubbleRecieve(
      {super.key,
      // required this.message,
      required this.messageItem,
      required this.roomId,
      required this.selected});
  // final String message ;/*doc*/
  final Message messageItem;
  final String roomId;
  final bool selected;
  @override
  State<ChatBubbleRecieve> createState() => _ChatBubbleRecieveState();
}

class _ChatBubbleRecieveState extends State<ChatBubbleRecieve> {
  void initState() {
    /*we use init as it identify that we enter message bubble
   area and this will help us in read field*/
    super.initState();

    if (widget.messageItem.toId == FirebaseAuth.instance.currentUser!.uid) {
      FireData().readMessage(widget.roomId, widget.messageItem.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: widget.selected ? Colors.grey[400] : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 16),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                // color: Color(0xFFADB0B0),
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.messageItem.message!),
                  Text(
                    DateFormat.yMMMEd()
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            int.parse(widget.messageItem.createdAt!)))
                        .toString(),
                    style: Theme.of(context).textTheme.labelSmall,
                  )
                ],
              ), /*doc message*/
            ),
          ],
        ),
      ),
    );
  }
}
