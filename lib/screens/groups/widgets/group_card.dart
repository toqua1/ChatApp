import 'package:flutter/material.dart';
import 'group_room.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>GroupRoom())
          );
        },
        child :Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child:Card(
            child: ListTile(
              title: Text("Group Name" ,style: TextStyle(
                  fontSize: 20 ,fontFamily: "serif" ,fontWeight: FontWeight.w500
              ),),
              leading: CircleAvatar(
                radius: 30,
               child: Text("G"),
                // backgroundImage: AssetImage("assetsEdited/toqua5.jpg"),
              ),
              trailing: Badge(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w500
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.primaryContainer,
                padding: EdgeInsets.symmetric(horizontal: 12),
                label: Text('3'),
                largeSize: 20,/*30*/
              ),
              subtitle: Text("Last Meassage" ,style: TextStyle(
                  color: Colors.grey
              ),),
            ),
          ),
        ),
      );
  }
}
