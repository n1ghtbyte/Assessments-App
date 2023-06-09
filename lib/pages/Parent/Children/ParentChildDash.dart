import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParentChildDash extends StatefulWidget {
  const ParentChildDash({Key? key}) : super(key: key);

  @override
  State<ParentChildDash> createState() => _ParentChildDashState();
}

class _ParentChildDashState extends State<ParentChildDash> {
  final _controllerParent = TextEditingController();

  @override
  void dispose() {
    _controllerParent.dispose();
    super.dispose();
  }

  final db = FirebaseFirestore.instance;

  String? currentUser = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: 2048576,
    );
    var teacherDoc = db.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: teacherDoc.doc(currentUser).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) {
          return Container(
            child: Center(
                // child: CircularProgressIndicator(),
                ),
          );
        }
        print(snapshot.data?.data());
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        if (data['children'] != null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.children),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: const Color(0xFF29D09E),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(_controllerParent.text)
                    .get()
                    .then((DocumentSnapshot documentSnapshot) {
                  if (documentSnapshot.exists) {
                    if (documentSnapshot['Parents']
                        .contains(currentUser.toString())) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.email
                              .toString())
                          .update({
                        "children":
                            FieldValue.arrayUnion([_controllerParent.text]),
                      });
                    }
                    // childred did not insert parent email
                    else {
                      // final snackBar = SnackBar(
                      //     content: Text(
                      //         'The student did not mention you in his account....'));
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } else {
                    // final snackBar = SnackBar(
                    //     content: Text('The student does not exist ?!?!(...)'));
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });

                Navigator.pop(context);
              },
              icon: Icon(Icons.create),
              label: Text(AppLocalizations.of(context)!.add),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  TextFormField(
                    controller: _controllerParent,
                    decoration: InputDecoration(
                      icon: Icon(Icons.family_restroom_sharp),
                      labelStyle: TextStyle(
                        color: Color(0xFF29D09E),
                      ),
                      helperText: AppLocalizations.of(context)!.childemail,
                      suffixIcon: Icon(Icons.check_circle),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF29D09E)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Divider(),
                  const SizedBox(
                    height: 16,
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: data['children'].length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("${data['children'][index]}"),
                        // onTap: () {
                        //   print(data['Parents'][index]);
                        //   showDialog(
                        //       context: context,
                        //       builder: (_) => AlertDialog(
                        //             title: Text("Remove Parent"),
                        //             content: Text(
                        //                 'Are you sure you wish to remove this parent from your account'),
                        //             actions: [
                        //               TextButton(
                        //                 style: ButtonStyle(
                        //                   foregroundColor:
                        //                       MaterialStateProperty.all<Color>(
                        //                           Colors.blue),
                        //                 ),
                        //                 onPressed: () {
                        //                   Navigator.of(context,
                        //                           rootNavigator: true)
                        //                       .pop();
                        //                 },
                        //                 child: Text('CANCEL'),
                        //               ),
                        //               TextButton(
                        //                 style: ButtonStyle(
                        //                   foregroundColor:
                        //                       MaterialStateProperty.all<Color>(
                        //                           Colors.blue),
                        //                 ),
                        //                 onPressed: () async {
                        //                   Navigator.of(context,
                        //                           rootNavigator: true)
                        //                       .pop();
                        //                   await FirebaseFirestore.instance
                        //                       .collection('users')
                        //                       .doc(currentUser.toString())
                        //                       .update({
                        //                     'Parents': FieldValue.arrayRemove(
                        //                         data['Parents'][index])
                        //                   });
                        //                   Future.microtask(
                        //                       () => Navigator.pop(context));
                        //                 },
                        //                 child: Text(
                        //                   'DELETE',
                        //                 ),
                        //               ),
                        //             ],
                        //           ));
                        // },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.children),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: const Color(0xFF29D09E),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(_controllerParent.text)
                    .get()
                    .then(
                  (DocumentSnapshot documentSnapshot) {
                    if (documentSnapshot.exists) {
                      if (documentSnapshot['Parents']
                          .contains(currentUser.toString())) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.email
                                .toString())
                            .update({
                          "children":
                              FieldValue.arrayUnion([_controllerParent.text]),
                        });
                      }
                      // childred did not insert parent email
                      else {
                        // final snackBar = SnackBar(
                        //     content: Text(
                        //         'The student did not mention you in his account....'));
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      // final snackBar = SnackBar(
                      //     content: Text('The student does not exist ?!?!(...)'));
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                );

                Navigator.pop(context);
              },
              icon: Icon(Icons.create),
              label: Text(AppLocalizations.of(context)!.add),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  TextFormField(
                    controller: _controllerParent,
                    decoration: InputDecoration(
                      icon: Icon(Icons.family_restroom_sharp),
                      labelStyle: TextStyle(
                        color: Color(0xFF29D09E),
                      ),
                      helperText: AppLocalizations.of(context)!.childemail,
                      suffixIcon: Icon(Icons.check_circle),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF29D09E)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Divider(),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
