import 'package:chatapp/models/group_model.dart';
import 'package:flutter/material.dart';
import '../../../firebase/fire_database.dart';

class HeyWidget extends StatelessWidget {
  const HeyWidget({super.key, required this.groupChat});
  final GroupChat groupChat ;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => FireData().sendGMessage(
            " HEY !! ",
            groupChat.id,
            groupChat,
            context
        ),
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
