import 'package:assessments_app/firebase_options.dart';
import 'package:assessments_app/pages/LoginScreen.dart';
import 'package:assessments_app/pages/Parent/ParentMain.dart';
import 'package:assessments_app/pages/Student/Classes/StudentClasses.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassesPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(MyApp());
}

Future<FirebaseApp> _initializeFirebase() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  return firebaseApp;
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF29D09E),
        scaffoldBackgroundColor: Colors.white,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
            TargetPlatform.values,
            value: (dynamic _) => const ZoomPageTransitionsBuilder(),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(background: Colors.white),
      ),
      home: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            FirebaseAuth.instance.authStateChanges().listen((User? user) {
              if (user != null) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.email)
                    .get()
                    .then((DocumentSnapshot documentSnapshot) {
                  if (documentSnapshot.exists) {
                    print('Document data: ${documentSnapshot['Status']}');
                    if (documentSnapshot['Status'] == "Teacher") {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ClassesPage()));
                    } else if (documentSnapshot['Status'] == 'Student') {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => StudClassesMain()));
                    } else if (documentSnapshot['Status'] == 'Parent') {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ParentMainScreen()));
                    }
                  }
                });
              }
            });
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
