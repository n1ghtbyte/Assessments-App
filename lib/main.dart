import 'package:assessments_app/pages/LoginScreen.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assessments_app/pages/Student/StudentPage.dart';
import 'package:assessments_app/pages/Teacher/TeacherPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            FirebaseAuth.instance.authStateChanges().listen((User? user) {
              if(user != null) {
                FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.email)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                            if (documentSnapshot.exists) {
                              print('Document data: ${documentSnapshot['Status']}');
                              if (documentSnapshot['Status'] == "Teacher") {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => TeacherPage()));
                              } else if (documentSnapshot['Status'] == 'Student') {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => StudentPage()));
                              } else if (documentSnapshot['Status'] == 'Parent') {
                                final snackBar = SnackBar(
                                    content:
                                        Text('Parent interface still in development'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                //     builder: (context) => StudentPage()));
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
