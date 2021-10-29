import 'dart:io';

import 'package:aplikasi_asabri_nullsafety/pages/absen_page.dart';
import 'package:aplikasi_asabri_nullsafety/pages/rekap_page.dart';
import 'package:aplikasi_asabri_nullsafety/pages/settings_page.dart';
import 'package:aplikasi_asabri_nullsafety/utils/background_service.dart';
import 'package:aplikasi_asabri_nullsafety/utils/notification_helper.dart';
import 'package:aplikasi_asabri_nullsafety/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  static BackgroundService? _service;
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  int _bottomNavIndex = 0;

  List<Widget> _listWidget = [
    AbsenPage(),
    RekapPage(),
    SettingsPage(),
  ];

  List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS
          ? CupertinoIcons.profile_circled
          : Icons.account_box_outlined),
      label: AbsenPage.absenTitle,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.news : Icons.public),
      label: RekapPage.rekapTitle,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
      label: SettingsPage.settingsTitle,
    ),
  ];

  @override
  void initState() {
    _notificationHelper.configureSelectNotificationSubject('/home');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    selectNotificationSubject.close();
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: _bottomNavBarItems),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
