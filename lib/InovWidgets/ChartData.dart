// Define data structure for a bar group
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

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
  String type;
  Timestamp timestampDate;

  PointLinex(
      {required this.index,
      required this.hash,
      required this.competence,
      required this.value,
      required this.type,
      required this.timestampDate});
}

Map<String, List<Color>> generateColorMap() {
  final Map<String, List<Color>> colorMap = {
    "Self": [],
    "Peer": [],
    "Formative": [],
  };

  for (int i = 0; i < 30; i++) {
    final redShade =
        Color.fromARGB(255, 255 - i * 40, 100 - i * 50, 100 - i * 40);
    final blueShade =
        Color.fromARGB(255, 100 - i * 8, 100 - i * 8, 255 - i * 50);
    final greenShade =
        Color.fromARGB(255, 100 - i * 40, 255 - i * 50, 100 - i * 40);

    colorMap["Self"]!.add(redShade);
    colorMap["Peer"]!.add(blueShade);
    colorMap["Formative"]!.add(greenShade);
  }

  return colorMap;
}

Color getColourFromComp(String competence) {
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
  return color;
}
