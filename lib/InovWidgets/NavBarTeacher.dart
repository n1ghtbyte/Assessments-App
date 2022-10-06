import 'dart:developer';

import 'package:assessments_app/pages/LoginScreen.dart';
import 'package:assessments_app/pages/SettingsPage.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassesPage.dart';
import 'package:assessments_app/pages/Teacher/Skills/SkillsPage.dart';
import 'package:assessments_app/pages/Teacher/TeacherProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NavBarTeacher extends StatefulWidget {
  const NavBarTeacher({Key? key}) : super(key: key);

  @override
  State<NavBarTeacher> createState() => _NavBarTeacherState();
}

class _NavBarTeacherState extends State<NavBarTeacher> {
  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: 'gs://assessments-app-o3.appspot.com');
  String _profilePic="";

  Future<void> getImage() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imgUrl = await storageRef
        .child('images/profilepic/$currentUser')
        .getDownloadURL(); 
    _profilePic = imgUrl;
    //_profilePic = await _storage.ref("images/profilepic/$currentUser").getDownloadURL();
    //_profilePic = "https://firebasestorage.googleapis.com/v0/b/assessments-app-o3.appspot.com/o/images%2Fprofilepic%2Fe%40projectassess.eu?alt=media&token=1b17ba25-6f69-4eb2-968b-87c52d048ce1";
  }

  @override
  Widget build(BuildContext context) {
    getImage();
    inspect(_profilePic);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [ 
          UserAccountsDrawerHeader(
            accountName: Text('Teacher'),
            accountEmail: Text(currentUser!),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  _profilePic,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                //Image.network(
                  //'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfDUf1sal3kszOWelEchcmmhjaZwbYCwa-Iw&usqp=CAU',
                  //width: 100,
                  //height: 100,
                  //fit: BoxFit.cover,
                //),
              ),
            ),
            decoration: BoxDecoration(color: Color(0xFF29D09E)),
          ),
          // ListTile(
          //   leading: Icon(Icons.assessment),
          //   title: const Text('Assessments'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => AssessmentsTeacherPage()),
          //     );
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.school),
            title: const Text('Classes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClassesPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: const Text('Competences'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SkillsPage()),
              );
            },
          ),
          const SizedBox(height: 16),
          Divider(
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.account_box),
            title: const Text('Account'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeacherProfile()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                            title: Text("Logout"),
                            content: Text('Log out now?'),
                            actions: [
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                ),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Text('CANCEL'),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                ),
                                // onPressed: () async {
                                //   await _googleSignIn.signOut();
                                //   setState(() {});
                                // },
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => QuitPage()),

                                onPressed: () async {
                                  await _signOut();
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text('LOGOUT'),
                              )
                            ]));
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => LogoutPage()),
                // );
              }),
        ],
      ),
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
  print("User Logged out");
}

void selectedItem(BuildContext context, int index) {
  switch (index) {
    case 0:
  }
}
