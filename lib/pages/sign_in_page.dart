import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:aplikasi_asabri_nullsafety/data/api/local_auth_api.dart';
import 'package:aplikasi_asabri_nullsafety/pages/home_page.dart';
import 'package:aplikasi_asabri_nullsafety/provider/auth_provider.dart';
import 'package:aplikasi_asabri_nullsafety/widget/custom_button.dart';
import 'package:aplikasi_asabri_nullsafety/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  static late String emailUser = 'emailUser';
  static late String passwordUser = 'passwordUser';
  // static late bool user;
  static late String? nip;
  static late String? accessToken;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController usernameController =
      TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');
  bool isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleSignIn() async {
      setState(() {
        isLoading = true;
      });

      var user = await authProvider.login(
        username: usernameController.text,
        password: passwordController.text,
      );
      if (user) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Username atau password salah',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }

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
          title: 'Username',
          hintText: 'Your username',
          controller: usernameController,
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
            title: isLoading
                ? CircularProgressIndicator(
                    color: whiteColor,
                  )
                : Text(
                    'Masuk',
                    style: whiteTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: medium,
                    ),
                  ),
            width: double.infinity,
            onPressed: handleSignIn,
          ),
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
              ],
            ),
          ],
        ),
      );
    }

    Widget signUpButton() {
      return TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/sign-up');
          },
          child: Text(
            'belum memiliki akun? daftar',
            style: textTextStyle,
          ));
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            inputSection(),
            Spacer(),
            signUpButton(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

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
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove(SignInPage.user);
  }
}
