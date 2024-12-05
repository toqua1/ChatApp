import 'package:chatapp/helper/date_time.dart';
import 'package:chatapp/helper/photo_view.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatBubbleSend extends StatelessWidget {
  const ChatBubbleSend({
    super.key,
    required this.messageItem,
    required this.selected,
  });

  final Message messageItem;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Colors.grey[400] : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildMessageContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    final isPhotoMessage = messageItem.type == 'Photo';

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 2,
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          isPhotoMessage
              ? GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PhotoViewScreen(img: messageItem.message!),
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: messageItem.message!,
              placeholder: (context, url) => const CircularProgressIndicator(),
            ),
          )
              : Text(messageItem.message!),
          _buildTimestampRow(context),
        ],
      ),
    );
  }

  Widget _buildTimestampRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          MyDateTime.timeDate(messageItem.createdAt!),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(width: 6),
        Icon(
          Icons.done_all,
          color: messageItem.read!.isEmpty ? Colors.grey : Colors.blueAccent,
        ),
      ],
    );
  }
}
