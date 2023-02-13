import 'package:flutter/material.dart';

class CompetencePicked extends StatefulWidget {
  final Map passedComp;
  final String name;
  const CompetencePicked(
      {Key? key, required this.passedComp, required this.name})
      : super(key: key);
  @override
  _CompetencePickedState createState() => _CompetencePickedState();
}

class _CompetencePickedState extends State<CompetencePicked> {
  List<String> textifier(List<dynamic>? x) {
    return x!.cast<String>();
  }

  Map noDamage = {};

  Widget build(BuildContext context) {
    List<bool> _customTileExpanded = List<bool>.filled(10, false);
    // noDamage.removeWhere((key, value) => key == "Name");
    for (var key in widget.passedComp.keys) {
      if (key != 'Name') {
        noDamage[key] = widget.passedComp[key];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
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
                itemCount: noDamage.keys.toList().length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    trailing: Icon(
                      _customTileExpanded[index]
                          ? Icons.arrow_drop_down_circle
                          : Icons.arrow_drop_down,
                    ),
                    title: Text(noDamage.keys.toList()[index]),
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, xipidi) {
                          return ListTile(
                            title: Text(noDamage[noDamage.keys.toList()[index]]
                                    [xipidi]
                                .substring(3)
                                .toString()),
                            leading: Text(
                                '${noDamage[noDamage.keys.toList()[index]][xipidi][0]}'),
                            dense: true,
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
