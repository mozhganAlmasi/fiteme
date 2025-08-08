import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color.dart';

class CustomTextStyle {
  static final textinputdata = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: "yekan",
    fontSize: 18,
    color: Colors.black,);
  static final textappbar = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: "irs",
    fontSize: 25,
    color: Colors.black,);
  static final lablechart = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: "yekan",
    fontSize: 12,
    color: Colors.black,);
  static final headerchart = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: "yekan",
    fontSize: 25,
    color: Colors.black,);
  static final textbutton =TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: mzhColorThem1[6],
      fontFamily: 'yekan'
  );
  static const alert_title_style = TextStyle(

    color: Colors.pink,
    fontWeight: FontWeight.w800,
    fontFamily: "Irs",
    fontSize: 15,
  );
  static const alert_content_style = TextStyle(

    color: Colors.purple,
    fontWeight: FontWeight.bold,
    fontFamily: "Irs",
    fontSize: 16,

  );
  static const alert_action_style = TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.w800,
    fontFamily: "Irs",
    fontSize: 18,
  );
}
