import 'package:chatapp/firebase/fire_database.dart';
import 'package:chatapp/models/group_model.dart';
import 'package:chatapp/models/userModel.dart';
import 'package:chatapp/screens/groups/widgets/group_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupMemberScreen extends StatefulWidget {
  const GroupMemberScreen({super.key, required this.chatGroup});
  final GroupChat chatGroup;

  @override
  State<GroupMemberScreen> createState() => _GroupMemberScreenState();
}

class _GroupMemberScreenState extends State<GroupMemberScreen> {
  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.chatGroup.admin?.contains(FirebaseAuth.instance.currentUser?.uid) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Members"),
        actions: [
          if (isAdmin)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupEditScreen(chatGroup: widget.chatGroup),
                  ),
                );
              },
              icon: const Icon(Iconsax.user_edit),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: widget.chatGroup.members.isNotEmpty
            ? StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('id', whereIn: widget.chatGroup.members)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No members found"));
            }

            List<ChatUser> userList = snapshot.data!.docs
                .map((e) => ChatUser.fromJson(e.data()))
                .toList();

            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                bool admin = widget.chatGroup.admin?.contains(userList[index].id) ?? false;

                return ListTile(
                  title: Text(userList[index].name ?? 'Unknown'),
                  subtitle: admin ? const Text("Admin") : const Text('Member'),
                  trailing: isAdmin
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Add admin logic here
                        },
                        icon: const Icon(Iconsax.user_tick),
                      ),
                      IconButton(
                        onPressed: () {
                          FireData()
                              .removeMember(
                            widget.chatGroup.id,
                            userList[index].id ?? '',
                          )
                              .then((value) {
                            setState(() {
                              widget.chatGroup.members.remove(userList[index].id);
                            });
                          });
                        },
                        icon: const Icon(Iconsax.trash ,color: Colors.red,),
                      ),
                    ],
                  )
                      : null,
                );
              },
            );
          },
        )
            : const Center(child: Text("No members in this group")),
      ),
    );
  }
}
