import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'splashscreen.dart';
import 'view/auth/email_signup_ui.dart';
import 'view/auth/new.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontSize: 19,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        foregroundColor: Colors.black,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      )),
      title: 'Chat Us',
      home: SplashScreen(),
      // SignUpScreen(),
    );
  }
}
