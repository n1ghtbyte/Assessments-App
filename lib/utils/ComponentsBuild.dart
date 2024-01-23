import 'package:flutter/material.dart';


// Headers for the different tabs in the app
Widget buildHeader(BuildContext context, String title) {
  return Container(
    padding: EdgeInsets.all(16.0),
    child: Text(
      title,
      style: TextStyle(fontSize: 16),
    ),
  );
}
