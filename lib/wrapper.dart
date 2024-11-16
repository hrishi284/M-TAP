import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:m_tap/login.dart';
import 'package:m_tap/megamenu.dart';

class WrapperState extends StatefulWidget {
  const WrapperState({super.key});

  @override
  State<WrapperState> createState() => _WrapperStateState();
}

class _WrapperStateState extends State<WrapperState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return Megamenu(); // If user is logged in, show Megamenu
            } else {
              return Login(); // If not logged in, show Login
            }
          }
          return Center(child: CircularProgressIndicator()); // Loading indicator while checking auth state
        },
      ),
    );
  }
}
