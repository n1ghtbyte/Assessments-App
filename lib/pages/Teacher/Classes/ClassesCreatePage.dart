import 'dart:async';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassSetup.dart';
import 'package:flutter/material.dart';
import 'package:assessments_app/assets/Mypluggin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClassesCreatePage extends StatefulWidget {
  const ClassesCreatePage({Key? key}) : super(key: key);

  @override
  _ClassesCreatePageState createState() => _ClassesCreatePageState();
}

class _ClassesCreatePageState extends State<ClassesCreatePage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  late Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('CompetencesPT').snapshots();

  final _controllerName = TextEditingController();
  Map<String?, List<String?>> _competences =
      ParentChildCheckbox.selectedChildrens;

  CollectionReference classes =
      FirebaseFirestore.instance.collection('classes');

  String? currentUser = FirebaseAuth.instance.currentUser!.email;
  String? _iD;
  var topG; //document ID
  Future<void> addClass() {
    // Call the user's CollectionReference to add a new user
    _competences.removeWhere((key, value) => value.isEmpty);
    return classes.add({
      'Created': FieldValue.serverTimestamp(),
      'Name': _controllerName.text, // John Doe
      'TeacherID': currentUser,
      'NumStudents': 0,
      'Competences': _competences,
      'StudentList': [],
      'documentID': _iD,
      'prevAssess': 0,
      'currAssess': 0,
    }).then((value) {
      print(value.id);
      topG = value;
      updateClass(value.id);
    });
  }

  List<Text> textify(List x) {
    List<Text> result = [];
    for (var k in x) {
      //print(k);
      if (k != "Name") {
        result.add(Text(
          k.toString(),
          // overflow: TextOverflow.ellipsis,
          // softWrap: true,
        ));
      }
    }

    return result;
  }

  Future<void> updateClass(String _docid) {
    return classes
        .doc(_docid)
        .update({'documentID': _docid})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  List<Map<String, dynamic>> _comps = [];
  @override
  void dispose() {
    _controllerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
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
        print("--------------------------------------------");
        // print(snapshot.data!.docs[0].data()?.toString());
        int actualNumberComp = snapshot.data!.docs.length;
        for (var i = 0; i < actualNumberComp; i++) {
          // print("pppppppppppppppppppppppppppppppppppppppppp");
          // print(i);

          //print(_comps);

          Map<String, dynamic> foo1 =
              snapshot.data?.docs[i].data()! as Map<String, dynamic>;
          _comps.add(foo1);
          // print(foo['Name']);
        }
        print(_competences);

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser)
              .collection('PrivateCompetences')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshotprivate) {
            if (snapshotprivate.hasError) {
              return Text("Something went wrong");
            }
            if (!snapshotprivate.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            int actualNumberCompPrivate = snapshotprivate.data!.docs.length;
            for (var i = 0; i < actualNumberCompPrivate; i++) {
              Map<String, dynamic> foo2 =
                  snapshotprivate.data?.docs[i].data()! as Map<String, dynamic>;
              _comps.add(foo2);
              print(foo2['Name']);
            }
            print("*************************************");
            print(_comps);

            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.createclass),
                centerTitle: true,
                backgroundColor: Color(0xFF29D09E),
              ),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Color(0xFF29D09E),
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.

                    context.loaderOverlay.show();

                    await addClass();

                    await Future.delayed(Duration(seconds: 1));
                    context.loaderOverlay.hide();

                    print(topG.id);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClassSetup(passedClassNameSetup: topG.id),
                      ),
                    );
                    final snackBar = SnackBar(
                      content: Text(AppLocalizations.of(context)!.geningcc),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //       content: Text(
                    //           AppLocalizations.of(context)!.enterclassname)),
                    // );
                  }
                },
                label: Text(AppLocalizations.of(context)!.create),
                icon: Icon(Icons.add, size: 18),
              ),
              body: LoaderOverlay(
                child: SafeArea(
                  child: ListView(
                    children: [
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _controllerName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.entertxt;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff388e3c)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff388e3c)),
                            ),
                            icon: Icon(Icons.person),
                            labelText: AppLocalizations.of(context)!.classname,
                            labelStyle: TextStyle(
                              color: Color(0xFF29D09E),
                            ),
                            helperText:
                                AppLocalizations.of(context)!.enterclassname,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Divider(
                        thickness: 1,
                        height: 1,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ListTile(
                        leading: Icon(Icons.computer),
                        title: Text(AppLocalizations.of(context)!.competences),
                        subtitle: Text(AppLocalizations.of(context)!.pickind),
                        enabled: true,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0;
                              i < actualNumberComp + actualNumberCompPrivate;
                              i++)
                            ParentChildCheckbox(
                              parentCheckboxColor: Color(0xFF29D09E),
                              childrenCheckboxColor: Color(0xff388e3c),
                              parent: Text(
                                _comps[i]['Name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              children: textify(_comps[i].keys.toList()),
                            ),
                        ],
                      ),
                      SizedBox(height: 64),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
