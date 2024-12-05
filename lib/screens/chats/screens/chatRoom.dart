import 'package:chatapp/helper/date_time.dart';
import 'package:chatapp/firebase/fire_database.dart';
import 'package:chatapp/models/messageModel.dart';
import 'package:chatapp/models/userModel.dart';
import 'package:chatapp/screens/chats/widgets/chatBubbleRecieve.dart';
import 'package:chatapp/screens/chats/widgets/chatBubbleSend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../widgets/chat_card_title.dart';
import '../widgets/gif_hey.dart';
import '../widgets/message_textfield.dart';

class ChatRoomItem extends StatefulWidget {
  const ChatRoomItem({super.key, required this.roomId, required this.chatUser});
  final String roomId;
  final ChatUser chatUser;

  @override
  State<ChatRoomItem> createState() => _ChatRoomItemState();
}

class _ChatRoomItemState extends State<ChatRoomItem> {
  final ScrollController _controller = ScrollController();
  final TextEditingController msgController = TextEditingController();

  final List<String> selectedMsg = [];
  final List<String> copyMsg = [];

  CollectionReference messages = FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: ChatCardTitle(widget: widget),
      actions: selectedMsg.isEmpty ? _buildDefaultActions() : _buildSelectionActions(),
    );
  }

  List<Widget> _buildDefaultActions() {
    return [
      const Icon(Icons.call),
      const SizedBox(width: 10),
      const Icon(Icons.videocam),
      const SizedBox(width: 10),
    ];
  }

  List<Widget> _buildSelectionActions() {
    return [
      IconButton(
        onPressed: _deleteMessages,
        icon: const Icon(Iconsax.trash),
      ),
      IconButton(
        onPressed: _copyMessages,
        icon: const Icon(Iconsax.copy),
      ),
    ];
  }

  void _deleteMessages() {
    FireData().deleteMsg(widget.roomId, selectedMsg);
    setState(() {
      selectedMsg.clear();
      copyMsg.clear();
    });
  }

  void _copyMessages() {
    Clipboard.setData(ClipboardData(text: copyMsg.join('\n')));
    setState(() {
      selectedMsg.clear();
      copyMsg.clear();
    });
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .collection('messages')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final List<Message> messages = snapshot.data!.docs
            .map((e) => Message.fromJason(e.data()))
            .toList()
          ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        if (messages.isEmpty) return GifHey(widget: widget);

        return ListView.builder(
          reverse: true,
          controller: _controller,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final newDate = _getMessageDate(index, messages);
            final isMe = message.fromId == FirebaseAuth.instance.currentUser!.uid;

            return GestureDetector(
              onLongPress: () => _handleLongPress(message),
              onTap: () => _handleTap(message),
              child: Column(
                children: [
                  if (newDate.isNotEmpty) Center(child: Text(newDate)),
                  Row(
                    children: isMe ? _buildSendBubble(message) : _buildReceiveBubble(message),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildSendBubble(Message message) {
    return [
      const Spacer(),
      ChatBubbleSend(
        messageItem: message,
        selected: selectedMsg.contains(message.id),
      ),
    ];
  }

  List<Widget> _buildReceiveBubble(Message message) {
    return [
      ChatBubbleRecieve(
        messageItem: message,
        roomId: widget.roomId,
        selected: selectedMsg.contains(message.id),
      ),
      const Spacer(),
    ];
  }

  String _getMessageDate(int index, List<Message> messages) {
    final current = MyDateTime.dateFormate(messages[index].createdAt.toString());
    final prev = index + 1 < messages.length
        ? MyDateTime.dateFormate(messages[index + 1].createdAt.toString())
        : null;

    return prev == null || !current.isAtSameMomentAs(prev)
        ? MyDateTime.dateAndTime(messages[index].createdAt.toString())
        : '';
  }

  void _handleLongPress(Message message) {
    setState(() {
      _toggleMessageSelection(message);
    });
  }

  void _handleTap(Message message) {
    setState(() {
      if (selectedMsg.isNotEmpty) _toggleMessageSelection(message);
    });
  }

  void _toggleMessageSelection(Message message) {
    if (selectedMsg.contains(message.id)) {
      selectedMsg.remove(message.id);
      copyMsg.remove(message.message);
    } else {
      selectedMsg.add(message.id!);
      if (message.type == 'text') copyMsg.add(message.message!);
    }
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        children: [
          MessageTextField(
            msgController: msgController,
            messages: messages,
            controller: _controller,
            widget: widget,
          ),
          IconButton.filled(
            onPressed: _sendMessage,
            icon: const Icon(Iconsax.send_21),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (msgController.text.isEmpty) return;

    FireData()
        .sendMessage(widget.chatUser.id!, msgController.text, widget.roomId, widget.chatUser, context)
        .then((_) {
      setState(() {
        msgController.clear();
      });
    });
  }
}
