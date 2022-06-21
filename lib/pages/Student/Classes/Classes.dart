import 'package:assessments_app/pages/Student/Classes/StudentAddClass.dart';
import 'package:flutter/material.dart';

class StudentClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Classes'),
          centerTitle: true,
          backgroundColor: Color(0xFF29D09E),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentAddClass()),
            );
          },
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text("Class ESSS_5A"),
              subtitle: Text("Pupil: 18/20\nHash:2ert435^8)="),
              isThreeLine: true,
              trailing: Icon(Icons.arrow_right_alt),
              onTap: () {
                // Navigator.push(
                // context,
                // MaterialPageRoute(
                //     builder: (context) => TurmaExemplo()),
                // );
              },
              onLongPress: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => ClassStats()),
                // );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Divider(
              thickness: 1,
              height: 1,
            ),
            const SizedBox(
              height: 16,
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text("Class XYZ_*Q"),
              subtitle: Text("Pupil: 16/17\nHash:werthj54#&"),
              isThreeLine: true,
              trailing: Icon(Icons.arrow_right_alt),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => ClassesSettingsPage()),
                // );
              },

              // trailing: IconButton(
              //   icon: const Icon(Icons.arrow_right_alt),
              //   tooltip: 'Class properties',
              //   onPressed: () {
              //     Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => ClassesPage()),
              //   );
              //   },
              // ),
            ),
            const SizedBox(height: 16),
            Divider(
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.group),
              title: Text("Class XYZ_*Q"),
              subtitle: Text("Pupil: 16/18\nHash:rt5\$3FDd"),
              isThreeLine: true,
              enabled: false,
              trailing: Icon(Icons.arrow_right_alt),
            ),
          ],
        ));
  }
}
