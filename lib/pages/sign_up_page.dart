import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:aplikasi_asabri_nullsafety/provider/auth_provider.dart';
import 'package:aplikasi_asabri_nullsafety/widget/custom_button.dart';
import 'package:aplikasi_asabri_nullsafety/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  static late String namalUser = '';
  static late String niplUser = '';
  static late String divisilUser = '';
  static late String usernamelUser = '';
  static late String passwordUser = '';
  static var user;
  static late String? accessToken;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController nipController = TextEditingController(text: '');
  final TextEditingController divisiController =
      TextEditingController(text: '');
  final TextEditingController usernameController =
      TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');
  bool isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleSignUp() async {
      setState(() {
        isLoading = true;
      });

      if (nameController.text == '') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.amber,
            content: Text(
              'Masukan nama',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (nipController.text == '') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.amber,
            content: Text(
              'Masukan nip',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (divisiController.text == '') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.amber,
            content: Text(
              'Masukan divisi',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (usernameController.text == '') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.amber,
            content: Text(
              'Masukan username',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (await authProvider.register(
        name: nameController.text,
        nip: nipController.text,
        divisi: divisiController.text,
        username: usernameController.text,
        divisiid: 0,
        password: passwordController.text,
      )) {
        Navigator.pushNamed(context, '/sign-in');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Registrasi berhasil!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        // Navigator.pushNamed(context, '/sign-up');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Gagal Registrasi, username sudah ada.',
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
            'Daftar',
            textAlign: TextAlign.center,
            style: textTextStyle.copyWith(
              fontSize: 24,
            ),
          ),
        );
      }

      Widget namaInput() {
        return CustomTextFormField(
          title: 'Nama lengkap',
          hintText: 'Nama lengkap',
          controller: nameController,
        );
      }

      Widget nipInput() {
        return CustomTextFormField(
          title: 'Nip',
          hintText: 'Nip',
          controller: nipController,
          keyboard: TextInputType.number,
        );
      }

      Widget divisiInput() {
        return CustomTextFormField(
          title: 'Divisi',
          hintText: 'Divisi',
          controller: divisiController,
        );
      }

      Widget usernameInput() {
        return CustomTextFormField(
          title: 'Username',
          hintText: 'Username',
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
                    'Daftar',
                    style: whiteTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: medium,
                    ),
                  ),
            width: double.infinity,
            onPressed: handleSignUp,
          ),
        );
      }

      return Container(
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
            namaInput(),
            nipInput(),
            divisiInput(),
            usernameInput(),
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

    Widget signInButton() {
      return TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'sudah memiliki akun? masuk',
            style: textTextStyle,
          ));
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            inputSection(),
            SizedBox(height: 20),
            signInButton(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
