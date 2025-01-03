import 'package:chatapp/screens/Gemini%20Chat/widgets/gemini_chat_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../helper/Text/custom_textfield.dart';
import '../../../models/chat_room_model.dart';
import '../../../services/firebase/fire_database.dart';
import '../widgets/chat_card.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const GeminiChatCard(),
              Expanded(child: _buildChatList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateChatBottomSheet,
        child: const Icon(Iconsax.message_add_1),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      automaticallyImplyLeading: false,
      title: const Text(
        "ChatHub",
        style: TextStyle(
          fontSize: 25,
          fontFamily: "exo",
          letterSpacing: 4,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.camera_alt_outlined, size: 27),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, size: 30),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert, size: 30),
        ),
      ],
    );
  }

  Widget _buildChatList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .where(
            'members',
            arrayContains: FirebaseAuth.instance.currentUser!.uid,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final List<ChatRoom> chatRooms = snapshot.data!.docs
              .map((e) => ChatRoom.fromJson(e.data()))
              .toList()
            ..sort((a, b) => b.lastMessageTime!.compareTo(a.lastMessageTime!));

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) => ChatCard(item: chatRooms[index]),
          );
        }

        return const Center(child: Text("No chats found."));
      },
    );
  }

  void _showCreateChatBottomSheet() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "Enter friend name",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Iconsax.scan_barcode),
                  ),
                ],
              ),
              CustomFormTextfield(
                label: "Email",
                controller: _emailController,
                hintText: "Enter your friend's email",
                name: false,
                prefixIcon: const Icon(Iconsax.direct),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                onPressed: _createChatRoom,
                child: const Text("Create Chat"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _createChatRoom() {
    if (_emailController.text.isNotEmpty) {
      FireData().createRoom(_emailController.text);
      setState(() => _emailController.clear());
      Navigator.pop(context);
    }
  }
}
