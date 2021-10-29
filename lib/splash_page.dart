import 'dart:async';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:aplikasi_asabri_nullsafety/main.dart';
import 'package:aplikasi_asabri_nullsafety/pages/sign_in_page.dart';
import 'package:aplikasi_asabri_nullsafety/widget/show_message.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AadOAuth oauth = AadOAuth(MyApp.config);

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      login();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: textColor,
      child: Stack(
        children: [
          Center(
            child: Image.asset('assets/logo_asabri.png'),
          ),
          Center(
            child: Column(
              children: [
                Spacer(),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 5.0,
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'assets/side_asabri.png',
              width: 150,
            ),
          ),
        ],
      ),
    );
  }

  void showError(dynamic ex) {
    showMessage(context, ex.toString());
  }

  void login() async {
    try {
      await oauth.login();
      var accessToken = await oauth.getAccessToken();
      SignInPage.accessToken = accessToken;
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      showError(e);
    }
  }
}
