import 'package:babi_market/homepage.dart';
import 'package:babi_market/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance
        .signOut(); // Ensure no user is signed in when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            ); // Add a loading indicator while checking auth state
          }
          if (snapshot.hasData) {
            return Homepage(); // If user is authenticated, show homepage
          } else {
            return Login(); // If no user, show login screen
          }
        },
      ),
    );
  }
}
