import 'dart:typed_data';
import 'dart:ui';

import 'package:assessments_app/InovWidgets/ChartData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

Future<Uint8List> generateReport(
    Map<String, List<DataItem>> _bigData,
    Map<String, List<PointLinex>> _smallData,
    List<Map<dynamic, dynamic>> fsum,
    List<String> info) async {
  // Summative table headers

  const baseColor = PdfColor.fromInt(1810353);

  // Create a PDF document.
  final document = pw.Document();

  final theme = pw.ThemeData.withFont(
    base: await PdfGoogleFonts.openSansRegular(),
    bold: await PdfGoogleFonts.openSansBold(),
  );

  Map<String, List<List<Object>>> dataBarChart = {};
  Map<String, List<List<Object>>> dataLinesChart = {};

  List<pw.Chart> charts = [];

  List<Timestamp> _times = [];

  // PRECISA DE MIN 2 INDICADORES !!!
  print("-----------------------------------------------");

  print("REPORT");

  for (var comp in _bigData.keys) {
    dataBarChart[comp] = [
      [" ", 0.0]
    ];
    dataLinesChart[comp] = [
      [" ", 0.0]
    ];
    for (var dt in _smallData[comp]!) {
      dataLinesChart[comp]?.add([
        dt.index,
        dt.value,
        DateFormat('dd-MM-yyyy').format(dt.timestampDate.toDate()),
      ]);
      if (!_times.contains(dt.timestampDate)) {
        _times.add(dt.timestampDate);
      }
    }

    for (var dt in _bigData[comp]!) {
      var listInts = [];

      for (var elem in dt.y) {
        listInts.add(int.parse(elem));
      }

      var avg = listInts.reduce((value, element) => value + element) /
          listInts.length;
      dataBarChart[comp]?.add([dt.x, avg]);
    }
  }

  for (var comp in _bigData.keys) {
    if (dataBarChart[comp]!.length > 2) {
      dataBarChart[comp]!.removeAt(0);
    } else {
      dataBarChart[comp]!.add(["", 0.0]);
    }
  }
  for (var comp in _bigData.keys) {
    if (dataLinesChart[comp]!.length > 2) {
      dataLinesChart[comp]!.removeAt(0);
    } else {
      dataLinesChart[comp]!.add(["", 0.0]);
    }
  }

  List<String> formattedDates = _times.map((timestamp) {
    return DateFormat('dd-MM-yyyy').format(timestamp.toDate());
  }).toList();

  print(dataBarChart);

  // Data table

  final table = pw.TableHelper.fromTextArray(
    headers: ["Date", "Description", "Grade"],
    data: List<List<dynamic>>.generate(
      fsum.length,
      (index) => <dynamic>[
        DateFormat('dd-MM-yyyy')
            .format(fsum[index]['Created'].toDate())
            .toString(),
        fsum[index]['Description'].toString(),
        fsum[index]['Result'].toStringAsFixed(2),
      ],
    ),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontWeight: pw.FontWeight.bold,
    ),
    headerDecoration: const pw.BoxDecoration(
      color: baseColor,
    ),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: baseColor,
          width: .5,
        ),
      ),
    ),
    cellAlignment: pw.Alignment.centerRight,
    cellAlignments: {0: pw.Alignment.centerLeft},
  );
  print("-----------------------------------------------");

  final chart2 = pw.Chart(
    // title: pw.Text(AppLocalizations.of(contextLanguage)!.studentprog),
    overlay: pw.ChartLegend(),
    grid: pw.CartesianGrid(
      xAxis: pw.FixedAxis.fromStrings(
        List<String>.generate(
            (formattedDates.length).toInt(), (index) => formattedDates[index]),
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
            dataLinesChart[x]!.length,
            (i) {
              final v = dataLinesChart[x]![i][1] as num;
              final y = dataLinesChart[x]![i][0] as num;
              return pw.PointChartValue(y.toDouble(), v.toDouble());
            },
          ),
        ),
    ],
  );

  // Top bar chart
  for (var comp in dataBarChart.keys) {
    final chart1 = pw.Chart(
      title: pw.Container(
        alignment: pw.Alignment.topCenter,
        margin: const pw.EdgeInsets.all(10),
        child: pw.Text(
          comp,
          style: pw.TextStyle(fontSize: 20),
        ),
      ),
      grid: pw.CartesianGrid(
        xAxis: pw.FixedAxis.fromStrings(
          List<String>.generate(dataBarChart[comp]!.length,
              (index) => wrapText(dataBarChart[comp]![index][0] as String, 15)),
          textStyle: pw.TextStyle(fontSize: 10),
          marginStart: 45,
          marginEnd: 45,
          ticks: true,
        ),
        yAxis: pw.FixedAxis(
          [
            0,
            1,
            2,
            3,
            4,
            5,
          ],
          format: (v) => '$v',
          divisions: true,
        ),
      ),
      datasets: [
        pw.BarDataSet(
          color: baseColor,
          width: 30,
          offset: 0,
          borderColor: baseColor,
          data: List<pw.PointChartValue>.generate(
            dataBarChart[comp]!.length,
            (i) {
              final v = dataBarChart[comp]![i][1] as double;
              return pw.PointChartValue(i.toDouble(), v.toDouble());
            },
          ),
        ),
      ],
    );
    charts.add(chart1);
  }

  // Add page to the PDF

  document.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      theme: theme,
      build: (context) {
        // Page layout
        return pw.Column(
          children: [
            pw.Expanded(
              flex: 0,
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
                          // date format is dd/mm/yyyy
                          pw.Text(DateFormat('dd-MM-yyyy')
                              .format(DateTime.now())
                              .toString()),
                          pw.Text('Class:'),
                          pw.Text(info[0]),
                          pw.Text('Student:'),
                          pw.Text(info[1]),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(),
                  pw.Text(
                    "Summative assessments",
                    style: pw.TextStyle(
                      color: baseColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  table,
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Divider(height: 5),
            pw.SizedBox(height: 40),
            pw.Expanded(flex: 1, child: chart2),
            if (context.pageNumber > 1) pw.SizedBox(height: 20)
          ],
        );
      },
    ),
  );
  print(charts.length);

  for (var x = 0; x < charts.length; x++) {
    document.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          theme: theme,
          build: (context) {
            // Page layout
            return pw.Column(
              children: [
                pw.Text(
                  "Formative assessments",
                  style: pw.TextStyle(
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Expanded(child: charts[x]),
                pw.SizedBox(height: 200),
              ],
            );
          }),
    );
  }

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
