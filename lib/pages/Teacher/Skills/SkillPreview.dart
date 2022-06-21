import 'package:assessments_app/pages/Teacher/Skills/Skill1DescriptorPreview.dart';
import 'package:flutter/material.dart';

class SkillPreview extends StatefulWidget {
  const SkillPreview({Key? key}) : super(key: key);

  @override
  _SkillPreview createState() => _SkillPreview();
}

class _SkillPreview extends State<SkillPreview> {
  @override
  Widget build(BuildContext context) {
    int count = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Skills Preview'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      floatingActionButton:
         FloatingActionButton.extended(
          backgroundColor: const Color(0xFF29D09E),
          onPressed: () {
            Navigator.popUntil(context, (route) {
            return count++ == 3;
            });
              
            // Respond to button press
          },
          icon: Icon(Icons.save),
          label: Text('Save'),
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
          rows:  <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text(
                    '1st Indicator'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Skill1DescriptionPreview()),
                      );
                          },
                    ), 
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text(
                    '2nd Indicator')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
