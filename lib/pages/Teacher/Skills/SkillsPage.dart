import 'package:assessments_app/pages/Teacher/Skills/CompetencePicked.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SkillsPage extends StatelessWidget {
  final CollectionReference _competences =
      FirebaseFirestore.instance.collection('Competences');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: _competences.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          print(snapshot.data);

          return Scaffold(
            appBar: AppBar(
              title: Text('Competences'),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            body: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  onTap: () {
                    print(data['Name']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompetencePicked(
                              passedCompName: data['Name'].toString())),
                    );
                  },
                  trailing: Icon(Icons.arrow_circle_right_rounded),
                  title: Text(data['Name']),
                );
              }).toList(),
            ),
          );
        });
  }
}
