// ignore_for_file: override_on_non_overriding_member

import 'package:chat_application/Home.dart';
import 'package:chat_application/signIn.dart';
import 'package:chat_application/signUp.dart';
import 'package:chat_application/uploadDP.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  final List<String> imagePaths = [
    'assets/images/fb.png',
    'assets/images/google.png',
    'assets/images/apple.png',
  ];
  signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuth =
        await googleSignInAccount!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    // Store data in firebase firestore
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userCredential.user!.uid)
        .set({
      'name': userCredential.user!.displayName,
      'email': userCredential.user!.email,
      'profilePic': userCredential.user!.photoURL,
      'uid': userCredential.user!.uid,
    });
    if (userCredential.user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UploadDP()),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            "assets/images/ellipse.png",
          ),
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
        )),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/c.png",
                  width: 27,
                  height: 27,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Chatbox",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text("Connect\nfriends",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 65,
                        fontWeight: FontWeight.w500)),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text("easily &\nquickly",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 65,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                    "Our chat app is the perfect way to stay\nconnected with friends and family.",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildImageCircle(imagePaths[0]),
              GestureDetector(
                  onTap: () async {
                    await signInWithGoogle();
                  },
                  child: buildImageCircle(imagePaths[1])),
              buildImageCircle(imagePaths[2]),
            ]),
            SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.center,
              child: Text("OR",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(
              height: 15,
            ),
            //White button with text
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
              child: Text(
                "Sign up with mail",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300, 50),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Existing account?",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    },
                    child: Text("Log in",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageCircle(String imagePath) {
    return Container(
      width: 65, // Adjust as needed
      height: 65, // Adjust as needed
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          width: 85, // Adjust image size as needed
          height: 85, // Adjust image size as needed
        ),
      ),
    );
  }
}
