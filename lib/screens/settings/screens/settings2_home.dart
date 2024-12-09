import 'package:chatapp/provider/provider.dart';
import 'package:chatapp/screens/settings/screens/profile2.dart';
import 'package:chatapp/screens/settings/widgets/qr_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../../Signing/screens/login.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<Color> currentColors = [Colors.indigo ,Colors.pink,Colors.lightGreen,
    Colors.lime ,Colors.deepPurple,Colors.cyan,Colors.teal,Colors.brown,
  Colors.greenAccent,Colors.blue,Colors.deepOrangeAccent,Colors.pinkAccent,
  Color(0xffBFECFF),Color(0xffCDC1FF),Color(0xff659287),
    Color(0xff789DBC),Color(0xffBC7C7C)];
  @override
  Widget build(BuildContext context) {
    final prov=Provider.of<ProviderApp>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child:SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  minVerticalPadding: 40,
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(prov.me!.image!),
                  ),
                  /*we should bring data first as it will cause null check
                  operator */
                  title: Text(prov.me!.name.toString()),
                  trailing: IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder:
                          (context)=>const QRCode()));
                    },
                    icon: const Icon(Iconsax.scan_barcode),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text("Profile"),
                    leading: const Icon(Iconsax.user),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen())),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text("Theme"),
                    leading: const Icon(Iconsax.color_swatch),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap:() {
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              content: SingleChildScrollView(
                                child: BlockPicker(
                                  availableColors: currentColors,
                                  onColorChanged: (Color value) {
                                    // print(value.value.toRadixString(16));
                                  prov.changeColor(value.value);
                                  },
                                  pickerColor: Color(prov.mainColor),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: (){
                                       Navigator.pop(context);
                                    },
                                    child: const Text("Done"))
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
                      value: prov.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                         prov.changeMode(value);
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
