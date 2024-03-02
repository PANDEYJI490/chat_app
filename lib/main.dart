import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/homePage.dart';
import 'package:wechat/login_page.dart';
import 'package:wechat/splash_screen.dart';

import 'firebase_option.dart';
Future<void> main()async{

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(// navigation bar color
    statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.white,
     // color of navigation control
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((value){


     Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MyApp());
  });

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 3,

        )
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );

  }
}
class MyhomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyhomePage();
  }
}
class _MyhomePage extends State<MyhomePage>{

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: null,

   );
  }

}