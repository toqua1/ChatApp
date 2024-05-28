import 'package:chatapp/screens/groups/widgets/create_group.dart';
import 'package:chatapp/screens/groups/widgets/group_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupsHome extends StatefulWidget {
  const GroupsHome({super.key});

  @override
  State<GroupsHome> createState() => _GroupsHomeState();
}

class _GroupsHomeState extends State<GroupsHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
         Navigator.push(context ,MaterialPageRoute(builder: (context)
         =>CreateGroupScreen()));
        },
        child: Icon(Iconsax.message_add),
      ),
      appBar: AppBar(
        title: Text("Group"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                  itemCount: 3,
                    itemBuilder: (context,index){
                      return GroupCard();
                    }
                ),
            ),
          ],
        ),
      ),
    );
  }
}
