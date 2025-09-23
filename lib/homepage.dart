import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:babi_market/login.dart'; // Import the Login page

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser;

  // Signout method to log the user out and navigate to the Login page
  signout() async {
    await FirebaseAuth.instance.signOut();
    // After signing out, navigate to the Login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Homepage")),
      body: Center(child: Text('${user?.email ?? "No user logged in"}')),
      floatingActionButton: FloatingActionButton(
        onPressed: signout, // Sign out and navigate back to Login page
        child: const Icon(Icons.login_rounded),
      ),
    );
  }
}
