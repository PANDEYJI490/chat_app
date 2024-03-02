import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wechat/helper.dart';
import 'package:wechat/homePage.dart';

import 'api_firebase.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  HandleGooglebtn() {
    Dialogs.showProgressbar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        if (await (Api.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomePage()));
          print('pawan');
          print(user);
        } else {
          await Api.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomePage()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("welcome to We Chat"),
        ),
        body: Stack(
          children: [
            Positioned(
                top: mq.height * .15,
                left: mq.width * .25,
                width: mq.width * .5,
                child: Image.asset(
                  "assets/images/chat.png",
                )),
            Positioned(
                bottom: mq.height * .20,
                left: mq.width * .05,
                width: mq.width * .9,
                height: mq.height * .07,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen),
                    onPressed: () {
                      HandleGooglebtn();
                    },
                    icon: Image.asset(
                      "assets/images/google.png",
                      height: mq.height * .05,
                    ),
                    label: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Signin With ",
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54)),
                        TextSpan(
                            text: " Google",
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ))),
            Positioned(
                bottom: mq.height * .10,
                left: mq.width * .05,
                width: mq.width * .9,
                height: mq.height * .07,
                child: ElevatedButton.icon(
                    onPressed: () {
                      SignInWithAppleButton(
                        onPressed: () async {
                          final credential = await SignInWithApple.getAppleIDCredential(
                            scopes: [
                              AppleIDAuthorizationScopes.email,
                              AppleIDAuthorizationScopes.fullName,
                            ],
                          );

                          print(credential);

                          // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                          // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                        },
                      );
                    },
                    icon: Icon(Icons.apple),
                    label: Text("Apple Sign in")))
          ],
        ));
  }
}
