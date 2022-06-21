import 'package:flutter/material.dart';

class Skills2 extends StatefulWidget {
  const Skills2({Key? key}) : super(key: key);

  @override
  _Skills2State createState() => _Skills2State();
}

class _Skills2State extends State<Skills2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skills Documentation'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: SafeArea(
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Points',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Indicators',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: const <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('5')),
                DataCell(Text(
                    'Contributing suggestions for the ideas, situations, cases or problems posed.')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('5')),
                DataCell(Text(
                    'Proposing ideas that are innovative as far as contents, development, etc. are concerned.')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('5')),
                DataCell(Text(
                    'Actively participating in discussion')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('5')),
                DataCell(Text(
                    'Acknowledging different manners of doing things; being non-conformist.')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('5')),
                DataCell(Text(
                    'Generating new ideas or solutions to situations or problem based on what is known.')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
