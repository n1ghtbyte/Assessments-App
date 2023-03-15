import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String radioButtonItem = 'Parent';
  int id = 0;

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordController2 = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(_emailController.text)
        .set({
          'Email': _emailController.text,
          // 'Password': _passwordController.text,
          'FirstName': _firstName.text, // John Doe
          'LastName': _lastName.text,
          'Status': radioButtonItem,
          'Created': FieldValue.serverTimestamp(),
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 44.0,
                  ),
                  SizedBox(
                    height: 44.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Registration Page",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 44.0,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: _firstName,
                      decoration: InputDecoration(
                          hintText: "First Name",
                          prefixIcon: Icon(Icons.person)),
                    ),
                  ),
                  SizedBox(
                    height: 44.0,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: _lastName,
                      decoration: InputDecoration(
                        hintText: "Last Name",
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 44.0,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      validator: (val) => val!.isEmpty || !val.contains("@")
                          ? "enter a valid email"
                          : null,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter you email or account name",
                        prefixIcon: Icon(Icons.email),
                      ),
                      // ,
                    ),
                  ),
                  SizedBox(
                    height: 44.0,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,

                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      // decoration: buildInputDecoration(Icons.lock, "Password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please a Enter Password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 44.0,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: _passwordController2,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      // decoration:
                      //     buildInputDecoration(Icons.lock, "Confirm Password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please re-enter password';
                        }
                        print(_passwordController.text);
                        print(_passwordController2.text);
                        if (_passwordController.text !=
                            _passwordController2.text) {
                          return "Password does not match";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 44.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Teacher';
                            id = 1;
                          });
                        },
                      ),
                      Text(
                        'Teacher',
                        style: new TextStyle(fontSize: 16),
                      ),
                      Radio(
                        value: 2,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Student';
                            id = 2;
                          });
                        },
                      ),
                      Text(
                        'Student',
                        style: new TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Radio(
                        value: 3,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Parent';
                            id = 3;
                          });
                        },
                      ),
                      Text(
                        'Parent',
                        style: new TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 14,
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
                        if (_passwordController.text ==
                            _passwordController2.text) {
                          try {
                            if (!_emailController.text.contains("@")) {
                              _emailController.text =
                                  _emailController.text + "@projectassess.eu";
                            }
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                            addUser();
                            Navigator.of(context).pop();
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                              final snackBar = SnackBar(
                                  content: Text(
                                      'The password provided is too weak. (min 8 chars)'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (e.code == 'email-already-in-use') {
                              print('email-already-in-use');
                              final snackBar = SnackBar(
                                  content:
                                      Text('The account already exists!!'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          final snackBar =
                              SnackBar(content: Text('Passwords do not match'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration buildInputDecoration(IconData icons, String hinttext) {
  return InputDecoration(
    hintText: hinttext,
    prefixIcon: Icon(icons),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.green, width: 1.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 1.5,
      ),
    ),
  );
}
