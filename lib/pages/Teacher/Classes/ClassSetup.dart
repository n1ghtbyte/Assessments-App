import 'package:assessments_app/pages/Teacher/Classes/TurmaExemplo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClassSetup extends StatefulWidget {
  final String passedClassNameSetup;
  const ClassSetup({Key? key, required this.passedClassNameSetup})
      : super(key: key);

  @override
  _ClassSetupState createState() => _ClassSetupState();
}

class _ClassSetupState extends State<ClassSetup> {
  String total = "0";

  List<TextEditingController> _controllers =
      List.generate(11, (i) => new TextEditingController());

  late CollectionReference _class =
      FirebaseFirestore.instance.collection('/classes');

  @override
  void dispose() {
    _controllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: _class.doc(widget.passedClassNameSetup).get(),
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
          print("lolo");
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          var comp = data['Competences'];
          List<String?> list = [];
          comp.entries.forEach((e) => list.add(e.key));
          var numComp = list.length;

          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.setupweights),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () {
                Map<String?, int> map1 = {};
                int sum = 0;
                for (int i = 0; i < numComp; i++) {
                  sum += int.parse(_controllers[i].text);
                }
                if (sum == 100) {
                  for (int i = 0; i < numComp; i++) {
                    map1[list[i].toString()] = int.parse(_controllers[i].text);
                  }
                  FirebaseFirestore.instance
                      .collection("/classes")
                      .doc(widget.passedClassNameSetup)
                      .set({"Weights": map1}, SetOptions(merge: true));
                  final snackBar = SnackBar(
                      content: Text(AppLocalizations.of(context)!.valsstored));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TurmaExemplo(widget.passedClassNameSetup)));
                  print("success");
                } else {
                  final snackBar = SnackBar(
                      content: Text(AppLocalizations.of(context)!.summhundred));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              backgroundColor: Color(0xFF29D09E),
            ),
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    AppLocalizations.of(context)!.attrweigh,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: numComp,
                    itemBuilder: (BuildContext context, int index) {
                      _controllers.add(new TextEditingController());
                      return Container(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        child: TextFormField(
                          onChanged: (value) {
                            total = "0";
                            total = _calculTotal(_controllers);
                            setState(() {});
                          },
                          keyboardType: TextInputType.number,
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            labelText: list[index],
                            labelStyle: TextStyle(
                              color: Color(0xFF29D09E),
                            ),
                            counterText: "%",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF29D09E)),
                            ),
                          ),
                        ),
                      );
                    }),
                Wrap(
                  alignment: WrapAlignment.spaceAround, // set your alignment
                  children: <Widget>[
                    Text("Total: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(
                      total,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: double.tryParse(total)! != 100
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}

String _calculTotal(var x) {
  double total = 0;
  for (var j = 0; j < x.length; j++) {
    total += double.tryParse(x[j].text) ?? 0;
  }
  return total.toString();
}
