import 'package:assessments_app/pages/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(), //Something is wrong here!
      // darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.dark,
      theme: ThemeData(
          primaryColor: Color(0xFF29D09E),
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.grey[200]),
      home: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
