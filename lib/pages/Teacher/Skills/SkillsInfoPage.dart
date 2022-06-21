import 'package:assessments_app/pages/Teacher/Skills/Skill1_1Descriptor.dart';
import 'package:flutter/material.dart';

class SkillsInfoPage extends StatefulWidget {
  const SkillsInfoPage({Key? key}) : super(key: key);

  @override
  _SkillsInfoPageState createState() => _SkillsInfoPageState();
}

class _SkillsInfoPageState extends State<SkillsInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Competences Documentation'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: SafeArea(
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Indicators',
                style: TextStyle(fontStyle: FontStyle.normal),
                // style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(
                  Text('Showing critical spirit'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Skill1_1Descriptor()),
                    );
                  },
                ),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text(
                    'Distinguishing fact from opinion, interpretations, evaluations, etc. ')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Actively participating in discussion')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text(
                    'Foreseeing the pratical implications of decisions and approaches')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text(
                    'Reflecting on the consequences and effects that one\'s decisions have on others')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
