import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../MyCustomClipper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameCon =TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameCon.text="myName";
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: Column(
          children: [
              Center(
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: MyCustomClipper(),
                      child: Container(
                        height: 250,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              Colors.blue,
                              Colors.purple,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Column(
                        children: [
                          Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children:[
                                Container(
                                  width: 190,
                                  height: 190,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                const Positioned(
                                  bottom: 5,right: 5,left: 5,top: 5,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage("assetsEdited/toqua5.jpg"),
                                  ),
                                ),
                                Positioned(
                                  bottom: -5,
                                    right: -5,
                                    child: IconButton.filled(
                                      onPressed: () {  },
                                      icon: Icon(Iconsax.edit),

                                    )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Card(
                                  child: ListTile(
                                    leading: Icon(Iconsax.user_octagon),
                                    trailing: IconButton(
                                        onPressed: (){},
                                        icon: Icon(Iconsax.edit)),
                                    title: TextField(
                                        controller: nameCon,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: "Name",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading: Icon(Iconsax.information),
                                    trailing: IconButton(
                                        onPressed: (){},
                                        icon: Icon(Iconsax.edit)),
                                    title: TextField(
                                      controller: nameCon,
                                      enabled: false,
                                      decoration: InputDecoration(
                                        labelText: "About",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading: Icon(Iconsax.direct),
                                    // trailing: Icon(Iconsax.edit),
                                    title: Text("Email"),
                                    subtitle: Text("sara25@gmail.com"),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading: Icon(Iconsax.timer_1),
                                    // trailing: Icon(Iconsax.edit),
                                    title: Text("Joined On"),
                                    subtitle: Text("1234554"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 23,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),

    );;
  }
}
