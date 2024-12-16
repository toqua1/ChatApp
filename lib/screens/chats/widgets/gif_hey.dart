import 'package:flutter/material.dart';
import '../../../services/firebase/fire_database.dart';
import '../screens/chatRoom.dart';

class GifHey extends StatelessWidget {
  const GifHey({
    super.key,
    required this.widget,
  });

  final ChatRoomItem widget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => FireData().sendMessage(
            widget.chatUser.id!,
            " HEY !! ",
            widget.roomId,
            widget.chatUser,
            context,
            type: 'text'),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assetsEdited/hiSticker1"
                      ".gif",
                  width: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
