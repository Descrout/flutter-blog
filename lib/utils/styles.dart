import 'package:flutter/material.dart';

class Styles {
  static final defaultStyle = TextStyle(color: Colors.grey[900]);

  static final h1 = defaultStyle.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
    height: 22 / 18,
  );

  static final input = InputDecoration(
    fillColor: Colors.white,
    focusColor: Colors.grey[900],
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2.0,
      ),
    ),
    border: OutlineInputBorder(
      gapPadding: 1.0,
      borderSide: BorderSide(
        color: Colors.grey[600],
        width: 1.0,
      ),
    ),
    hintStyle: TextStyle(
      color: Colors.grey[600],
    ),
  );
}
