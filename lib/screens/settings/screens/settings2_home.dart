import 'package:chatapp/constants/constants.dart';
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
                const ProfileCard(),
                ThemeCard(currentColors: currentColors, prov: prov),
                ThemeModeCard(prov: prov),
                const SignOutCard(),
              ],
            ),
          ) ,
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text("Profile"),
        leading: const Icon(Iconsax.user),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen())),
      ),
    );
  }
}

class SignOutCard extends StatelessWidget {
  const SignOutCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: ()async {
          await FirebaseAuth.instance.signOut();
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login())
          );
          },
          title: Text("Sign Out"),
        // leading: Icon(Iconsax.user),
        trailing: Icon(Iconsax.logout_1),
      ),
    );
  }
}

class ThemeModeCard extends StatelessWidget {
  const ThemeModeCard({
    super.key,
    required this.prov,
  });

  final ProviderApp prov;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}

class ThemeCard extends StatelessWidget {
  const ThemeCard({
    super.key,
    required this.currentColors,
    required this.prov,
  });

  final List<Color> currentColors;
  final ProviderApp prov;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
