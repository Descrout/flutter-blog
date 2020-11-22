import 'package:flutter/material.dart';

class NothingToShow extends StatelessWidget {
  const NothingToShow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 50),
        Center(child: Icon(Icons.mood_bad, color: Colors.indigo)),
        Center(
            child: Text(
          "Nothing to show.",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.indigo),
        )),
      ],
    );
  }
}
