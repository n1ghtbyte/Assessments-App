import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompetencePicked extends StatefulWidget {
  final String passedCompName;
  const CompetencePicked({Key? key, required this.passedCompName})
      : super(key: key);
  @override
  _CompetencePickedState createState() => _CompetencePickedState();
}

class _CompetencePickedState extends State<CompetencePicked> {
  final CollectionReference _leCompetence =
      FirebaseFirestore.instance.collection('Competences');

  List<String> textifier(List<dynamic>? x) {
    return x!.cast<String>();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _leCompetence.doc(widget.passedCompName).get(),
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

        print(data.keys);

        data.removeWhere((key, value) => key == "Name");

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.passedCompName),
            centerTitle: true,
            backgroundColor: Color(0xFF29D09E),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  for (var k in data.keys)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            k,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            height: 12,
                            thickness: 4,
                          ),
                          for (String x in (data[k]))
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    x,
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                ],
                              ),
                            ),
                          Divider(
                            height: 12,
                            thickness: 4,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
