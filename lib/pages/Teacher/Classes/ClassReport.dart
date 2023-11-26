import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:assessments_app/InovWidgets/ChartData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

int genColourInt(String competence) {
  var hash = 0;
  for (var i = 0; i < competence.length; i++) {
    hash = competence.codeUnitAt(i) + ((hash << 5) - hash);
  }
  final finalHash = hash.abs() % (256 * 256 * 256);
  print(finalHash);
  final red = ((finalHash & 0xFF0000) >> 16);
  final blue = ((finalHash & 0xFF00) >> 8);
  final green = ((finalHash & 0xFF));
  final color = Color.fromRGBO(red, green, blue, 1);

  return color.value;
}

Future<Uint8List> generateClassReport(
    Map<String, List<DataItem>> _bigData,
    Map<String, List<PointLinex>> _smallData,
    List<String> info,
    BuildContext contextLanguage) async {
  // Summative table headers

  const baseColor = PdfColor.fromInt(1810353);

  // Create a PDF document.
  final document = pw.Document();

  final theme = pw.ThemeData.withFont(
    base: await PdfGoogleFonts.openSansRegular(),
    bold: await PdfGoogleFonts.openSansBold(),
  );
  double max = 0;

  Map<String, List<List<Object>>> dataBarChart = {};
  List<pw.Chart> charts = [];

  List<Timestamp> _times = [];

  // PRECISA DE MIN 2 INDICADORES !!!
  print("-----------------------------------------------");

  print("REPORT");

  for (var comp in _smallData.keys) {
    dataBarChart[comp] = [
      [" ", 0.0]
    ];
    for (var dt in _smallData[comp]!) {
      dataBarChart[comp]?.add([
        dt.index,
        dt.value,
        DateFormat('dd/MM/yyyy').format(dt.timestampDate.toDate()),
      ]);
      if (!_times.contains(dt.timestampDate)) {
        _times.add(dt.timestampDate);
      }
    }
  }
  for (var comp in _bigData.keys) {
    if (dataBarChart[comp]!.length > 2) {
      dataBarChart[comp]!.removeAt(0);
    } else {
      dataBarChart[comp]!.add(["", 0.0]);
    }
  }

  for (var x in dataBarChart.values) {
    for (var y in x) {
      print(y);
      if (double.parse(y[0].toString()) > max) {
        max = double.parse(y[0].toString());
      }
    }
  }
  print(dataBarChart);

  List<String> formattedDates = _times.map((timestamp) {
    return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
  }).toList();

  // Data table

  print("-----------------------------------------------");

  // Top bar chart
  final chart2 = pw.Chart(
    // title: pw.Text(AppLocalizations.of(contextLanguage)!.studentprog),
    overlay: pw.ChartLegend(),
    grid: pw.CartesianGrid(
      xAxis: pw.FixedAxis.fromStrings(
        List<String>.generate(
            (max + 1).toInt(), (index) => formattedDates[index]),
        marginStart: 0,
        marginEnd: 30,
        ticks: true,
      ),
      yAxis: pw.FixedAxis(
        [0, 1, 2, 3, 4, 5],
        divisions: true,
      ),
    ),
    datasets: [
      for (var x in _smallData.keys)
        pw.LineDataSet(
          lineWidth: 3,
          legend: x,
          drawSurface: false,
          isCurved: true,
          drawPoints: true,
          color: PdfColor.fromInt(genColourInt(x)),
          data: List<pw.PointChartValue>.generate(
            dataBarChart[x]!.length,
            (i) {
              final v = dataBarChart[x]![i][1] as num;
              final y = dataBarChart[x]![i][0] as num;
              return pw.PointChartValue(y.toDouble(), v.toDouble());
            },
          ),
        ),
    ],
  );
  // Add page to the PDF

  document.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      theme: theme,
      build: (context) {
        // Page layout
        return pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Container(
                        height: 150,
                        padding: const pw.EdgeInsets.only(left: 20),
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          'Assessments App Report',
                          style: pw.TextStyle(
                            color: baseColor,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          borderRadius:
                              const pw.BorderRadius.all(pw.Radius.circular(2)),
                        ),
                        alignment: pw.Alignment.centerLeft,
                        height: 50,
                        child: pw.DefaultTextStyle(
                          style: pw.TextStyle(
                            fontSize: 12,
                          ),
                          child: pw.GridView(
                            crossAxisCount: 2,
                            children: [
                              pw.Text('Date:'),
                              pw.Text(DateFormat.yMMMEd()
                                  .format(DateTime.now())
                                  .toString()),
                              pw.Text('Class:'),
                              pw.Text(info[0]),
                            ],
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Divider(),
                      pw.Expanded(flex: 0, child: chart2)
                    ],
                  ),
                ),
              ],
            ),
            if (context.pageNumber > 1) pw.SizedBox(height: 20)
          ],
        );
      },
    ),
  );
  print(charts.length);

  // On Flutter, use the [path_provider](https://pub.dev/packages/path_provider) library:
  // final output = await getTemporaryDirectory();

  // Return the PDF file content
  return document.save();
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
