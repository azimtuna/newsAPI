import 'package:deneme/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'loginscreen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "AIzaSyCV_O9_C0tug8XgCtN7h2tTIBEKJVBcBHw",
      appId: "1:720756346519:android:e7ffc1fd2d34ed27ec63d2",
      messagingSenderId: "720756346519",
      projectId: "flutterapp-dc726"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NEWS APP",
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor:Colors.white
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[500]),
        ),
      ),
      home: Login(),
      routes: {
        '/login':(context) => Login(),
        '/register':(context)=>Register(),
        '/homepage':(context)=>HomePage(),
        '/tool':(context)=>Tool(),
        '/toolRegister':(context)=>ToolRegister(),
        '/listView':(context)=>ContextElements(),
      },
    );
  }
}

