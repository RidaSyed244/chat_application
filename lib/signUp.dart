import 'package:chat_application/SendDataToDB.dart';
import 'package:chat_application/signIn.dart';
import 'package:chat_application/users.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  bool isEmailValid = true;
  bool isPasswordMatch = true;
  bool hasTyped = true;
  void validateEmail(String input) {
    setState(() {
      emailController == input;
      isEmailValid = input.endsWith('@gmail.com');
    });
  }

  void passwordlengthCheck(value) {
    setState(() {
      if (value.length >= 6) {
        hasTyped = true;
      } else {
        hasTyped = false;
      }
    });
  }

  void validpassword(value) {
    setState(() {
      value == passwordController.text;
      isPasswordMatch = value == passwordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignIn()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
        child: ListView(children: [
          SizedBox(
            height: 25,
          ),
          Column(
            children: [
              Container(
                height: 53,
                width: 177,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/line.png",
                    ),
                    alignment: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 23, 0, 0),
                      child: Text(
                        "Sign up with Email",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          // backgroundColor: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                    "Get chatting with friends and family today by\nsigning up for our chat app!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              SizedBox(
                height: 80,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Your name",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.green,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              TextFormField(
                controller: nameController,
                onChanged: (value) async {},
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Your email",
                  style: TextStyle(
                      fontSize: 15,
                      color: isEmailValid ? Colors.green : Colors.red,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              TextFormField(
                controller: emailController,
                onChanged: (value) {
                  validateEmail(value);
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: isEmailValid ? Colors.grey : Colors.red,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (!isEmailValid)
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Invalid email address",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Password",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.green,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                onChanged: (value) async {
                  passwordlengthCheck(value);
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (!hasTyped)
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Password must be 6 characters long",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Confirm Password",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.green,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              TextFormField(
                obscureText: true,
                controller: confirmPasswordController,
                onChanged: (value) async {
                  validpassword(value);
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (!isPasswordMatch)
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Password does not match",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(signup.notifier).SignUp();
              await ref.read(signup.notifier).RegisterUserIndo();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignIn()),
              );
            },
            child: Text(
              "Create an Account",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(300, 50),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
