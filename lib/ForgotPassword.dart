// ignore_for_file: unused_field, unused_element

import 'package:chat_application/SendDataToDB.dart';
import 'package:chat_application/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPswrd extends StatefulWidget {
  ForgotPswrd({super.key});

  @override
  State<ForgotPswrd> createState() => _ForgotPswrdState();
}

class _ForgotPswrdState extends State<ForgotPswrd> {
  final forgotPswrdAuth = FirebaseAuth.instance;
  
  bool _isTyping = false;
  @override
  void initState() {
    super.initState();

    // Listen to changes in the text field
    forgotPasswordController.addListener(() {
      setState(() {
        _isTyping = forgotPasswordController.text.isNotEmpty;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignIn()));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 90, 30, 0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Forgot Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 30.0),
            Text('Fill the email and send request to \nreset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                )),
            SizedBox(height: 40.0),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  "Your email",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              controller: forgotPasswordController,
              onChanged: (value) {},
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.mail,
                  color: Colors.white,
                ),
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await forgotPswrdAuth.sendPasswordResetEmail(
                        email: forgotPasswordController.text);
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  "Send request",
                  style: TextStyle(
                    color: _isTyping ? Colors.white : Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: _isTyping ? Colors.teal : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
