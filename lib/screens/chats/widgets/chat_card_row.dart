import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/messageModel.dart';
import '../../../models/userModel.dart';
import 'chat_card.dart';

class ChatCardRow extends StatelessWidget {
  const ChatCardRow({
    super.key,
    required this.chatUser,
    required this.widget,
  });

  final ChatUser? chatUser;
  final ChatCard widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ChatCardProfile(chatUser: chatUser),
        const SizedBox(width: 16),
        Expanded(
          child: ChatCardTitleAndSubtitle(chatUser: chatUser, widget: widget),
        ),
        const SizedBox(width: 8),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('rooms')
              .doc(widget.item.id)
              .collection('messages')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final unReadList = snapshot.data!.docs
                  .map((e) => Message.fromJason(e.data()))
                  .where((element) => element.read == "")
                  .where((element) =>
              element.fromId !=
                  FirebaseAuth.instance.currentUser!.uid)
                  .toList();

              return unReadList.isNotEmpty
                  ? ChatCardBadge(unReadList: unReadList)
                  : ChatCardDate(widget: widget);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}

class ChatCardProfile extends StatelessWidget {
  const ChatCardProfile({
    super.key,
    required this.chatUser,
  });

  final ChatUser? chatUser;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: chatUser?.image != null && chatUser!.image!.isNotEmpty
          ? NetworkImage(chatUser!.image!)
          : null,
      child: chatUser?.image == null || chatUser!.image!.isEmpty
          ? const Icon(Icons.person)
          : null,
    );
  }
}

class ChatCardDate extends StatelessWidget {
  const ChatCardDate({
    super.key,
    required this.widget,
  });

  final ChatCard widget;

  @override
  Widget build(BuildContext context) {
    return Text(
                    DateFormat.yMMMEd().format(
    DateTime.fromMillisecondsSinceEpoch(
      int.parse(widget.item.lastMessageTime!),
    ),
                    ),
                    style: const TextStyle(fontSize: 12),
                  );
  }
}

class ChatCardBadge extends StatelessWidget {
  const ChatCardBadge({
    super.key,
    required this.unReadList,
  });

  final List<Message> unReadList;

  @override
  Widget build(BuildContext context) {
    return Badge(
                    textStyle: const TextStyle(
    fontWeight: FontWeight.w500,
                    ),
                    backgroundColor:
                    Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context)
      .colorScheme
      .primaryContainer,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12),
                    label: Text(unReadList.length.toString()),
                    largeSize: 30,
                  );
  }
}

class ChatCardTitleAndSubtitle extends StatelessWidget {
  const ChatCardTitleAndSubtitle({
    super.key,
    required this.chatUser,
    required this.widget,
  });

  final ChatUser? chatUser;
  final ChatCard widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          chatUser!.name!,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: "serif",
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.item.lastMessage! == ""
              ? chatUser!.about!
              : widget.item.lastMessage!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
