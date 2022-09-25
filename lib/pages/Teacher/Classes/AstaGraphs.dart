// check this out https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md

import 'dart:convert';
import 'package:assessments_app/pages/Teacher/Classes/TurmaExemplo.dart';
import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:assessments_app/InovWidgets/LegendWidget.dart';

class AstaGraphs extends StatefulWidget {
  final String passedLegitName;
  final String passedClassId;
  final Map<dynamic, dynamic> passedCompetences;
  final String passedEmail;

  const AstaGraphs(
      {Key? key,
      required this.passedClassId,
      required this.passedLegitName,
      required this.passedCompetences,
      required this.passedEmail})
      : super(key: key);

  @override
  State<AstaGraphs> createState() => _AstaGraphsState();
}

// Define data structure for a bar group
class DataItem {
  int index;
  int hash;
  String x; //indicator
  List<dynamic> y; //

  DataItem(
      {required this.index,
      required this.hash,
      required this.x,
      required this.y});
}

// Define data structure for a line chart point
class PointLinex {
  double index;
  String competence;
  int hash;
  double value;
  Timestamp timestampDate;

  PointLinex(
      {required this.index,
      required this.hash,
      required this.competence,
      required this.value,
      required this.timestampDate});
}

class _AstaGraphsState extends State<AstaGraphs> {
  Map<String, List<DataItem>> _bigData = {};
  Map<String, int> _leTitles =
      {}; // Also worth to Competences... not just indicators
  Map<String, int> _comp2cardinal = {};
  Map<String, List<PointLinex>> _smallData = {};

  var _max = 0;

  late CollectionReference _formativeCollection = FirebaseFirestore.instance
      .collection(
          '/classes/${widget.passedClassId}/grading/${widget.passedEmail}/formative');
  var _ind = 0;

  // Color(0xffa5d6a7),
  // Color(0xff81c784),
  // Color(0xff66bb6a),
  // Color(0xff4caf50),
  // Color(0xff43a047),
  // Color(0xff388e3c),
  // Color(0xff2e7d32),
  // Color(0xff1b5e20),
  // Color(0xff33691e),

  static List _leColours = [
    Color(0xff7a3279),
    Color(0xff58c770),
    Color(0xffc24fa8),
    Color(0xffadbc3c),
    Color(0xff483588),
    Color(0xff80aa3d),
    Color(0xff9c69cc),
    Color(0xff48862e),
    Color(0xff5c7cde),
    Color(0xffcb9f2e),
    Color(0xff6789cf),
    Color(0xffc88130),
    Color(0xff33d4d1),
    Color(0xffcf483f),
    Color(0xff4ac08f),
    Color(0xffcb417f),
    Color(0xff86c275),
    Color(0xff872957),
    Color(0xff347435),
    Color(0xffd088d2),
    Color(0xffc6ba61),
    Color(0xffdb75a2),
    Color(0xff7c7527),
    Color(0xffd24660),
    Color(0xffcc8b52),
    Color(0xff8d2836),
    Color(0xffc15c2d),
    Color(0xffca5e71),
    Color(0xff86341a),
    Color(0xffdc7a67),
  ];

  int indicatorToHash(String indicator) {
    int _sum = 0;

    var foo = ascii.encode(indicator);
    for (var k in foo) {
      _sum += k;
    }
    _leTitles[indicator] = _sum;
    return _sum;
  }

  // Relative to bar charts
  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 20,
        // getTextStyles: (context, value) => const TextStyle(
        //   color: Color(0xff939393),
        //   fontSize: 10,
        // ),
        getTitlesWidget: (value, meta) {
          var key = _leTitles.keys.firstWhere((k) => _leTitles[k] == value,
              orElse: () => "ERROR CONTACT O3");
          return Tooltip(
            message: key,
            height: 50,
            child: Text(
              wrapText(key, 20),
              style: TextStyle(fontSize: 8, overflow: TextOverflow.fade),
            ),
          );
        },
      );

  // Relative to Line charts
  SideTitles get _bottomTitlesTimestamps => SideTitles(
        showTitles: true,
        // getTextStyles: (context, value) => const TextStyle(
        //   color: Color(0xff939393),
        //   fontSize: 10,
        // ),
        getTitlesWidget: (value, meta) {
          var ret = "";
          if (value % 1 != 0) {
            return Text(ret);
          }
          if (value == 0) {
            ret = "1st Assess";
            return Text(ret);
          } else if (value == 1) {
            ret = "2nd Assess";
            return Text(ret);
          } else if (value == 2) {
            ret = "3rd Assess";
            return Text(ret);
          } else {
            var k = value + 1;
            ret = k.toString() + "th Assess";
            return Text(ret);
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    print(widget.passedCompetences);
    print(widget.passedClassId);
    print(widget.passedEmail);
    print(widget.passedLegitName);
    return FutureBuilder<QuerySnapshot>(
      future: _formativeCollection.orderBy('Current', descending: false).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

        print(widget.passedCompetences);

        for (var ini in widget.passedCompetences.keys) {
          _bigData[ini] = [];
          _smallData[ini] = [];
        }
        for (var _doc in snapshot.data!.docs) {
          var foo = _doc.data()! as Map<dynamic, dynamic>;
          print("HAKI");
          List<double> helper = [];
          for (var comp in foo['Competences'].keys) {
            getColourFromComp(comp);
            // for each competence in a given assessment
            for (var indicator in foo['Competences'][comp].keys) {
              print(foo['Competences'][comp][indicator]);

              helper.add(double.parse(foo['Competences'][comp][indicator]));
              // for each indicator in that compentence
              // print('ola');
              // print(foo['Current']);
              // print(_ind);
              // print(foo['Competences'][comp][indicator]);
              if (int.parse(foo['Current']) == 0) {
                _bigData[comp]?.add(DataItem(
                    index: _ind,
                    hash: indicatorToHash(indicator),
                    x: indicator,
                    y: [foo['Competences'][comp][indicator]]));
              } else {
                // print(_ind);
                // print("next");
                for (var i = 0; i < _bigData[comp]!.length; i++) {
                  if (_bigData[comp]![i].x == indicator) {
                    var tempora = _bigData[comp]![i].y;
                    tempora.add(foo['Competences'][comp][indicator]);
                    _bigData[comp]![i].y = tempora;
                  }
                }
              }
              _ind++;
            }

            var _res = helper.average;
            _smallData[comp]?.add(PointLinex(
                index: double.parse(foo['Current']),
                hash: indicatorToHash(comp),
                competence: comp,
                value: _res,
                timestampDate: foo['Created']));

            _ind = 0;
            helper = [];
          }
        }
        // inspect(_smallData);
        // inspect(_bigData);
        var thevalue = 0;

        _smallData.forEach((k, v) {
          if (v.length > thevalue) {
            thevalue = v.length;
          }
        });

        for (var comp in widget.passedCompetences.keys) {
          for (var i = 0; i < _bigData[comp]!.length; i++) {
            if (_bigData[comp]![i].y.length > _max) {
              _max = _bigData[comp]![i].y.length;
            }
          }
          _comp2cardinal[comp] = _max;
          _max = 0;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.passedLegitName} data'),
            centerTitle: true,
            backgroundColor: Color(0xFF29D09E),
          ),
          body: ListView(
            children: [
              SizedBox(
                height: 24,
              ),
              Column(
                children: [
                  for (var _comp in _bigData.keys)
                    Column(
                      children: [
                        Text(
                          _comp.toString(),
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 8),
                        LegendsListWidget(
                          legends: [
                            for (var i = 0; i < _comp2cardinal[_comp]!; i++)
                              Legend("${i + 1}# Assessment", _leColours[i]),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: EdgeInsets.all(40),
                            height: 300,
                            width: (_bigData[_comp]!.length * 200) +
                                _smallData[_comp]!.length * 15,
                            child: BarChart(
                              BarChartData(
                                titlesData: FlTitlesData(
                                  bottomTitles:
                                      AxisTitles(sideTitles: _bottomTitles),
                                  leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: true)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                                gridData: FlGridData(
                                    drawHorizontalLine: true,
                                    drawVerticalLine: false),
                                maxY: 5,
                                minY: 0,
                                groupsSpace: 10,
                                barGroups: _bigData[_comp]
                                    ?.map(
                                      (dataItem) => BarChartGroupData(
                                        x: dataItem.hash,
                                        barRods: [
                                          for (var ind = 0;
                                              ind < dataItem.y.length;
                                              ind++)
                                            BarChartRodData(
                                                toY: double.parse(
                                                    dataItem.y[ind]),
                                                width: 15,
                                                color: _leColours[ind]),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                              swapAnimationDuration:
                                  Duration(milliseconds: 150), // Optional
                              swapAnimationCurve: Curves.linear, // Optional
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Divider(
                          thickness: 2,
                          height: 4,
                        ),
                        SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  Column(
                    children: [
                      Text(
                        "Competences Line Chart",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      LegendsListWidget(
                        legends: [
                          for (var i in _smallData.keys)
                            Legend(i, getColourFromComp(i)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                            padding: EdgeInsets.all(20),
                            height: 300,
                            width: 200 + thevalue * 100,
                            child: LineChart(
                              LineChartData(
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                      sideTitles: _bottomTitlesTimestamps),
                                  leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: true)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                                minY: 0,
                                maxY: 5,
                                gridData: FlGridData(
                                    show: true,
                                    drawHorizontalLine: true,
                                    drawVerticalLine: false),
                                borderData: FlBorderData(show: true),
                                lineBarsData: [
                                  for (var _comp in _smallData.keys)
                                    LineChartBarData(
                                      spots: _smallData[_comp]
                                          ?.map((point) =>
                                              FlSpot(point.index, point.value))
                                          .toList(),
                                      isCurved: false,
                                      barWidth: 2,
                                      color: getColourFromComp(_comp),
                                    ),
                                ],
                              ),
                              swapAnimationDuration:
                                  Duration(milliseconds: 150), // Optional
                              swapAnimationCurve: Curves.linear, // Optional
                            )),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  Container(
                      width: double.infinity,
                      child: RawMaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text("Remove Student"),
                                    content: Text(
                                        'Are you sure you wish to remove this student from this class and delete all their assesments?'),
                                    actions: [
                                      TextButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.blue),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        child: Text('CANCEL'),
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.blue),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          FirebaseFirestore.instance
                                              .collection('/classes')
                                              .doc(widget.passedClassId)
                                              .get()
                                              .then((DocumentSnapshot
                                                  documentSnapshot) {
                                            if (documentSnapshot.exists) {
                                              var num = documentSnapshot[
                                                      'NumStudents'] -
                                                  1;
                                              List<dynamic> tmp =
                                                  documentSnapshot[
                                                      'StudentList'];
                                              tmp.remove(widget.passedEmail);
                                              FirebaseFirestore.instance
                                                  .collection('classes')
                                                  .doc(widget.passedClassId)
                                                  .update({'StudentList': tmp});
                                              FirebaseFirestore.instance
                                                  .collection('classes')
                                                  .doc(widget.passedClassId)
                                                  .update({'NumStudents': num});
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TurmaExemplo(widget
                                                                  .passedClassId
                                                                  .toString())));
                                            }
                                          });
                                        },
                                        child: Text(
                                          'DELETE',
                                        ),
                                      ),
                                    ],
                                  ));
                        },
                        child: Text(
                          "Remove Student",
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        ),
                      )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

String wrapText(String inputText, int wrapLength) {
  List<String> separatedWords = inputText.split(' ');
  StringBuffer intermidiateText = StringBuffer();
  StringBuffer outputText = StringBuffer();

  for (String word in separatedWords) {
    if ((intermidiateText.length + word.length) >= wrapLength) {
      intermidiateText.write('\n');
      outputText.write(intermidiateText);
      intermidiateText.clear();
      intermidiateText.write('$word ');
    } else {
      intermidiateText.write('$word ');
    }
  }

  outputText.write(intermidiateText); //Write any remaining word at the end
  intermidiateText.clear();
  return outputText.toString().trim();
}

Color getColourFromComp(String competence) {
  final Map<String, Color> _compColour = {
    "Writing Skills": Color.fromARGB(255, 167, 193, 53),
    "Project Management": Color.fromARGB(255, 0, 157, 189),
    "Problem Solving": Color.fromARGB(255, 131, 46, 164),
    "Oral Communication": Color.fromARGB(255, 166, 229, 42),
    "Learning Orientation": Color.fromARGB(255, 42, 76, 229),
    "Interpersonal Communication": Color.fromARGB(255, 198, 152, 192),
    "Ethical Sense": Color.fromARGB(255, 154, 119, 119),
    "Diversity and Interculturality": Color.fromARGB(255, 98, 97, 135),
    "Critical Thinking": Color.fromARGB(255, 229, 145, 42),
    "Creativity": Color.fromARGB(255, 229, 42, 42),
    "Collaboration - Teamwork": Color.fromARGB(255, 24, 126, 142),
  };
  var colour = _compColour[competence];
  if (colour != null) {
    return colour;
  }

  return Colors.black;
}
