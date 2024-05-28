import 'package:chatapp/screens/groups/widgets/group_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupMemberScreen extends StatefulWidget {
  const GroupMemberScreen({super.key});

  @override
  State<GroupMemberScreen> createState() => _GroupMemberScreenState();
}

class _GroupMemberScreenState extends State<GroupMemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Group Members"),
      actions: [
        IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupEditScreen()));
            },
            icon: Icon(Iconsax.user_edit)
        ),
      ],
      ) ,
      body: Padding(
          padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                  itemBuilder: (context ,index){
                    return ListTile(
                      title: Text("Toqua"),
                      subtitle: Text("Admin"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: (){

                          },
                              icon: Icon(Iconsax.user_tick)
                          ),
                          IconButton(
                              onPressed: (){

                              },
                              icon: Icon(Iconsax.trash)
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
