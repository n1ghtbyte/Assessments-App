import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GenSummAssessment extends StatefulWidget {
  final String passedClassName;
  const GenSummAssessment(this.passedClassName);

  @override
  _GenSummAssessmentState createState() => _GenSummAssessmentState();
}

class _GenSummAssessmentState extends State<GenSummAssessment> {
  late String _typeAssess;
  late List<String?> _competencesAssess = [];

  late CollectionReference assessments =
      FirebaseFirestore.instance.collection('/assessments');

  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  String? _iD;

  Widget build(BuildContext context) {
    late CollectionReference _class =
        FirebaseFirestore.instance.collection('classes');
    return FutureBuilder<DocumentSnapshot>(
        future: _class.doc(widget.passedClassName).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          var comp = data['Weights']; //Fetch the weights

          return Scaffold(
            appBar: AppBar(
              title: Text('Generate Summ. Assessment'),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16),

                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Summative Assessment Definition !",
                        style: TextStyle(fontSize: 22.0)),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: comp.keys.toList().length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(comp.keys.toList()[index]),
                        subtitle: Text(
                            comp[comp.keys.toList()[index]].toString() + " %"),
                      );
                    },
                  ),

                  //End Populator

                  const SizedBox(height: 16),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Color(0xFF29D09E),
                    ),
                    onPressed: () {},
                    child: Text(('Create'), style: new TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
