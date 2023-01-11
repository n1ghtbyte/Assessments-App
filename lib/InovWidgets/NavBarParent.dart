import 'package:assessments_app/pages/Parent/Children/ParentChildDash.dart';
import 'package:assessments_app/pages/Student/Account/AccountStudentPage.dart';
import 'package:assessments_app/pages/SettingsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/LoginScreen.dart';
import '../pages/Teacher/Skills/SkillsPage.dart';

class NavBarParent extends StatefulWidget {
  const NavBarParent({Key? key}) : super(key: key);

  @override
  State<NavBarParent> createState() => _NavBarParentState();
}

class _NavBarParentState extends State<NavBarParent> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Parent'),
            accountEmail: Text(currentUser!),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fwallsdesk.com%2Fwp-content%2Fuploads%2F2017%2F01%2FMonkey-full-HD.jpg&f=1&nofb=1&ipt=57018b07fe12ad8a6f80e410bb382c90681c5a3877a6b6c6dbc213fe37c571d9&ipo=images',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(color: Color(0xFF29D09E)),
          ),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: const Text('Competences'),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SkillsPage()),
              );
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.family_restroom),
            title: const Text('Children'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ParentChildDash()),
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
            enabled: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentProfile()),
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
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text('CANCEL'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () async {
                        await _firebaseAuth.signOut().then(
                          (user) {
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                        );
                      },
                      child: Text('LOGOUT'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

void selectedItem(BuildContext context, int index) {
  switch (index) {
    case 0:
  }
}