import 'package:assessments_app/pages/Teacher/Classes/TurmaExemplo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassSetup extends StatefulWidget {
  final String passedClassNameSetup;
  const ClassSetup({Key? key, required this.passedClassNameSetup})
      : super(key: key);

  @override
  _ClassSetupState createState() => _ClassSetupState();
}

class _ClassSetupState extends State<ClassSetup> {
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
              title: Text("Setup the weights"),
              centerTitle: true,
              actions: [
                // IconButton(icon: new Icon(Icons.more_vert), onPressed:  () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => ClassesSettingsPage()),
                //     );
                //   },
              ],
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
                print(map1);
                if (sum == 100) {
                  for (int i = 0; i < numComp; i++) {
                    map1[list[i].toString()] = int.parse(_controllers[i].text);
                  }
                  FirebaseFirestore.instance
                      .collection("/classes")
                      .doc(widget.passedClassNameSetup)
                      .set({"Weights": map1}, SetOptions(merge: true));
                  final snackBar =
                      SnackBar(content: Text('The values are stored!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TurmaExemplo(widget.passedClassNameSetup)));
                  print("success");
                } else {
                  final snackBar = SnackBar(
                      content: Text('The values must add up to 100!!'));
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
                    "Please attribute ths desired weight to your competences",
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
                        padding: EdgeInsets.all(16),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            labelText: list[index],
                            labelStyle: TextStyle(
                              color: Color(0xFF29D09E),
                            ),
                            hintText: '0% to 100%',
                            helperText: '${list[index]} weight ',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF29D09E)),
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          );
        });
  }
}
