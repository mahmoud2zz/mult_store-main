import 'package:flutter/cupertino.dart';

class MyAlertDilaog {
  static void showMyDialog({
    required BuildContext context,
    required String title,
    required String content,
    required  Function() tabNo,
    required Function() tabYes,
  }) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: tabNo,
            child:  Text('No'),
          ),
          CupertinoDialogAction(
         isDefaultAction: true,
            onPressed: tabYes,
            child:  Text('Yes'),
          )
        ],
      ),
    );
  }
}