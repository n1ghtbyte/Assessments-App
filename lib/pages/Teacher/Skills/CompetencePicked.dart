import 'package:assessments_app/pages/Teacher/Skills/IndicatorPicked.dart';
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
        List<bool> _customTileExpanded = List<bool>.filled(10, false);

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
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.keys.toList().length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        trailing: Icon(
                          _customTileExpanded[index]
                              ? Icons.arrow_drop_down_circle
                              : Icons.arrow_drop_down,
                        ),
                        title: Text(data.keys.toList()[index]),
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 5,
                            itemBuilder: (context, xipidi) {
                              return ListTile(
                                title: Text(data[data.keys.toList()[index]]
                                        [xipidi]
                                    .substring(3)
                                    .toString()),
                                leading: Text(
                                    '${data[data.keys.toList()[index]][xipidi][0]}'),
                                dense: true,
                                visualDensity:
                                    VisualDensity.adaptivePlatformDensity,
                              );
                            },
                          ),
                        ],

                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => IndicatorPicked(
                        //         passedList: data[data.keys.toList()[index]],
                        //       ),
                        //     ),
                        //   );
                        // },
                      );
                    },
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
