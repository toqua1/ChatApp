import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../firebase/fire_database.dart';
import '../../../helper/photo_view.dart';
import '../../../models/messageModel.dart';

class ChatBubbleReceive extends StatefulWidget {
  const ChatBubbleReceive({
    super.key,
    required this.messageItem,
    required this.roomId,
    required this.selected,
  });

  final Message messageItem;
  final String roomId;
  final bool selected;

  @override
  State<ChatBubbleReceive> createState() => _ChatBubbleReceiveState();
}

class _ChatBubbleReceiveState extends State<ChatBubbleReceive> {
  @override
  void initState() {
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
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            _buildMessageContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    final isPhotoMessage = widget.messageItem.type == 'Photo';
    final createdAt = DateTime.fromMillisecondsSinceEpoch(
      int.parse(widget.messageItem.createdAt!),
    );

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 2,
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
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
          isPhotoMessage
              ? GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PhotoViewScreen(img: widget.messageItem.message!),
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: widget.messageItem.message!,
              placeholder: (context, url) => const CircularProgressIndicator(),
            ),
          )
              : Text(widget.messageItem.message!),
          _buildTimestampRow(createdAt),
        ],
      ),
    );
  }

  Widget _buildTimestampRow(DateTime createdAt) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat.yMMMEd().format(createdAt),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(width: 6),
        Icon(
          Icons.done_all,
          color: widget.messageItem.read!.isEmpty ? Colors.grey : Colors.blueAccent,
        ),
      ],
    );
  }
}
