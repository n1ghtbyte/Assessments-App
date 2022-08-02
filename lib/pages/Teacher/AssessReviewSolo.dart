import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:assessments_app/assets/group_radio_button.dart';

class AssessReview extends StatefulWidget {
  final String passedAssessmentIdName;
  final String passedClassName;
  final String passedStudName;

  const AssessReview(
      {Key? key,
      required this.passedAssessmentIdName,
      required this.passedClassName,
      required this.passedStudName})
      : super(key: key);
  @override
  _AssessReviewState createState() => _AssessReviewState();
}

class _AssessReviewState extends State<AssessReview> {
  final Stream<QuerySnapshot> _compsStream =
      FirebaseFirestore.instance.collection('Competences').snapshots();
  final CollectionReference _assess =
      FirebaseFirestore.instance.collection('assessments');
  final CollectionReference _grades =
      FirebaseFirestore.instance.collection('classes');

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
          // data -> assessment
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return StreamBuilder<QuerySnapshot>(
              stream: _compsStream,
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
                for (var i = 0; i < 11; i++) {
                  Map<String, dynamic> foo =
                      snp.data?.docs[i].data()! as Map<String, dynamic>;
                  for (var f in foo.keys) {
                    if (f.toString() != "Name") {
                      _comps[f.toString()] = foo[f.toString()];
                    }
                  }
                }
                //_comps -> competencias
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
                return StreamBuilder<QuerySnapshot>(
                    stream: _grades
                        .doc(widget.passedClassName)
                        .collection('grading')
                        .doc(widget.passedStudName)
                        .collection('grades')
                        .where('AssessID',
                            isEqualTo: widget.passedAssessmentIdName)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> gradesnp) {
                      if (gradesnp.hasError) {
                        return Text('Something went wrong');
                      }
                      if (gradesnp.connectionState == ConnectionState.waiting) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      // grades of studend X
                      Map savedGrade = Map<String, dynamic>.from(
                          gradesnp.data?.docs[0].data()
                              as Map<String, dynamic>);
                      savedGrade = savedGrade['Competences'];

                      return Scaffold(
                        appBar: AppBar(
                          title: Text('Reviewing'),
                          centerTitle: true,
                          backgroundColor: Color(0xFF29D09E),
                        ),
                        floatingActionButton: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FloatingActionButton(
                                heroTag: "btn1",
                                onPressed: () {},
                                child: Icon(Icons.skip_previous),
                                backgroundColor: Color(0xFF29D09E),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Container()),
                              FloatingActionButton(
                                heroTag: "btn2",
                                onPressed: () {},
                                child: Icon(Icons.skip_next),
                                backgroundColor: Color(0xFF29D09E),
                              ),
                            ],
                          ),
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
                                    "Student: ${widget.passedStudName}\nClass:${data['ClassName']}\n",
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
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                RadioGroup<String>.builder(
                                                  spacebetween: 65.0,
                                                  direction: Axis.vertical,
                                                  groupValue: _comps[x]
                                                      ?.toList()[int.parse(
                                                          savedGrade[k][x]) -
                                                      1],
                                                  horizontalAlignment:
                                                      MainAxisAlignment.start,
                                                  onChanged: (value) =>
                                                      setState(() {
                                                    var docId = gradesnp.data!
                                                        .docs[0].reference.id
                                                        .toString();

                                                    _grades
                                                        .doc(widget
                                                            .passedClassName)
                                                        .collection('grading')
                                                        .doc(widget
                                                            .passedStudName)
                                                        .collection('grades')
                                                        .doc(docId)
                                                        .update({
                                                      "Competences.$k": {
                                                        x: value
                                                            .toString()
                                                            .substring(0, 1)
                                                      }
                                                    }).then(
                                                            (value) => print(
                                                                "DocumentSnapshot successfully updated!"),
                                                            onError: (e) => print(
                                                                "Error updating document $e"));
                                                  }),
                                                  activeColor:
                                                      Color(0xFF29D09E),
                                                  items: textifier(_comps[x]),
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
                                  height: 64,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              });
        });
  }
}

List<String> textifier(List<dynamic>? x) {
  return x!.cast<String>();
}