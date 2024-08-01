import 'package:chatapp/firebase/fire_database.dart';
import 'package:chatapp/models/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../helper/Text/custom_textfield.dart';
import '../../../models/userModel.dart';

class GroupEditScreen extends StatefulWidget {
  final GroupChat chatGroup ;
  const GroupEditScreen({super.key, required this.chatGroup});

  @override
  State<GroupEditScreen> createState() => _GroupEditScreenState();
}

class _GroupEditScreenState extends State<GroupEditScreen> {
  final TextEditingController _gNameCon =TextEditingController();
  @override
  void initState() {
    super.initState();
    _gNameCon.text= widget.chatGroup.name ;
  }
  List members = [];
  List myContacts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          FireData().editGroup(
              widget.chatGroup.id,
              _gNameCon.text,
              members
          ).then((value) =>
          Navigator.pop(context)
          );
        },
        label: const Text("Done"),
        icon: const Icon(Iconsax.tick_circle),
      ),
      appBar: AppBar(
        title: const Text("Edit Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              myContacts = snapshot.data!.data()!['my_users'] ?? [];
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const CircleAvatar(
                            radius: 40,

                          ),
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child:IconButton(
                              onPressed: (){

                              },
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: custom_FormTextfield(
                            label: "Group Name",
                            controller: _gNameCon,
                            hintText: "Enter group name",
                            prefixIcon: const Icon(Iconsax.user_octagon),
                            name: false),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Text("Add Members"),
                      const Spacer(),
                      Text(myContacts.length.toString()),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('id',
                              whereIn:
                              myContacts.isEmpty ? [''] : myContacts)
                              .snapshots(),

                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final List<ChatUser> items = snapshot.data!.docs
                                  .map((e) => ChatUser.fromJson(e.data()))
                                  .where((e) => e.id !=
                                  FirebaseAuth.instance.currentUser!.uid)
                                  .where((e) => !widget.chatGroup.members
                                  .contains(e.id) ).toList()
                                ..sort((a, b) => a.name!.compareTo(b.name!));

                              return ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return CheckboxListTile(
                                      checkboxShape: const CircleBorder(),
                                      title: Text(items[index].name!),
                                      value:
                                      members.contains(items[index].id),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value!) {
                                            members.add(items[index].id!);
                                          } else {
                                            members.remove(items[index].id!);
                                          }
                                        });
                                      });
                                },
                              );
                            } else {
                              return Container();
                            }
                          })),
                ],
              );
            }else{
              return Container();
            }
          }
        ),
      ),
    );
  }
}
