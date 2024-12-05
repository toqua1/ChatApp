import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../firebase/fire_database.dart';
import '../../../helper/photo_view.dart';
import '../../../models/messageModel.dart';

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
  @override
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
        margin: const EdgeInsets.symmetric(vertical: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width / 2,
              ),
              padding:const EdgeInsets.all(16),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // color: Color(0xFFADB0B0),
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.messageItem.type=='Photo' ?
                  GestureDetector(
                    onTap:() => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PhotoViewScreen(img: widget.messageItem.message!))),
                    child: CachedNetworkImage(
                      imageUrl: widget.messageItem.message!,
                      placeholder: (context,url){
                        return const CircularProgressIndicator();
                      },
                    ),
                  )
                      :Text(widget.messageItem.message!
                    // ,softWrap: true,
                    // ,textAlign: TextAlign.start,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat.yMMMEd()
                            .format(DateTime.fromMillisecondsSinceEpoch(
                            int.parse(widget.messageItem.createdAt!)))
                            .toString(),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      widget.messageItem.read == ""
                          ? const Icon(
                        Icons.done_all,
                        color: Colors.grey,
                      )
                          : const Icon(
                        Icons.done_all,
                        color: Colors.blueAccent,
                      )
                    ],
                  ),
                ],
              ), /*doc message*/
            ),
          ],
        ),
      ),
    );
  }
}
