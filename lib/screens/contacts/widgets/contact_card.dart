import 'package:chatapp/firebase/fire_database.dart';
import 'package:chatapp/models/userModel.dart';
import 'package:chatapp/screens/chats/screens/chatRoom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ContactCard extends StatelessWidget {
  final ChatUser user ;
  const ContactCard({
    super.key, required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(),
        title: Text(user.name!),
        subtitle: Text(
          user.about!,
          maxLines: 1,
        ),
        trailing: IconButton(
          onPressed: () {
            List<String> members=[
              user.id! ,
              FirebaseAuth.instance.currentUser!.uid
            ]..sort(
                (a,b) => a.compareTo(b)
            );
            FireData().createRoom(user.email!).then(
                (value) =>  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>
                      ChatRoomItem(roomId: members.toString(), chatUser: user)),
                ),
            );
          },
          icon: const Icon(Iconsax.message),

        ),
      ),
    );
  }
}