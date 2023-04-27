import 'package:chat_x/Screens/Auth_screen.dart';
import 'package:chat_x/Screens/main_CHatPage_screen.dart';
import 'package:chat_x/animations/Page_animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat X',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: pageRoutanimation(),
          TargetPlatform.iOS: pageRoutanimation(),
        }),
        primarySwatch: Colors.indigo,
        textTheme: GoogleFonts.latoTextTheme().copyWith(
          subtitle1: GoogleFonts.acme(
            textStyle: const TextStyle(
              color: Colors.black,
            ),
          ),
          headline6: GoogleFonts.alata(),
          bodyText2: GoogleFonts.figtree(),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainChatPageScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
