import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:assessments_app/assets/group_radio_button.dart';
// import 'package:basic_utils/basic_utils.dart';

class AssessmentFormative extends StatefulWidget {
  final String passedAssessmentIdName;
  const AssessmentFormative({Key? key, required this.passedAssessmentIdName})
      : super(key: key);
  @override
  _AssessmentFormativeState createState() => _AssessmentFormativeState();
}

class _AssessmentFormativeState extends State<AssessmentFormative> {
  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  Future<void> addGrade(String stud, Map<dynamic, Map<dynamic, dynamic>> comp,
      var assessinfo, String _id) {
    late CollectionReference assessments = FirebaseFirestore.instance
        .collection('classes')
        .doc(assessinfo['ClassId'].toString())
        .collection("grading")
        .doc(stud.toString())
        .collection("grades");

    // Call the user's CollectionReference to add a new assessment
    return assessments.add({
      'ClassName': assessinfo['ClassId'],
      'Created': FieldValue.serverTimestamp(),
      'Creator': currentUser,
      'Type': "Formative",
      'Competences': comp,
      'AssessID': _id,
    }).then((value) {
      print(value.id);
    });
  }

  String? number; //no radio button will be selected
  Map<dynamic, Map<dynamic, dynamic>> _mapao = {};
  Map<dynamic, dynamic> kek = Map();
  Map<dynamic, dynamic> _mapinha = {};
  Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('Competences').snapshots();

  final CollectionReference _assess =
      FirebaseFirestore.instance.collection('assessments');

  Future<void> updateAssessment(
      String _docid, Map _alumni, var data, bool done) {
    return _assess
        .doc(_docid)
        .update({
          'Students': _alumni,
          'DONE': done,
          'Count': data['Count'] + 1,
        })
        .then((value) => print("Assessment Updated"))
        .catchError((error) => print("Failed to update assessment: $error"));
  }

  List<String> textifier(List<dynamic>? x) {
    return x!.cast<String>();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: _assess.doc(widget.passedAssessmentIdName).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snp) {
                if (snp.hasError) {
                  return Text('Something went wrong');
                }

                if (snp.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                Map<String, List<dynamic>> _comps = {};
                //  print("dados da snap" + snp.data!.docs.length.toString());
                for (var i = 0; i < 11; i++) {
                  // print("pppppppppppppppppppppppppppppppppppppppppp");
                  // print(i);

                  //print(_comps);
                  // print(snp.data?.docs[i].data().runtimeType);

                  Map<String, dynamic> foo =
                      snp.data?.docs[i].data()! as Map<String, dynamic>;
                  for (var f in foo.keys) {
                    if (f.toString() != "Name") {
                      _comps[f.toString()] = foo[f.toString()];
                    }
                  }
                }

                List studsToAssess = [];

                Map studs = data['Students'];
                var assesId = data['documentID'];

                studs.forEach((key, value) {
                  if (value == false) studsToAssess.add(key);
                });

                var currentStudent = studsToAssess[0];

                //List<bool> isChecked = List<bool>.filled(50, false);
                var _indicators = [];
                List<String> namesC = [];
                List<String> allIndicators = [];

                var namesComp = data['Competences'].keys;
                for (var t in namesComp) {
                  namesC.add(t);
                }

                for (var x in data['Competences'].values) {
                  _indicators.add(x);
                }

                for (var i in _indicators) {
                  for (var j in i) {
                    allIndicators.add(j);
                  }
                }

                // print(List<String>.from([
                //   "Contributing suggestions for the ideas, situations, cases or problems posed"
                // ]));
                // print("lqlqlq");

                return MaterialApp(
                  home: Scaffold(
                    appBar: AppBar(
                      title: Text('Formative Assessment'),
                      centerTitle: true,
                      backgroundColor: Color(0xFF29D09E),
                    ),
                    floatingActionButton: FloatingActionButton.extended(
                      backgroundColor: const Color(0xFF29D09E),
                      onPressed: () {
                        //Navigator.pop(context=
                        // print(currentStudent);
                        for (var ent in _mapinha.keys) {
                          _mapinha[ent] =
                              _mapinha[ent].toString().substring(0, 1);
                        }
                        print("-----------------------------------------");
                        for (var skill in _mapao.keys) {
                          // print(_mapao[skill]);
                          // _mapao[skill]
                          //     ?.forEach((k, v) => print(v.substring(0, 1)));
                          _mapao[skill]?.updateAll(
                              ((key, value) => value = value.substring(0, 1)));

                          // _mapao[skill] = {
                          //   _mapao[skill].toString():
                          //       _mapao[indicator].toString().substring(0, 1)
                        }

                        // }

                        // Map<String, Map<String, String>> uploadComps = {};
                        // for (var compName in namesC) {
                        //For each competence name, assing a map
                        // print(compName);
                        //   print(_mapinha.entries);
                        //   for (var indicatorFoo in _comps.keys) {
                        //     if (_mapinha.containsKey(indicatorFoo)) {
                        //       // print(indicatorFoo);
                        //       uploadComps[compName] = _mapinha.map((key,
                        //               value) =>
                        //           MapEntry(key.toString(), value.toString()));
                        //     }
                        //   }
                        // }
                        studs[currentStudent] = true;
                        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                        print(_mapao);

                        // print(uploadComps);
                        addGrade(currentStudent, _mapao, data, assesId);
                        bool x = true;
                        for (var k in studs.values) {
                          if (k == false) x = false;
                        }
                        updateAssessment(
                            widget.passedAssessmentIdName, studs, data, x);
                        if (x == true) {
                          FirebaseFirestore.instance
                              .collection('classes')
                              .doc(data['ClassId'])
                              .update({'prevAssess': FieldValue.increment(1)});
                          Navigator.pop(context);
                        } else {
                          print(studs);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      super.widget));
                        }
                      },
                      icon: Icon(Icons.skip_next),
                      label: Text('Next'),
                    ),
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "Student: $currentStudent\nClass:${data['ClassName']}\nCount:${data['Count']}/${studs.length}\n",
                                style: TextStyle(fontSize: 26),
                              ),
                            ),
                            for (var k in namesC)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Divider(
                                        height: 20,
                                        thickness: 4,
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Text(
                                        k,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      for (String x in List<String>.from(
                                          data['Competences'][k] as List))
                                        Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(children: <Widget>[
                                            Divider(
                                              height: 4,
                                            ),
                                            Text(
                                              x,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            RadioGroup<String>.builder(
                                              spacebetween: 65.0,
                                              direction: Axis.vertical,
                                              groupValue: _mapinha[x.toString()]
                                                  .toString(),
                                              horizontalAlignment:
                                                  MainAxisAlignment.start,
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    _mapinha[x.toString()] =
                                                        value.toString();
                                                    if (_mapao[k.toString()] !=
                                                        null) {
                                                      _mapao[k.toString()]![
                                                              x.toString()] =
                                                          value.toString();
                                                    } else {
                                                      _mapao[k.toString()] =
                                                          Map();
                                                    }
                                                    _mapao[k.toString()]![
                                                            x.toString()] =
                                                        value.toString();

                                                    print(_mapao.toString());
                                                  },
                                                );
                                              },

                                              activeColor: Color(0xFF29D09E),
                                              items: textifier(_comps[x]),
                                              //List<String>.from(kek[x]),
                                              //     [
                                              //   "1",
                                              //   "2",
                                              //   "3",
                                              //   "4",
                                              //   "5",
                                              // ],

                                              textStyle: TextStyle(
                                                fontSize: 14,
                                              ),
                                              itemBuilder: (item) =>
                                                  RadioButtonBuilder(
                                                      item.toString(),
                                                      textPosition:
                                                          RadioButtonTextPosition
                                                              .left),
                                            ),
                                          ]),
                                        )
                                    ]),
                              ),
                            SizedBox(
                              height: 32,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}

// String _wrapLine(String line, int wrapLength) {
//   List<String> resultList = [];

//   if (line == "" || line.length == 0) {
//     resultList.add("");
//     return "";
//   }
//   if (line.length <= wrapLength) {
//     resultList.add(line);
//     return line;
//   }

//   List<String> words = line.split(" ");

//   for (String word in words) {
//     if (resultList.length == 0) {
//       addNewWord(resultList, word, wrapLength);
//     } else {
//       String lastLine = resultList.last;

//       if (lastLine.length + word.length < wrapLength) {
//         lastLine = lastLine + word + " ";
//         resultList.last = lastLine;
//       } else if (lastLine.length + word.length == wrapLength) {
//         lastLine = lastLine + word;
//         resultList.last = lastLine;
//       } else {
//         if (_isThereMuchSpace(lastLine, wrapLength.toDouble())) {
//           _breakLongWord(resultList, word, wrapLength, lastLine.length);
//         } else {
//           addNewWord(resultList, word, wrapLength);
//         }
//       }
//     }
//   }

//   return resultList.join("\n");
// }

// void addNewWord(List<String> resultList, String word, int wrapLength) {
//   if (word.length < wrapLength) {
//     resultList.add(word + " ");
//   } else if (word.length == wrapLength) {
//     resultList.add(word);
//   } else {
//     _breakLongWord(resultList, word, wrapLength, 0);
//   }
// }

// void _breakLongWord(
//     List<String> resultList, String word, int wrapLength, int offset) {
//   String part = word.substring(0, (wrapLength - offset) - 1);
//   if (offset > 1) {
//     String lastLine = resultList.last;
//     lastLine = lastLine + part + "-";
//     resultList.last = lastLine;
//   } else {
//     resultList.add(part + "-");
//   }

//   String nextPart = word.substring((wrapLength - offset) - 1, word.length);
//   if (nextPart.length > wrapLength)
//     _breakLongWord(resultList, nextPart, wrapLength, 0);
//   else if (nextPart.length == wrapLength)
//     resultList.add(nextPart);
//   else
//     resultList.add(nextPart + " ");
// }

// bool _isThereMuchSpace(String line, double lineLength) {
//   double expectedPercent = (lineLength * 65) / 100;
//   if (line.length <= expectedPercent) return true;
//   return false;
// }
