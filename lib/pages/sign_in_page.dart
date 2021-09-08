import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:aplikasi_asabri_nullsafety/cubit/auth_cubit.dart';
import 'package:aplikasi_asabri_nullsafety/data/api/local_auth_api.dart';
import 'package:aplikasi_asabri_nullsafety/widget/custom_button.dart';
import 'package:aplikasi_asabri_nullsafety/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  static const String emailUser = 'emailUser';
  static const String passwordUser = 'passwordUser';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController(text: '');

  final TextEditingController passwordController =
      TextEditingController(text: '');
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
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
        return TextFormField(
          cursorColor: textColor,
          obscureText: _obscureText,
          controller: passwordController,
          decoration: InputDecoration(
            hintText: 'Your Password',
            hintStyle: textTextStyle,
            suffixIcon: IconButton(
              icon:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
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
        );
      }

      Widget submitButton() {
        return BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            } else if (state is AuthFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.error),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Expanded(
              child: CustomButton(
                title: 'Masuk',
                width: double.infinity,
                onPressed: () async {
                  context.read<AuthCubit>().signIn(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString(SignInPage.emailUser, emailController.text);
                  prefs.setString(
                      SignInPage.passwordUser, passwordController.text);
                },
              ),
            );
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                submitButton(),
                SizedBox(
                  width: 10,
                ),
                buildAuthenticate(context),
              ],
            ),
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
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var email = prefs.getString(SignInPage.emailUser);
            var password = prefs.getString(SignInPage.passwordUser);
            context
                .read<AuthCubit>()
                .signIn(email: email!, password: password!);
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
}
