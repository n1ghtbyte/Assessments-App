import 'package:flutter/material.dart';

class Skill1_1Descriptor extends StatefulWidget {
  const Skill1_1Descriptor({Key? key}) : super(key: key);

  @override
  _Skill1_1DescriptorState createState() => _Skill1_1DescriptorState();
}

class _Skill1_1DescriptorState extends State<Skill1_1Descriptor> {
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
          dataRowHeight: 56.0,
          headingRowHeight: 56.0,
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
                    "Never process suggestions or doesn´t do so independently.")),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('2')),
                DataCell(Text(
                    'Contributes suggestions when required to do so, or suggestions are limited.')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('3')),
                DataCell(Text(
                    'Contributes own suggestions regarding problems or situations.')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('4')),
                DataCell(Text(
                    'Generates a range of ideas and/or solutions to issues raised.')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('5')),
                DataCell(Text(
                    'Generates a large quantity of alternative ideas, spontaneously and/or before required to do so. ')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
