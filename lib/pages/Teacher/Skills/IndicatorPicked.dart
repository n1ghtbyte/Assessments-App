import 'package:flutter/material.dart';

class IndicatorPicked extends StatefulWidget {
  final List<dynamic> passedList;
  const IndicatorPicked({Key? key, required this.passedList}) : super(key: key);
  @override
  _IndicatorPickedState createState() => _IndicatorPickedState();
}

class _IndicatorPickedState extends State<IndicatorPicked> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Descriptors"),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.passedList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.passedList[index]),
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
