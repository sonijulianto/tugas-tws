import 'dart:convert';

import 'package:aplikasi_asabri_nullsafety/data/models/User_model.dart';
import 'package:aplikasi_asabri_nullsafety/pages/sign_in_page.dart';
import 'package:aplikasi_asabri_nullsafety/service/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;

  UserModel get user => _user!;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> register({
    String? name,
    String? nip,
    String? divisi,
    String? username,
    int? divisiid,
    String? password,
  }) async {
    var response = await AuthService().register(
      name: name,
      nip: nip,
      divisi: divisi,
      username: username,
      divisiid: divisiid,
      password: password,
    );

    var data = jsonDecode(response.body);

    if (data['status'] == 'failed') {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> login({
    String? username,
    String? password,
  }) async {
    var users = jsonDecode((await AuthService().login(
      username: username,
      password: password,
    ))
        .body);

    if (users['statuses'] == 'failed') {
      return false;
    } else {
      SignInPage.accessToken = users['token'];
      user = UserModel(
          statuses: users['statuses'],
          user: User.fromJson(users['user']),
          token: users['token']);
      SignInPage.nip = user.user.nip;
      return true;
    }
  }
}
