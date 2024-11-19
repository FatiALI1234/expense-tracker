import 'package:expense_tracker/Category.dart';
import 'package:expense_tracker/Fpassword.dart';
import 'package:expense_tracker/Profile.dart';
import 'package:expense_tracker/Reports.dart';
import 'package:expense_tracker/Splash.dart';
import 'package:expense_tracker/signin.dart';
import 'package:expense_tracker/Homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:expense_tracker/Reports.dart';
import 'package:expense_tracker/Reports.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expense_tracker/Signup.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
late SharedPreferences prefs;
late FirebaseAuth auth;
Future <void>main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  // for firebase
  await Firebase.initializeApp(
  );

  //for firebase
  auth=FirebaseAuth.instance;

  prefs= await SharedPreferences.getInstance();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:SplashScreen()
    );
  }
}


