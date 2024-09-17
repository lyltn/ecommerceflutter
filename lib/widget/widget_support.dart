import 'package:flutter/material.dart';

class AppWiget {
  static TextStyle boldTextFeildStyle() {
    return TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto');
  }

  static TextStyle HeadlineTextFeildStyle() {
    return TextStyle(
        color: Colors.black,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto');
  }

  static TextStyle LightTextFeildStyle() {
    return TextStyle(
        color: Colors.black38,
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto');
  }

  static TextStyle SemiBoldTextFeildStyle() {
    return TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto');
  }

  static TextStyle TextFeildStyle() {
    return TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'Roboto');
  }
}
