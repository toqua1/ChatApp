import 'package:chatapp/screens/settings/screens/profile2.dart';
import 'package:chatapp/screens/settings/widgets/qr_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../Signing/screens/login.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child:SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  minVerticalPadding: 40,
                  leading: CircleAvatar(
                    radius: 30,
                  ),
                  title: Text("Name"),
                  trailing: IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder:
                          (context)=>QRCode()));
                    },
                    icon: Icon(Iconsax.scan_barcode),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text("Profile"),
                    leading: Icon(Iconsax.user),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen())),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text("Theme"),
                    leading: Icon(Iconsax.color_swatch),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap:() {
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              content: SingleChildScrollView(
                                child: BlockPicker(
                                  onColorChanged: (Color value) {  },
                                  pickerColor: Colors.purple,
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: (){

                                    },
                                    child: Text("Done"))
                              ],
                            );
                          }
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text("Dark Mode"),
                    leading: Icon(Iconsax.user),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {

                      },

                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: ()async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login())
                      );
                      },
                      title: Text("Sign Out"),
                    // leading: Icon(Iconsax.user),
                    trailing: Icon(Iconsax.logout_1),
                  ),
                ),
              ],
            ),
          ) ,
      ),
    );
  }
}
