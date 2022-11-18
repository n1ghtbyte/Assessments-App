import 'package:assessments_app/InovWidgets/NavBarTeacher.dart';
import 'package:assessments_app/pages/LoginScreen.dart';
import 'package:assessments_app/pages/SettingsPage.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassesPage.dart';
import 'package:assessments_app/pages/Teacher/Skills/SkillsPage.dart';
import 'package:assessments_app/pages/Teacher/TeacherProfile.dart';
import 'package:assessments_app/pages/Teacher/Assessments/AssessmentCheck.dart';
import 'package:assessments_app/pages/Teacher/Assessments/AssessmentFormative.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AssessmentsMain extends StatefulWidget {
  AssessmentsMain({Key? key}) : super(key: key);
  @override
  _AssessmentsMainState createState() => _AssessmentsMainState();
}

class _AssessmentsMainState extends State<AssessmentsMain> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  final Query _classesStream = FirebaseFirestore.instance
      .collection('assessments')
      .where('Creator', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .orderBy('Created', descending: true);

  @override
  Widget build(BuildContext context) {
    //
    return StreamBuilder<QuerySnapshot>(
      stream: _classesStream.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.data?.size.toInt() == 0) {
          return Scaffold(
            // drawer: Drawer(
            //   child: ListView(
            //     padding: EdgeInsets.zero,
            //     children: [
            //       UserAccountsDrawerHeader(
            //         accountName: Text('Teacher'),
            //         accountEmail: Text(currentUser!),
            //         currentAccountPicture: CircleAvatar(
            //           child: ClipOval(
            //             child: Image.network(
            //               // text.data!,
            //               'https://www.cvexpres.com/teaching-jobs-schools/wp-content/uploads/2021/03/convocatoria-bolsa-docente-maestros-infantil-y-primaria-2.jpg',
            //               width: 100,
            //               height: 100,
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         ),
            //         decoration: BoxDecoration(color: Color(0xFF29D09E)),
            //       ),
            //       ListTile(
            //         leading: Icon(Icons.school),
            //         title: const Text('Classes'),
            //         onTap: () {
            //           Navigator.pop(context);
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(builder: (context) => ClassesPage()),
            //           );
            //         },
            //       ),
            //       ListTile(
            //         leading: Icon(Icons.menu_book),
            //         title: const Text('Competences'),
            //         onTap: () {
            //           Navigator.pop(context);

            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(builder: (context) => SkillsPage()),
            //           );
            //         },
            //       ),
            //       const SizedBox(height: 16),
            //       Divider(
            //         thickness: 1,
            //         height: 1,
            //       ),
            //       const SizedBox(height: 16),
            //       ListTile(
            //         leading: Icon(Icons.account_box),
            //         title: const Text('Account'),
            //         onTap: () {
            //           Navigator.pop(context);

            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => TeacherProfile()),
            //           );
            //         },
            //       ),
            //       ListTile(
            //         leading: Icon(Icons.settings),
            //         title: const Text('Settings'),
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(builder: (context) => SettingsPage()),
            //           );
            //         },
            //       ),
            //       ListTile(
            //         leading: Icon(Icons.logout),
            //         title: const Text('Log out'),
            //         onTap: () {
            //           showDialog(
            //             context: context,
            //             builder: (_) => AlertDialog(
            //               title: Text("Logout"),
            //               content: Text('Log out now?'),
            //               actions: [
            //                 TextButton(
            //                   style: ButtonStyle(
            //                     foregroundColor:
            //                         MaterialStateProperty.all<Color>(
            //                             Colors.blue),
            //                   ),
            //                   onPressed: () {
            //                     Navigator.of(context, rootNavigator: true)
            //                         .pop();
            //                   },
            //                   child: Text('CANCEL'),
            //                 ),
            //                 TextButton(
            //                   style: ButtonStyle(
            //                     foregroundColor:
            //                         MaterialStateProperty.all<Color>(
            //                             Colors.blue),
            //                   ),
            //                   onPressed: () async {
            //                     await _firebaseAuth.signOut().then(
            //                       (user) {
            //                         Navigator.of(context, rootNavigator: true)
            //                             .pop();
            //                         Navigator.of(context).pushReplacement(
            //                           MaterialPageRoute(
            //                             builder: (context) => LoginScreen(),
            //                           ),
            //                         );
            //                       },
            //                     );
            //                   },
            //                   child: Text('LOGOUT'),
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            appBar: AppBar(
              title: Text('Assessments'),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            body: Center(
              child: Text(
                "Assessments will be displayed here, once they are generated",
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Assessments'),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            body: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  onTap: () {
                    if (data['Type'] == 'Formative' && data['DONE'] == false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssessmentFormative(
                                  passedAssessmentIdName: data['documentID'],
                                )),
                      );
                    }
                    if (data['Type'] == 'Formative' && data['DONE'] == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssessmentCheck(
                                  passedAssessmentIdName: data['documentID'],
                                )),
                      );
                    }
                  },
                  leading: Icon(Icons.assessment),
                  isThreeLine: true,
                  textColor: data['DONE'] == false
                      ? Color(0xFF29D09E)
                      : Color.fromARGB(255, 123, 123, 123),
                  title: Text('${data['Type']} Assessment'),
                  subtitle: data['Target'].toString() == 'Single'
                      ? Text(
                          "Class Name:${data['ClassName'].toString()}\nStudent:${data['Students'].keys.toList()[0].toString()}\nDate: ${DateFormat('yyyy-MM-dd').format((data['Created'] as Timestamp).toDate())}")
                      : Text(
                          "Class Name:${data['ClassName'].toString()}\nCount:${data['Count'].toString()}/${data['Students'].values.toList().length}\nDate: ${DateFormat('yyyy-MM-dd').format((data['Created'] as Timestamp).toDate())}"),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
