import 'package:aad_oauth/aad_oauth.dart';
import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:aplikasi_asabri_nullsafety/data/api/local_auth_api.dart';
import 'package:aplikasi_asabri_nullsafety/main.dart';
import 'package:aplikasi_asabri_nullsafety/widget/custom_button.dart';
import 'package:aplikasi_asabri_nullsafety/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  static late String emailUser = 'emailUser';
  static late String passwordUser = 'passwordUser';
  static var user;
  static late String? accessToken;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController(text: '');

  final TextEditingController passwordController =
      TextEditingController(text: '');
  bool _obscureText = true;
  final AadOAuth oauth = AadOAuth(MyApp.config);

  @override
  void initState() {
    login();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    oauth.setWebViewScreenSizeFromMedia(MediaQuery.of(context));

    Widget inputSection() {
      Widget title() {
        return Container(
          margin: EdgeInsets.only(bottom: 30),
          child: Text(
            'Masuk',
            textAlign: TextAlign.center,
            style: textTextStyle.copyWith(
              fontSize: 24,
            ),
          ),
        );
      }

      Widget emailInput() {
        return CustomTextFormField(
          title: 'Email Address',
          hintText: 'Your email address',
          controller: emailController,
        );
      }

      Widget passwordInput() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style: textTextStyle,
            ),
            TextFormField(
              cursorColor: textColor,
              obscureText: _obscureText,
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Your Password',
                hintStyle: textTextStyle,
                suffixIcon: IconButton(
                  disabledColor: textColor,
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    24,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    24,
                  ),
                  borderSide: BorderSide(
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        );
      }

      Widget submitButton() {
        return Expanded(
          child: CustomButton(
            bgColor: textColor,
            title: 'Masuk',
            width: double.infinity,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString(SignInPage.emailUser, emailController.text);
              prefs.setString(SignInPage.passwordUser, passwordController.text);
            },
          ),
        );
      }

      Widget loginButton() {
        return CustomButton(
          title: 'Masuk with azure',
          width: double.infinity,
          bgColor: secondaryColor,
          onPressed: () {
            login();
          },
        );
      }

      return Container(
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            24,
          ),
        ),
        child: Column(
          children: [
            title(),
            emailInput(),
            passwordInput(),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                submitButton(),
                SignInPage.user != null
                    ? SizedBox(
                        width: 10,
                      )
                    : SizedBox(),
                SignInPage.user != null
                    ? buildAuthenticate(context)
                    : SizedBox()
              ],
            ),
            SizedBox(
              height: 10,
            ),
            loginButton(),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            inputSection(),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/side_asabri.png',
                width: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAvailability(BuildContext context) => buildButton(
        onPressed: () async {
          final isAvailable = await LocalAuthApi.hasBiometrics();
          final biometrics = await LocalAuthApi.getBiometrics();

          final hasFingerprint = biometrics.contains(BiometricType.fingerprint);

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Availability'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildText('Biometrics', isAvailable),
                  buildText('Fingerprint', hasFingerprint),
                ],
              ),
            ),
          );
        },
      );

  Widget buildText(String text, bool checked) => Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            checked
                ? Icon(Icons.check, color: Colors.green, size: 24)
                : Icon(Icons.close, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 24)),
          ],
        ),
      );

  Widget buildAuthenticate(BuildContext context) => buildButton(
        onPressed: () async {
          final isAuthenticated = await LocalAuthApi.authenticate();

          if (isAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
      );

  Widget buildButton({
    required VoidCallback onPressed,
  }) =>
      Container(
        width: 70,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: onPressed,
          child: Icon(
            Icons.fingerprint,
            color: whiteColor,
            size: 30,
          ),
        ),
      );

  Future<void> fingerprintButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(SignInPage.user);
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
