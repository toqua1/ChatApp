import 'package:flutter/material.dart';

import '../../../models/userModel.dart';

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