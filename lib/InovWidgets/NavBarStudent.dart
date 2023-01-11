import 'package:assessments_app/pages/Student/Account/AccountStudentPage.dart';
import 'package:assessments_app/pages/Student/AssessmentsStudent.dart';
import 'package:assessments_app/pages/SettingsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/LoginScreen.dart';
import '../pages/Student/Parents/ChildParentDash.dart';
import '../pages/Teacher/Skills/SkillsPage.dart';

class NavBarStudent extends StatefulWidget {
  const NavBarStudent({Key? key}) : super(key: key);

  @override
  State<NavBarStudent> createState() => _NavBarStudentState();
}

class _NavBarStudentState extends State<NavBarStudent> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Student'),
            accountEmail: Text(currentUser!),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fassets.rebelmouse.io%2FeyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpbWFnZSI6Imh0dHBzOi8vbWVkaWEucmJsLm1zL2ltYWdlP3U9JTJGZmlsZXMlMkYyMDE2JTJGMDElMkYzMCUyRjYzNTg5Nzg0OTYwNTk3MjY4NTY4MDg3NDcyOF9ocWRlZmF1bHQuanBnJmhvPWh0dHAlM0ElMkYlMkZjZG4xLnRoZW9keXNzZXlvbmxpbmUuY29tJnM9MjY2Jmg9Mzc5MTBkZGUwZjJlOGY0NTgzNWFlMmMzY2YxY2M0ZWJkNjE0OGRjNDNhNTQ0ZmJkOTJiOGIwOWY2MTFjMTNmNiZzaXplPTk4MHgmYz0xMzkwMTc3OTI0IiwiZXhwaXJlc19hdCI6MTYzNTc3Njk1OH0.HaupP3FySlrtGGcpppHs91IZBjNLhPoVabuCOwfGEnA%2Fimg.jpg%3Fwidth%3D1200%26height%3D628&f=1&nofb=1',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(color: Color(0xFF29D09E)),
          ),
          ListTile(
            leading: Icon(Icons.summarize),
            title: const Text('Assessments'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AssessmentsStudentAll()),
              );
            },
          ),
          const SizedBox(height: 16),
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
            title: const Text('Parents'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChildParentDash()),
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
