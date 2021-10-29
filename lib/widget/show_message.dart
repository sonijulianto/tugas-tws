import 'package:flutter/material.dart';

showMessage(BuildContext context, String text) {
  var alert = AlertDialog(content: Text(text), actions: <Widget>[
    TextButton(
        child: const Text('Ok'),
        onPressed: () {
          Navigator.pop(context);
        })
  ]);
  showDialog(context: context, builder: (BuildContext context) => alert);
}
