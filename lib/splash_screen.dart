
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/homePage.dart';
import 'package:wechat/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenPage();
}

class _SplashScreenPage extends State<SplashScreen> {
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Colors.white,));

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      if(FirebaseAuth.instance.currentUser!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomePage()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginPage()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;
    return Scaffold(
        appBar:null,

        body: Stack(
          children: [
            Positioned(
                top: mq.height*.15,
                left: mq.width*.25,
                width: mq.width*.5,
                child:  RichText(text: TextSpan(
                    children: [
                      TextSpan(text: "Welcome to ",style: TextStyle(fontSize: 28,color: Colors.green)),
                      TextSpan(text: " We chat",style: TextStyle(fontSize: 49,color: Colors.purple,fontWeight: FontWeight.bold)),
                    ]
                ),)),
            Positioned(
                top: mq.height*.35,
                left: mq.width*.27,
                width: mq.width*.5,
                child: Image.asset("assets/images/chat.png",)),




          ],
        )

    );
  }
}
