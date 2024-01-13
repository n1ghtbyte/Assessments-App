import 'package:assessments_app/assets/Mypluggin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'ClassSetup.dart';
import "package:assessments_app/utils/Competences.dart";

class AddCompToClass extends StatefulWidget {
  final String passedClassName;
  final Map passedCompetences;

  const AddCompToClass(this.passedClassName, this.passedCompetences);

  @override
  State<AddCompToClass> createState() => _AddStudentToClassState();
}

class _AddStudentToClassState extends State<AddCompToClass> {
  late Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection(getCompetencesPath()).snapshots();

  final _controllerName = TextEditingController();
  Map<String?, List<String?>> _competences =
      ParentChildCheckbox.selectedChildrens;

  String? currentUser = FirebaseAuth.instance.currentUser!.email;
  var topG; //document ID

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
          // print(i);

          //print(_comps);

          Map<String, dynamic> foo =
              snapshot.data?.docs[i].data()! as Map<String, dynamic>;

          _comps.add(foo);

          // print(foo['Name']);
        }
        print("pppppppppppppppppppppppppppppppppppppppppp");
        print(_comps);
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
              _comps.insert(0, foo2);
              print(foo2['Name']);
            }
            print("*************************************");
            print(_comps);

            print(widget.passedCompetences);

            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.addcomps),
                centerTitle: true,
                backgroundColor: Color(0xFF29D09E),
              ),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Color(0xFF29D09E),
                onPressed: () async {
                  _competences.removeWhere((key, value) => value.isEmpty);
                  var thirdMap = {};

                  thirdMap.addAll(widget.passedCompetences);
                  thirdMap.addAll(_competences);
                  print(thirdMap);

                  await FirebaseFirestore.instance
                      .collection('classes')
                      .doc(widget.passedClassName)
                      .update({
                    'Competences': thirdMap,
                  });

                  // await Future.delayed(Duration(seconds: 1));
                  // context.loaderOverlay.hide();

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClassSetup(
                              passedClassNameSetup: widget.passedClassName)));
                },
                label: Text(AppLocalizations.of(context)!.add),
                icon: Icon(Icons.add, size: 18),
              ),
              body: SafeArea(
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        AppLocalizations.of(context)!.pickcompsclass,
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
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
            );
          },
        );
      },
    );
  }
}
