import 'dart:async';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:aplikasi_asabri_nullsafety/main.dart';
import 'package:aplikasi_asabri_nullsafety/pages/sign_in_page.dart';
import 'package:flutter/material.dart';

class BlankPage extends StatefulWidget {
  BlankPage({Key? key}) : super(key: key);

  @override
  _BlankPageState createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  final AadOAuth oauth = AadOAuth(MyApp.config);

  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      login();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: textColor,
          ),
        ),
      ),
    );
  }

  void showError(dynamic ex) {
    showMessage(
      ex.toString(),
    );
  }

  void showMessage(String text) {
    var alert = AlertDialog(
      content: Text(text),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void login() async {
    try {
      await oauth.login();
      var accessToken = await oauth.getAccessToken();
      SignInPage.accessToken = accessToken;
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      showError('anda telah logout.');
    }
  }
}
