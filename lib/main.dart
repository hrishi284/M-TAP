import 'package:flutter/material.dart';
import 'package:m_tap/login.dart';
import 'package:m_tap/profile.dart';
import 'package:m_tap/megamenu.dart';
import 'package:m_tap/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
   WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter binding is initialized
   await Firebase.initializeApp(); // Initializes Firebase
   await FirebaseAuth.instance.signOut();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      initialRoute: 'Wrapper', // Set initial route
      routes: {
        'Login': (context) => Login(), // Define routes
        'Megamenu': (context) => Megamenu(),
        'Wrapper': (context) => WrapperState(),
        'Profile': (context) => Profile(),      },
    );
  }
}
