import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

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

  TextEditingController _school = TextEditingController();
  File _profileImage = File("");

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: 'gs://assessments-app-o3.appspot.com');

  // String? get _errorText {
  //   // at any time, we can get the text from _controller.value.text
  //   final text = _passwordController.value.text;
  //   // Note: you can do your own custom validation here
  //   // Move this logic this outside the widget for more testable code
  //   if (text.isEmpty) {
  //     return 'Can\'t be empty';
  //   }
  //   if (text.length < 5) {
  //     return 'Too short';
  //   }
  //   // return null if the text is valid
  //   return null;
  // }

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    _storage.ref().child("images/profilepic/${_emailController.text}").putFile(_profileImage);
    return users
        .doc(_emailController.text)
        .set({
          'Email': _emailController.text,
          // 'Password': _passwordController.text,
          'FirstName': _firstName.text, // John Doe
          'LastName': _lastName.text,
          'Status': radioButtonItem,
          'Created': FieldValue.serverTimestamp(),
          'School': _school.text,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> pickImage() async{
      XFile? selected = await ImagePicker().pickImage(source: ImageSource.gallery);
      _profileImage = File(selected!.path);
  }

  // static Future<User?> registerUsingEmailPassword(
  //     {required String email,
  //     required String password,
  //     required BuildContext context}) async {
  //   User? user;
  //   try {
  //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       print('The account already exists for that email.');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return user;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              Text(
                "Registration Page",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 26.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('      ', style: new TextStyle(fontSize: 16),),
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
                height: 26.0,
              ),
              TextField(
                controller: _firstName,
                decoration: InputDecoration(
                  hintText: "First Name",
                ),
              ),
              SizedBox( 
                height: 26.0,
              ),
              TextField(
                controller: _lastName,
                decoration: InputDecoration(
                  hintText: "Last Name",
                ),
              ),
              SizedBox(
                height: 26.0,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty || !val.contains("@") //Mas ele aceita que não seja um mail...
                    ? "enter a valid email"
                    : null,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
              ),
              SizedBox(
                height: 26.0,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  // errorText: _errorText,
                  hintText: "Password",
                ),
              ),
              SizedBox(
                height: 26.0,
              ),
              TextField(
                controller: _school,
                decoration: InputDecoration(
                  hintText: "School",
                ),
              ),
              SizedBox(
                height: 26.0,
              ),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 75,
                    child: ClipOval(
                      child: Image.file(
                        _profileImage,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: IconButton(
                          icon: Icon(Icons.edit), 
                          color: Colors.black,
                          onPressed: () {
                            pickImage();
                            print(_profileImage.path);
                          },
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 3,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50,),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2, 4),
                            color: Colors.black.withOpacity(0.3,),
                            blurRadius: 3,
                          ),
                        ]
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 26.0,
              ),
              Container(
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: Color(0xFF29D09E),
                  elevation: 0.0,
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: () async {
                    try {
                      if (!_emailController.text.contains("@")) {
                        _emailController.text = _emailController.text + "@projectassess.eu";
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
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (e.code == 'email-already-in-use') {
                        print('email-already-in-use');
                        final snackBar = SnackBar(
                            content: Text('The account already exists!!'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } catch (e) {
                      print(e);
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
    );
  }
}
