import 'package:chatapp/Text/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupEditScreen extends StatefulWidget {
  const GroupEditScreen({super.key});

  @override
  State<GroupEditScreen> createState() => _GroupEditScreenState();
}

class _GroupEditScreenState extends State<GroupEditScreen> {
  TextEditingController _gNameCon =TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gNameCon.text= "Name" ;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){

        },
        label: Text("Done"),
        icon: Icon(Iconsax.tick_circle),
      ),
      appBar: AppBar(
        title: Text("Edit Group"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 40,

                    ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child:IconButton(
                        onPressed: (){

                        },
                        icon: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: custom_FormTextfield(
                      label: "Group Name",
                      controller: _gNameCon,
                      hintText: "Enter group name",
                      prefixIcon: Icon(Iconsax.user_octagon),
                      name: false),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Divider(),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text("Add Members"),
                Spacer(),
                Text("0"),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
                child:ListView(
                  children: [
                    CheckboxListTile(
                        checkboxShape: CircleBorder() ,
                        title: const Text("Toqua"),
                        value: false,
                        onChanged: (value){

                        }
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
