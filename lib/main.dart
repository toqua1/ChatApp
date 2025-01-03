import 'package:chatapp/provider/provider.dart';
import 'package:chatapp/screens/splash_screen/screens/splash1.dart';
import 'package:chatapp/services/firebase/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
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

    return ChangeNotifierProvider(
      create:(context)=> ProviderApp(),
      child: Consumer<ProviderApp>(
        builder: (context , value, child)=>
            MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: value.themeMode,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color(value.mainColor) ,
              brightness: Brightness.light)
          ,useMaterial3: true
          ),
          darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Color(value.mainColor),
                  brightness: Brightness.dark)
              ,useMaterial3: true
          ),
          home: const Splash1() ,
        ),
      ),
    );
  }
}

