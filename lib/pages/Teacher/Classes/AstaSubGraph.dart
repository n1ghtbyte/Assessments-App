import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:assessments_app/InovWidgets/LegendWidget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:assessments_app/InovWidgets/ChartData.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:assessments_app/utils/indicatorToHash.dart';

import 'AstaReport.dart';

class AstaSubGraph extends StatefulWidget {
  final double passedSummResult;
  final Timestamp passedSummDate;
  final String passedSummName;
  final String passedSummDesc;
  final String passedSummId;
  final String passedLegitName;
  final String passedClassName;
  final String passedClassId;
  final Map<dynamic, dynamic> passedCompetences;
  final List<dynamic> passedFromatives;
  final String passedEmail;
  final Map<dynamic, dynamic> passedfsum;

  const AstaSubGraph({
    Key? key,
    required this.passedSummResult,
    required this.passedSummDate,
    required this.passedSummName,
    required this.passedSummDesc,
    required this.passedSummId,
    required this.passedClassId,
    required this.passedClassName,
    required this.passedLegitName,
    required this.passedCompetences,
    required this.passedFromatives,
    required this.passedEmail,
    required this.passedfsum,
  }) : super(key: key);

  @override
  State<AstaSubGraph> createState() => _AstaSubGraphState();
}

class _AstaSubGraphState extends State<AstaSubGraph> {
  final colorMap = generateColorMap();

  late TextEditingController _editingController;
  late String _editedDescription; // Local variable for editing
  bool _isEditing = false;

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  Map<String, List<DataItem>> _bigData = {};
  Map<String, int> _leTitles =
      {}; // Also worth to Competences... not just indicators
  Map<String, int> _comp2cardinal = {};
  Map<String, List<PointLinex>> _smallData = {};

  var _max = 0;

  late CollectionReference summativeCollection = FirebaseFirestore.instance
      .collection(
          '/classes/${widget.passedClassId}/grading/${widget.passedEmail}/summative/');

  late Query<Map<String, dynamic>> _formativeCollection = FirebaseFirestore
      .instance
      .collection(
          '/classes/${widget.passedClassId}/grading/${widget.passedEmail}/formative')
      .where('AssessID', whereIn: widget.passedFromatives);

  var _ind = 0;

  // Relative to bar charts
  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 50,
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
  void initState() {
    super.initState();
    _editedDescription = widget.passedSummDesc;
    _editingController = TextEditingController(text: _editedDescription);
  }

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

        double fakeIndex = 0;
        Map<String, bool> tt = {};

        for (var ini in widget.passedCompetences.keys) {
          _bigData[ini] = [];
          _smallData[ini] = [];
          for (var bar in widget.passedCompetences[ini]) {
            tt[bar] = false;
          }
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

              if (_bigData[comp]!.isEmpty || !tt[indicator]!) {
                _bigData[comp]?.add(DataItem(
                    index: _ind,
                    hash: indicatorToHash(indicator, _leTitles),
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
              }
              _ind++;
              tt[indicator] = true;
            }

            var _res = helper.average;
            _smallData[comp]?.add(PointLinex(
                index: fakeIndex,
                hash: indicatorToHash(comp, _leTitles),
                competence: comp,
                value: _res,
                type: "Formative",
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
            title: Text('${widget.passedLegitName}'),
            centerTitle: true,
            backgroundColor: Color(0xFF29D09E),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfPreview(
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    canDebug: false,
                    initialPageFormat: PdfPageFormat.a4,
                    pdfFileName: "ASSESS.pdf",
                    build: (format) => generateReport(
                        _bigData,
                        _smallData,
                        [widget.passedfsum],
                        [widget.passedClassName, widget.passedLegitName]),
                  ),
                ),
              );
            },
            backgroundColor: const Color(0xFF29D09E),
            icon: Icon(Icons.print),
            label: Text("PDF"),
          ),
          body: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.assessname}: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.passedSummName,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.grade}: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.passedSummResult.toStringAsFixed(2),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 20, right: 20, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Display the description on the same line as the "pencil" icon
                        Text(
                          "${AppLocalizations.of(context)!.description}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _isEditing = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(28.0),
                    child: _isEditing
                        ? TextField(
                            controller: _editingController,
                            style: TextStyle(fontSize: 20),
                          )
                        : Text(
                            _editedDescription,
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                  Divider(),
                  if (_isEditing)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            String editedDescription = _editingController.text;

                            if (editedDescription != widget.passedSummDesc) {
                              // The edited value is different, send to Firebase or perform your desired action
                              // For demonstration purposes, printing the value to the console
                              print('Sending to Firebase: $editedDescription');
                              print(widget.passedSummId);

                              // Set the value of "Description" in Firestore
                              summativeCollection
                                  .doc(widget.passedSummId)
                                  .update({
                                'Description': editedDescription,
                              }).then((_) {
                                print('Description updated successfully!');
                              }).catchError((error) {
                                print('Error updating description: $error');
                              });
                            }
                            // Handle save logic here
                            setState(
                              () {
                                _editedDescription = _editingController.text;
                                _isEditing = false;
                              },
                            );
                          },
                          child: Text("Save"),
                        ),
                        SizedBox(width: 16),
                        TextButton(
                          onPressed: () {
                            setState(
                              () {
                                _editingController.text = _editedDescription;
                                _isEditing = false;
                              },
                            );
                          },
                          child: Text("Cancel"),
                        ),
                      ],
                    ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "${AppLocalizations.of(context)!.student}: ${widget.passedLegitName}\nDate: ${DateFormat('dd-MM-yyyy').format((widget.passedSummDate).toDate())}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Divider(
                height: 2,
              ),
              SizedBox(
                height: 14,
              ),
              Column(
                children: [
                  for (var _comp in _bigData.keys)
                    _bigData[_comp]!.isNotEmpty
                        ? Column(
                            children: [
                              Text(
                                _comp.toString(),
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 10),
                              LegendsListWidget(
                                legends: [
                                  for (var i = 0;
                                      i < _comp2cardinal[_comp]!;
                                      i++)
                                    Legend(
                                        "${DateFormat('dd-MM-yyyy').format(_smallData[_comp]![i].timestampDate.toDate())}",
                                        colorMap[_smallData[_comp]![i].type]![
                                            i]),
                                ],
                              ),
                              const SizedBox(height: 14),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 20),
                                  height: 300,
                                  width: 100 +
                                      (_bigData[_comp]!.length * 200) +
                                      _smallData[_comp]!.length * 15,
                                  child: BarChart(
                                    BarChartData(
                                      baselineY: 0,
                                      titlesData: FlTitlesData(
                                        bottomTitles: AxisTitles(
                                            sideTitles: _bottomTitles),
                                        leftTitles: AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: true)),
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
                                                      borderRadius:
                                                          BorderRadius.zero,
                                                      backDrawRodData:
                                                          BackgroundBarChartRodData(
                                                        show: true,
                                                        toY: 0.1,
                                                        color: colorMap[
                                                            _smallData[_comp]![
                                                                    ind]
                                                                .type]![ind],
                                                      ),
                                                      toY: double.parse(
                                                          dataItem.y[ind]),
                                                      width: 15,
                                                      color: colorMap[
                                                          _smallData[_comp]![
                                                                  ind]
                                                              .type]![ind]),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    swapAnimationDuration:
                                        Duration(milliseconds: 150), // Optional
                                    swapAnimationCurve:
                                        Curves.linear, // Optional
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Text("")
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
