import 'package:flutter/material.dart';

class ClassStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics of the Class X'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: const <Widget>[
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Formative Assessment"),
          ),
          const SizedBox(height: 16),
          Divider(
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.grade),
            title: Text("Sumative Assessment"),
            subtitle: Text("Average: X"),
          ),
          const SizedBox(height: 16),
          Divider(
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.self_improvement),
            title: Text("Overall"),
            subtitle: Text("Average: Y"),
          ),
        ],
      ),
    );
  }
}
