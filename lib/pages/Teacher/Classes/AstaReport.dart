import 'dart:math';
import 'dart:typed_data';

import 'package:assessments_app/InovWidgets/ChartData.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<Uint8List> generateReport(
    Map<String, List<DataItem>> _bigData,
    Map<String, List<PointLinex>> _smallData,
    List<Map<dynamic, dynamic>> fsum,
    List<String> info) async {
  // Summative table headers

  const baseColor = PdfColors.green;

  // Create a PDF document.
  final document = pw.Document();

  final theme = pw.ThemeData.withFont(
    base: await PdfGoogleFonts.openSansRegular(),
    bold: await PdfGoogleFonts.openSansBold(),
  );

  Map<String, List<List<Object>>> dataBarChart = {};
  List<pw.Chart> charts = [];

  // PRECISA DE MIN 2 INDICADORES !!!
  print("-----------------------------------------------");

  print("REPORT");

  for (var comp in _bigData.keys) {
    dataBarChart[comp] = [
      [" ", 0.0]
    ];
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

  print(dataBarChart);

  // Data table

  final table = pw.TableHelper.fromTextArray(
    headers: ["Date", "Grade"],
    data: List<List<dynamic>>.generate(
      fsum.length,
      (index) => <dynamic>[
        fsum[index]['Created'].toDate().toString(),
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

  // Top bar chart
  for (var comp in dataBarChart.keys) {
    final chart1 = pw.Chart(
      left: pw.Container(
        alignment: pw.Alignment.topCenter,
        margin: const pw.EdgeInsets.only(right: 20, top: 10),
        child: pw.Transform.rotateBox(
          angle: pi / 2,
          child: pw.Text(comp),
        ),
      ),
      grid: pw.CartesianGrid(
        xAxis: pw.FixedAxis.fromStrings(
          List<String>.generate(dataBarChart[comp]!.length,
              (index) => wrapText(dataBarChart[comp]![index][0] as String, 15)),
          textStyle: pw.TextStyle(fontSize: 9),
          marginStart: 50,
          marginEnd: 20,
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
          color: PdfColors.green200,
          width: 10,
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
                      table
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
