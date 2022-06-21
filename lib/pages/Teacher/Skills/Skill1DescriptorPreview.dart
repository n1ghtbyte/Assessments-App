import 'package:flutter/material.dart';

class Skill1DescriptionPreview extends StatefulWidget {
  const Skill1DescriptionPreview({Key? key}) : super(key: key);

  @override
  _Skill1DescriptionPreview createState() => _Skill1DescriptionPreview();
}

class _Skill1DescriptionPreview extends State<Skill1DescriptionPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skills Preview'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: SafeArea(
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Value',
                style: TextStyle(fontStyle: FontStyle.normal),
              ),
            ),
            DataColumn(
              label: Text(
                'Description',
                style: TextStyle(fontStyle: FontStyle.normal),
              ),
            ),
          ],
          rows: const <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('1')),
                DataCell(Text(
                    'Text')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('2')),
                DataCell(Text(
                    'Text')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('3')),
                DataCell(Text(
                    'Text')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('4')),
                DataCell(Text(
                    'Text')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('5')),
                DataCell(Text(
                    'Text')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
