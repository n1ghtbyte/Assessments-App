import 'package:flutter/material.dart';

class AssessmentsStudentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessments'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AssessmentsCreateStudent()),
          // );
        },
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: const <Widget>[
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Peer Assessment"),
            subtitle: Text("Deliver Date: XX/YY/ZZ"),
          ),
          const SizedBox(height: 16),
          Divider(
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Peer Assessment"),
            subtitle: Text("Deliver date: XX/YY/ZZ"),
          ),
          const SizedBox(height: 16),
          Divider(
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.self_improvement),
            title: Text("Self Assessment"),
            subtitle: Text("Deliver date: XX/YY/ZZ"),
          ),
          const SizedBox(height: 16),
          Divider(
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.school),
            title: Text("Teacher Assessment"),
            subtitle: Text("Deliver date: XX/YY/ZZ"),
          ),
          const SizedBox(height: 16),
          Divider(
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Peer Assessment"),
            subtitle: Text("Deliver date: XX/YY/ZZ"),
          ),
          const SizedBox(height: 16),
          Divider(
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.self_improvement),
            title: Text("Self Assessment"),
            subtitle: Text("Deliver date: XX/YY/ZZ"),
          ),
        ],
      ),
    );
  }
}
