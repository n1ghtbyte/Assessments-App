import 'dart:convert';
import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:assessments_app/InovWidgets/LegendWidget.dart';
import 'package:intl/intl.dart';

class AstaSubGraph extends StatefulWidget {
  final String passedLegitName;
  final String passedClassName;
  final String passedClassId;
  final Map<dynamic, dynamic> passedCompetences;
  final List<dynamic> passedFromatives;
  final String passedEmail;

  const AstaSubGraph(
      {Key? key,
      required this.passedClassId,
      required this.passedClassName,
      required this.passedLegitName,
      required this.passedCompetences,
      required this.passedFromatives,
      required this.passedEmail})
      : super(key: key);

  @override
  State<AstaSubGraph> createState() => _AstaSubGraphState();
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

class _AstaSubGraphState extends State<AstaSubGraph> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  Map<String, List<DataItem>> _bigData = {};
  Map<String, int> _leTitles =
      {}; // Also worth to Competences... not just indicators
  Map<String, int> _comp2cardinal = {};
  Map<String, List<PointLinex>> _smallData = {};

  var _max = 0;

  late Query<Map<String, dynamic>> _formativeCollection = FirebaseFirestore
      .instance
      .collection(
          '/classes/${widget.passedClassId}/grading/${widget.passedEmail}/formative')
      .where('AssessID', whereIn: widget.passedFromatives);

  var _ind = 0;

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
        reservedSize: 50,
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

  @override
  Widget build(BuildContext context) {
    print(widget.passedCompetences);
    print(widget.passedClassId);
    print(widget.passedEmail);
    print(widget.passedLegitName);
    return StreamBuilder<QuerySnapshot>(
      stream: _formativeCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        print(widget.passedCompetences);

        var flagCurr0 = true;
        double fakeIndex = 0;
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

              print((foo['Created'] as Timestamp).toDate());

              if (flagCurr0) {
                _bigData[comp]?.add(DataItem(
                    index: _ind,
                    hash: indicatorToHash(indicator),
                    x: indicator,
                    y: [foo['Competences'][comp][indicator]]));
              } else {
                for (var i = 0; i < _bigData[comp]!.length; i++) {
                  if (_bigData[comp]![i].x == indicator) {
                    var tempora = _bigData[comp]![i].y;
                    print(tempora);
                    tempora.add(foo['Competences'][comp][indicator]);
                    _bigData[comp]![i].y = tempora;
                  }
                }
                flagCurr0 = false;
              }
              _ind++;
            }

            var _res = helper.average;
            _smallData[comp]?.add(PointLinex(
                index: fakeIndex,
                hash: indicatorToHash(comp),
                competence: comp,
                value: _res,
                timestampDate: foo['Created']));

            _ind = 0;
            helper = [];
          }
          fakeIndex++;
        }

        inspect(_smallData);
        inspect(_bigData);
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
        inspect(_comp2cardinal);

        //Fetch summative data

        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.passedLegitName} data'),
            centerTitle: true,
            backgroundColor: Color(0xFF29D09E),
          ),
          body: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Formative Assessments",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
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
                              Legend(
                                  "${DateFormat.MEd().format(_smallData[_comp]![i].timestampDate.toDate())}",
                                  _leColours[i]),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 55, bottom: 20),
                            height: 300,
                            width: (_bigData[_comp]!.length * 200) +
                                _smallData[_comp]!.length * 15,
                            child: BarChart(
                              BarChartData(
                                baselineY: 0,
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
                                                borderRadius: BorderRadius.zero,
                                                backDrawRodData:
                                                    BackgroundBarChartRodData(
                                                  show: true,
                                                  toY: 0.1,
                                                  color: _leColours[ind],
                                                ),
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
                      ],
                    ),
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
