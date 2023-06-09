// import 'package:assessments_app/pages/Student/StudentPage.dart';
import 'package:assessments_app/pages/Parent/ParentMain.dart';
import 'package:assessments_app/pages/Auth/RegisterScreen.dart';
import 'package:assessments_app/pages/Student/Classes/StudentClasses.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassesPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        Navigator.pop(context);

        final snackBar = SnackBar(
          content: Text(AppLocalizations.of(context)!.emailwrong),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        print("No user found for that email");
      } else if (e.code == 'wrong-password') {
        Navigator.pop(context);
        final snackBar = SnackBar(
          content: Text(AppLocalizations.of(context)!.pwwrong),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print('Wrong password provided for that user.');
      }
    }

    return user;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ASSESS APP v5.0",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 44.0,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.useremail,
                prefixIcon: Icon(Icons.mail, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 26.0,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.userpw,
                prefixIcon: Icon(Icons.lock, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 18.0,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: Color(0xFF29D09E),
                elevation: 0.0,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () async {
                  if (!_emailController.text.contains("@")) {
                    _emailController.text =
                        _emailController.text + "@projectassess.eu";
                  }
                  showLoaderDialog(context);
                  User? user = await loginUsingEmailPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                      context: context);

                  print(user);
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(_emailController.text)
                      .get()
                      .then((DocumentSnapshot documentSnapshot) {
                    if (documentSnapshot.exists) {
                      print('Document data: ${documentSnapshot['Status']}');
                      if (user != null &&
                          documentSnapshot['Status'] == "Teacher") {
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => ClassesPage()));
                      } else if (user != null &&
                          documentSnapshot['Status'] == 'Student') {
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => StudClassesMain()));
                      } else if (user != null &&
                          documentSnapshot['Status'] == 'Parent') {
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => ParentMainScreen()));
                      }
                    } else {
                      Navigator.pop(context);

                      final snackBar = SnackBar(
                          content: Text(
                              AppLocalizations.of(context)!.wrongerror404));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('Document does not exist on the database');
                    }
                  });
                },
                child: Text(
                  AppLocalizations.of(context)!.login,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF29D09E),
                  padding: const EdgeInsets.all(20.0),
                  textStyle: const TextStyle(fontSize: 20.0)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              child: Text(AppLocalizations.of(context)!.greetregister),
            ),
          ],
        ),
      ),
    );
  }
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 7),
            child: Text(AppLocalizations.of(context)!.loggin)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
