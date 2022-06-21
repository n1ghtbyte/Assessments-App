// import 'package:assessments_app/pages/Student/StudentPage.dart';
import 'package:assessments_app/pages/RegisterScreen.dart';
import 'package:assessments_app/pages/Student/StudentPage.dart';
import 'package:assessments_app/pages/Teacher/TeacherPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        print("No user found for that email");
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

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
                  style: TextStyle(color: Color.fromARGB(255, 68, 157, 230)),
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => TeacherPage()));
                      } else if (user != null &&
                          documentSnapshot['Status'] == 'Student') {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => StudentPage()));
                      } else if (user != null &&
                          documentSnapshot['Status'] == 'Parent') {
                        final snackBar = SnackBar(
                            content:
                                Text('Parent interface still in development'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (context) => StudentPage()));
                      }
                    } else {
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

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {

//   bool _isHidden = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: ListView(
//           padding: EdgeInsets.symmetric(horizontal: 18.0),
//           children: <Widget>[
//             Column(
//               children: <Widget>[
//                 SizedBox(height: 200),
//                 // Image.asset('assessments_app/lib/assets/eye.jpeg'),
//                 SizedBox(height: 60),
//                 Text(
//                   'Login Screen',
//                   style: TextStyle(fontSize: 24),
//                 ),
//               ],
//             ),
//             SizedBox(height: 60.0),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'E-mail',
//                 filled: true,
//               ),
//             ),
//             SizedBox(height: 20.0),
//             TextField(
//               obscureText: _isHidden,
//               decoration: InputDecoration(
//                 filled: true,
//                 hintText: 'Password',
//                 suffix: InkWell(
//                   onTap: _togglePasswordView,
//                   child: Icon(
//                     _isHidden ? Icons.visibility : Icons.visibility_off,
//                   ),
//                 ),
//               ),
//               // obscureText: true,
//               // decoration: InputDecoration(
//               //   labelText: "Password",
//               //   labelStyle: TextStyle(fontSize: 20),
//               //   filled: true,
//             ),
//             SizedBox(height: 20.0),
//             Column(
//               children: <Widget>[
//                 ElevatedButton(
//                   style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.all<Color>(Color(0xFF29D09E))),
//                   onPressed: () {
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                       builder: (context) => TeacherPage(),
//                     ));
//                   },
//                   child: Text(
//                     'Login',
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                 ),
                
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _togglePasswordView() {
//     setState(() {
//       _isHidden = !_isHidden;
//     });
//   }
// }