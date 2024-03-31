import 'package:flutter/material.dart';

class MyMessagesHandler {
  static void showSankBar(var _scaffoldKey, String messages) {
    _scaffoldKey.currentState!.hideCurrentSnackBar();
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
        backgroundColor: Colors.yellow,
        duration: Duration(seconds: 2),
        content: Text(
          messages,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        )));
  }
}
