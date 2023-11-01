import 'package:chat_application/Calls.dart';
import 'package:chat_application/Contacts.dart';
import 'package:chat_application/Home.dart';
import 'package:chat_application/Settings.dart';
import 'package:flutter/material.dart';

class BottonNavigation extends StatefulWidget {
  BottonNavigation({
    super.key,
  });

  @override
  State<BottonNavigation> createState() => _BottonNavigationState();
}

class _BottonNavigationState extends State<BottonNavigation> {
  int bottomNavIndex = 0;
  final List name = [
    Home(),
    Calls(),
    Contacts(),
    Settings(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name[bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          onTap: ((index) {
            setState(() {
              bottomNavIndex = index;
            });
          }),
          currentIndex: bottomNavIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                  size: 30,
                ),
                label: "Message",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.call_sharp,
                  size: 30,
                ),
                label: "Calls",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.contacts,
                  size: 30,
                ),
                label: "Contacts",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  size: 30,
                ),
                label: "Settings",
                backgroundColor: Colors.white),
          ]),
    );
  }
}
