import 'package:chatapp/helper/size_config.dart';
import 'package:chatapp/screens/splash_screen/screens/splash1.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => const MyApp(),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*to get height and width of screen*/
    // SizeConfig.init(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple , brightness: Brightness.light)
      ,useMaterial3: true
      ),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple,
              brightness: Brightness.dark)
          ,useMaterial3: true
      ),
      home: const Splash1() ,
      // StreamBuilder(
      //   stream: FirebaseAuth.instance.userChanges(),
      //   builder: (context, snapshot) {
      //     if(snapshot.hasData) {
      //       return  const Holding();
      //     }else {
      //       return const splash1();
      //     }
      //   },
      // ),
    );
  }
}

