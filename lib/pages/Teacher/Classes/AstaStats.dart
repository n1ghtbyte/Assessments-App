import 'package:assessments_app/pages/Teacher/Assessments/AssessmentsCreateTeacherPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:assessments_app/model/FormativeData.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class AstaStats extends StatefulWidget {
  final String passedStudentName;
  final Map<dynamic, dynamic> passedCompetences;
  final String passedClassID;
  final String passedClassName;

  AstaStats(
      {Key? key,
      required this.passedStudentName,
      required this.passedClassName,
      required this.passedCompetences,
      required this.passedClassID})
      : super(key: key);

  //this.passedClassName, this.passedStudentName);
  @override
  State<AstaStats> createState() => _AstaStatsState();
}

class _AstaStatsState extends State<AstaStats> {
  final List<BarChartModel> data = [
    BarChartModel(
      indicator: "a",
      grade: 1,
    ),
    BarChartModel(
      indicator: "b",
      grade: 2,
    ),
    BarChartModel(
      indicator: "c",
      grade: 3,
    ),
    BarChartModel(
      indicator: "d",
      grade: 4,
    ),
    BarChartModel(
      indicator: "e",
      grade: 5,
    ),
  ];
  late Stream<QuerySnapshot<Map<String, dynamic>>> _gradesStream =
      FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.passedClassID.toString())
          .collection("grading")
          .doc(widget.passedStudentName)
          .collection("grades")
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _gradesStream,
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
          //print(snapshot.data?.docs[0].data());
          var _indicators;
          for (var i = 0; i < snapshot.data!.docs.length.toInt(); i++) {
            Map<String, dynamic> foo =
                snapshot.data?.docs[i].data()! as Map<String, dynamic>;
            print(foo['Competences'].runtimeType);
            for (var _eachIndicator in foo['Competences'].entries) {
              print(_eachIndicator);
            }
          }
          List<charts.Series<BarChartModel, String>> series = [
            charts.Series(
              id: "grade",
              data: data,
              domainFn: (BarChartModel series, _) => series.indicator,
              measureFn: (BarChartModel series, _) => series.grade,
            ),
          ];
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.passedStudentName.toString()),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.assessment),
                backgroundColor: Color(0xFF29D09E),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AssessmentsCreateTeacherPage(
                                widget.passedClassID,
                                widget.passedClassName,
                                widget.passedCompetences,
                                widget.passedStudentName,
                              )));
                }),
            body: Padding(
              padding: EdgeInsets.all(0.00),
              child: ListView(children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 22,
                    ),
                    Text(
                      "Critical Thinking",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200.0,
                      child: charts.BarChart(
                        series,
                        animate: true,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "a - Actively participating in discussion",
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "b - Distinguishing fact from opinion, interpretations, evaluations, etc. in others' argumentation",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          "c -Reflecting on the consequences and effects that one's decisions have on others",
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "d - Foreseeing the practical implications of decisions and approaches",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          "e - Showing critical spirit",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Text(
                      "Creativity",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      child: charts.BarChart(
                        series,
                        animate: true,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "a - Acknowledging different manners of doing things; being non-conformist.",
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "b - Contributing suggestions for the ideas, situations, cases or problems posed",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          "c - Generating new ideas or solutions to situations or problem based on what is known.",
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "d - Proposing ideas that are innovative as far as contents, development, etc. are concerned",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          "e - Transmitting or conveying to others the new ideas generated.",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Text(
                      "Ethical Sense",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      child: charts.BarChart(
                        series,
                        animate: true,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "a - Conduct governed by basic knowledge of ethics.",
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "b - Critically accepting new perspectives, even though they cast doubt on one´s own.",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          "c - Observing and putting into practice rules established by the group to which one belongs.",
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "d - Seeking to affirm oneself through knowledge of the ethical world.",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          "e - Using own axiological reality as sign of personality and identity before others.",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
            ),
          );
          //   scrollDirection: Axis.vertical,
          //   children: <Widget>[
          //     const SizedBox(height: 16),
          //     ListTile(
          //       leading: Icon(Icons.person),
          //       title: Text("Formative Assessment"),
          //     ),
          //     const SizedBox(height: 16),
          //     // Divider(
          //   thickness: 1,
          //   height: 1,
          // ),
          // Container(
          //   child: BarChart(
          //     BarChartData(
          //         // read about it in the BarChartData section
          //         ),
          //     swapAnimationDuration: Duration(milliseconds: 150), // Optional
          //     swapAnimationCurve: Curves.linear, // Optional
          //   ),
          // ),

          //   const SizedBox(height: 16),
          //   ListTile(
          //     leading: Icon(Icons.person_add),
          //     title: Text("Sumative Assessment"),
          //     subtitle: Text("Average: X"),
          //   ),
          //   const SizedBox(height: 16),
          //   Divider(
          //     thickness: 1,
          //     height: 1,
          //   ),
          //   const SizedBox(height: 16),
          //   ListTile(
          //     leading: Icon(Icons.self_improvement),
          //     title: Text("Overall"),
          //     subtitle: Text("Average: Y"),
          //   ),
          // ],
          // ),
        });
  }
}
