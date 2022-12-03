// import 'package:assessments_app/pages/Student/StudentPage.dart';
import 'package:assessments_app/pages/RegisterScreen.dart';
import 'package:assessments_app/pages/Student/StudentPage.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassesPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        const snackBar = SnackBar(
          content: Text('No user found for that email'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        print("No user found for that email");
      } else if (e.code == 'wrong-password') {
        Navigator.pop(context);
        const snackBar = SnackBar(
          content: Text('Wrong password provided for that user'),
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
              "ASSESS APP",
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
                hintText: "User Email",
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
                hintText: "User Password",
                prefixIcon: Icon(Icons.lock, color: Colors.black),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterScreen()));
                },
                child: Text(
                  "Register",
                  style: TextStyle(color: Color.fromARGB(255, 21, 78, 54)),
                )),
            SizedBox(
              height: 8.0,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: Color(0xFF29D09E),
                elevation: 0.0,
                padding: EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                onPressed: () async {
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
                            builder: (context) => StudentPage()));
                      } else if (user != null &&
                          documentSnapshot['Status'] == 'Parent') {
                        Navigator.pop(context);

                        final snackBar = SnackBar(
                            content:
                                Text('Parent interface still in development'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (context) => StudentPage()));
                      }
                    } else {
                      Navigator.pop(context);

                      final snackBar =
                          SnackBar(content: Text('That user does not exist'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('Document does not exist on the database');
                    }
                  });
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            )
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
        Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
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
