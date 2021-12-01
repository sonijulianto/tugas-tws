import 'dart:io';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:aplikasi_asabri_nullsafety/main.dart';
import 'package:aplikasi_asabri_nullsafety/provider/preferences_provider.dart';
import 'package:aplikasi_asabri_nullsafety/provider/scheduling_provider.dart';
import 'package:aplikasi_asabri_nullsafety/widget/custom_dialog.dart';
import 'package:aplikasi_asabri_nullsafety/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  static const String settingsTitle = 'Settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AadOAuth oauth = AadOAuth(MyApp.config);

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          SettingsPage.settingsTitle,
          style: whiteTextStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(SettingsPage.settingsTitle),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: Column(
            children: [
              ListTile(
                title: Text('Keluar'),
                trailing: IconButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('email', 'sonijulianto@gamial.com');
                    await prefs.setString('password', '123456');
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/sign-in', (route) => false);
                  },
                  icon: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ),
              ),
              Consumer<PreferencesProvider>(
                builder: (context, provider, child) {
                  return ListTile(
                    title: Text('Mode Gelap'),
                    trailing: Switch.adaptive(
                      activeColor: secondaryColor,
                      value: provider.isDarkTheme,
                      onChanged: (value) {
                        provider.enableDarkTheme(value);
                      },
                    ),
                  );
                },
              ),
              Consumer<SchedulingProvider>(
                builder: (context, scheduled, _) {
                  return ListTile(
                    title: Text('Pengingat Absen'),
                    trailing: Switch.adaptive(
                      activeColor: secondaryColor,
                      value: scheduled.isScheduled,
                      onChanged: (value) async {
                        if (Platform.isIOS) {
                          customDialog(
                            context,
                            'Coming Soon!',
                            'This feature will be coming soon!',
                          );
                        } else {
                          scheduled.enableDailyNews(value);
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void logout() async {
    await oauth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
