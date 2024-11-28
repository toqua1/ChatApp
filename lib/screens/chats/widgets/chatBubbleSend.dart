import 'package:chatapp/helper/photo_view.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatBubbleSend extends StatefulWidget {
  const ChatBubbleSend({
    super.key,
    required this.messageItem,
    required this.selected,
    // required this.message
  });
  // final String message ;/*doc*/
  final Message messageItem;
  final bool selected;

  @override
  State<ChatBubbleSend> createState() => _ChatBubbleSendState();
}

class _ChatBubbleSendState extends State<ChatBubbleSend> {
  @override
  Widget build(BuildContext context) {
    return Align(
            alignment: Alignment.centerRight,
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
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 15),
                    decoration: BoxDecoration(
                      // color: Color(0xFF42A5F5),
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          // topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16)),
                    ),
                    // child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                    Iconsax.tick_circle,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Iconsax.tick_circle5,
                                    color: Colors.blueAccent,
                                  )
                          ],
                        ),
                      ],
                    ),
                  ), /*doc message*/
                  // ),
                ],
              ),
            ));
  }
}
