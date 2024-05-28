import 'package:chatapp/firebase/fire_database.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path/path.dart';

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
    return
        //   Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Card(
        //       color: Theme.of(context).colorScheme.secondaryContainer,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.only(
        //           bottomLeft: Radius.circular(16),
        //           bottomRight: Radius.circular(16),
        //           topRight: Radius.circular(0),
        //           topLeft: Radius.circular(16)
        //         )
        //       ),
        //       child: Padding(
        //         padding: EdgeInsets.all(12),
        //         child: Container(
        //           constraints: BoxConstraints(
        //             maxWidth: MediaQuery.sizeOf(context).width/2
        //           ),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.end,
        //             children: [
        //           Text(widget.messageItem.message!),
        //               Row(
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: [
        //                   Text(
        //                     DateFormat.yMMMEd()
        //                         .format(DateTime.fromMillisecondsSinceEpoch(
        //                         int.parse(widget.messageItem.createdAt!)
        //                     )).toString()
        //                     ,style: Theme.of(context).textTheme.labelSmall,),
        //                   SizedBox(
        //                     width: 6,
        //                   ),
        //                   widget.messageItem.read =="" ? Icon(
        //                     Iconsax.tick_circle ,color: Colors.grey,
        //                   )
        //                       : Icon(Iconsax.tick_circle5 ,color: Colors.blueAccent,)
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // );

        Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                color: widget.selected ? Colors.grey[400] : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
              ),
              margin: EdgeInsets.symmetric(vertical: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width / 2,
                    ),
                    padding: EdgeInsets.all(16),
                    margin:
                        EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 15),
                    decoration: BoxDecoration(
                      // color: Color(0xFF42A5F5),
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16)),
                    ),
                    // child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        widget.messageItem.type=='image' ?
                          Container(child: CachedNetworkImage(
                            imageUrl: widget.messageItem.message!,
                            placeholder: (context,url){
                              return CircularProgressIndicator();
                            },
                          )
                          // Image.network(widget.messageItem.message!)
                            ,)
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
                            SizedBox(
                              width: 6,
                            ),
                            widget.messageItem.read == ""
                                ? Icon(
                                    Iconsax.tick_circle,
                                    color: Colors.grey,
                                  )
                                : Icon(
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
