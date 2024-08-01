import 'package:chatapp/models/messageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupBubbleSend extends StatelessWidget {
  const GroupBubbleSend({super.key, required this.message});
  final Message message; /*doc*/
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
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
            Text(
              message.message!,
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              DateFormat.jm()
                  .format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(message.createdAt!)))
                  .toString(),
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Colors.black26),
            )
          ],
        ), /*doc message*/
      ),
    );
  }
}

class GroupBubbleRecieve extends StatelessWidget {
  const GroupBubbleRecieve({super.key, required this.message});
  final Message message; /*doc*/
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(message.fromId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
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
                    Text(
                      snapshot.data!.data()!['name'].toString(),
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: Colors.black),
                    ),
                    Text(
                      message.message!,
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      DateFormat.jm()
                          .format(DateTime.fromMillisecondsSinceEpoch(
                              int.parse(message.createdAt!)))
                          .toString(),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: Colors.blueAccent),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
