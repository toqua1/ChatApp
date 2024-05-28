import 'package:chatapp/models/messageModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupBubbleSend extends StatelessWidget {
  const GroupBubbleSend({
    super.key ,
    required this.message
  });
  final Message message ;/*doc*/
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 16, bottom: 16 ,right: 16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF42A5F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomLeft: Radius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('message.message'),
            Text("06:33 AM",style: Theme.of(context).textTheme.labelSmall,)
          ],
        ),/*doc message*/
      ),
    );
  }
}

class GroupBubbleRecieve extends StatelessWidget {
  const GroupBubbleRecieve({
    super.key,
    required this.message
  });
  final Message message ;/*doc*/
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 16, bottom: 16 ,right: 16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFADB0B0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name"),
            Text('message.message'),
            Text("06:33 AM",style: Theme.of(context).textTheme.labelSmall,)
          ],
        ),/*doc message*/
      ),
    );
  }
}
