import 'package:assessments_app/pages/Student/Account/AccountStudentPage.dart';
import 'package:assessments_app/pages/Student/Assessments/AssessmentsStudent.dart';
import 'package:assessments_app/pages/Settings/SettingsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/Auth/LoginScreen.dart';
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
            accountName: Text(AppLocalizations.of(context)!.student),
            accountEmail: Text(currentUser!),
            decoration: BoxDecoration(color: Color(0xFF29D09E)),
          ),
          ListTile(
            leading: Icon(Icons.summarize),
            title: Text(AppLocalizations.of(context)!.assessments),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssessmentsStudent()),
              );
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text(AppLocalizations.of(context)!.competences),
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
            title: Text(AppLocalizations.of(context)!.parents),
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
            title: Text(AppLocalizations.of(context)!.account),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentProfile()),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text(AppLocalizations.of(context)!.settings),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SettingsPage()),
          //     );
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.logout),
                  content: Text(AppLocalizations.of(context)!.logout),
                  actions: [
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(AppLocalizations.of(context)!.cancel),
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
                      child: Text(AppLocalizations.of(context)!.logout),
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
