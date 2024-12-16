import 'dart:io';
import '../../../services/firebase/fire_database.dart';
import 'package:chatapp/models/userModel.dart';
import 'package:chatapp/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../helper/MyCustomClipper.dart';
import '../../../services/firebase/fire_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameCon = TextEditingController();
  TextEditingController aboutCon = TextEditingController();
  ChatUser? me;
  String? _img = "";
  bool nameEdit = false;
  bool aboutEdit = false;
  @override
  void initState() {
    /*in initState we make listen => false */
    me = Provider.of<ProviderApp>(context, listen: false).me;
    super.initState();
    nameCon.text = me!.name!;
    aboutCon.text = me!.about!;
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor =Provider.of<ProviderApp>(context).navigationBarColor;
    Color backgroundColor = Provider.of<ProviderApp>(context)
        .buttonBackgroundColor;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  ClipPath(
                    clipper: MyCustomClipper(),
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            // Colors.blue,
                            // Colors.purple,
                            backgroundColor,
                            mainColor,
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
                            children: [
                              Container(
                                width: 190,
                                height: 190,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                left: 5,
                                top: 5,
                                child: _img == ""
                                    ? me!.image == ""
                                        ? CircleAvatar(
                                            radius: 70,
                                          )
                                        : CircleAvatar(
                                            radius: 70,
                                            backgroundImage:
                                                NetworkImage(me!.image!),
                                          )
                                    : CircleAvatar(
                                        radius: 70,
                                        backgroundImage: FileImage(File(_img!)),
                                      ),
                              ),
                              Positioned(
                                  bottom: -5,
                                  right: -5,
                                  child: IconButton.filled(
                                    onPressed: () async {
                                      ImagePicker imagePicker = ImagePicker();
                                      XFile? image =
                                          await imagePicker.pickImage(
                                              source: ImageSource.gallery);
                                      if (image != null) {
                                        setState(() {
                                          _img = image.path;
                                        });
                                        FireStorage().updateProfileImage(
                                            file: File(image.path));
                                      }
                                    },
                                    icon: Icon(Iconsax.edit),
                                  )),
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
                                      onPressed: () {
                                        setState(() {
                                          nameEdit = true;
                                        });
                                      },
                                      icon: Icon(Iconsax.edit)),
                                  title: TextField(
                                    controller: nameCon,
                                    enabled: nameEdit,
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
                                      onPressed: () {
                                        setState(() {
                                          aboutEdit = true;
                                        });
                                      },
                                      icon: Icon(Iconsax.edit)),
                                  title: TextField(
                                    controller: aboutCon,
                                    enabled: aboutEdit,
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
                                  subtitle: Text(me!.email.toString()),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Icon(Iconsax.timer_1),
                                  // trailing: Icon(Iconsax.edit),
                                  title: Text("Joined On"),
                                  subtitle: Text(me!.createdAt.toString()),
                                ),
                              ),
                              SizedBox(height: 20,),
                              ElevatedButton(
                                  onPressed: () {
                                   if(nameCon.text.isNotEmpty && aboutCon
                                       .text.isNotEmpty){
                                     FireData()
                                         .editProfile(nameCon.text, aboutCon.text)
                                         .then((value){
                                       setState(() {
                                         nameEdit=false;
                                         aboutEdit=false;
                                       });
                                     });
                                   }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    padding: const EdgeInsets.all(16),
                                  ),
                                  child: Center(
                                    child: Text('Save'.toUpperCase()),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
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
    );
    ;
  }
}
