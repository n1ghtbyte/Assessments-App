import 'package:assessments_app/pages/Auth/LoginScreen.dart';
import 'package:assessments_app/pages/Teacher/Assessments/AssessmentsMain.dart';
import 'package:assessments_app/pages/Teacher/Skills/SkillsPage.dart';
import 'package:assessments_app/pages/Teacher/Account/TeacherProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'package:firebase_storage/firebase_storage.dart';

class NavBarTeacher extends StatefulWidget {
  const NavBarTeacher({Key? key}) : super(key: key);

  @override
  State<NavBarTeacher> createState() => _NavBarTeacherState();
}

class _NavBarTeacherState extends State<NavBarTeacher> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(AppLocalizations.of(context)!.teacher),
            accountEmail: Text(currentUser!),
            decoration: BoxDecoration(color: Color(0xFF29D09E)),
          ),
          ListTile(
            leading: Icon(Icons.summarize),
            title: Text(AppLocalizations.of(context)!.assessments),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssessmentsMain()),
              );
            },
          ),
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
          Divider(
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text(AppLocalizations.of(context)!.account),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeacherProfile()),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text(AppLocalizations.of(context)!.settings),
          //   onTap: () {
          //     Navigator.pop(context);
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
