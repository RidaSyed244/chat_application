import 'package:chat_application/Contacts.dart';
import 'package:chat_application/Home.dart';
import 'package:chat_application/OnBoarding.dart';
import 'package:chat_application/bottomNavigation.dart';
import 'package:chat_application/riverpodPractice.dart';
import 'package:chat_application/searchContacts.dart';
import 'package:chat_application/splashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'messages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  runApp(ProviderScope(child: MyApp(email: email)));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.email}) : super(key: key);
  final String? email;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyAppStateful(email: email),
    );
  }
}

class MyAppStateful extends StatefulWidget {
  const MyAppStateful({Key? key, required this.email}) : super(key: key);
  final String? email;
  @override
  State<MyAppStateful> createState() => _MyAppState();
}

class _MyAppState extends State<MyAppStateful> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
    print(FirebaseAuth.instance.currentUser?.email);
  }

  void _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              widget.email != null ? Messages() : OnBoarding()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
