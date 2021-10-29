import 'dart:io';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:aplikasi_asabri_nullsafety/common/navigation.dart';
import 'package:aplikasi_asabri_nullsafety/data/preferences/preferences_helper.dart';
import 'package:aplikasi_asabri_nullsafety/pages/absen_page.dart';
import 'package:aplikasi_asabri_nullsafety/pages/blank_page.dart';
import 'package:aplikasi_asabri_nullsafety/pages/home_page.dart';
import 'package:aplikasi_asabri_nullsafety/pages/rekap_page.dart';
import 'package:aplikasi_asabri_nullsafety/pages/sign_in_page.dart';
import 'package:aplikasi_asabri_nullsafety/provider/preferences_provider.dart';
import 'package:aplikasi_asabri_nullsafety/provider/scheduling_provider.dart';
import 'package:aplikasi_asabri_nullsafety/utils/background_service.dart';
import 'package:aplikasi_asabri_nullsafety/utils/notification_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();
  if (Platform.isAndroid) {
    AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  static final Config config = Config(
      tenant: 'f05232ca-4643-4898-82a0-bb544c10c460',
      clientId: '4a66e531-c687-4285-8093-fd82c361fddb',
      scope:
          'openid profile offline_access api://673d504e-8dea-457f-b500-fba119b19016/access_as_user',
      redirectUri: 'https://login.live.com/oauth20_desktop.srf',
      clientSecret: 'QdI7Q~nmB7pchNTrMIxxTywk_zkwzAs1M1dn-');
  static final AadOAuth? oauth = AadOAuth(config);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SchedulingProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Asabri App',
            theme: provider.themeData,
            builder: (context, child) {
              return CupertinoTheme(
                data: CupertinoThemeData(
                  brightness:
                      provider.isDarkTheme ? Brightness.dark : Brightness.light,
                ),
                child: Material(
                  child: child,
                ),
              );
            },
            initialRoute: '/blank',
            routes: {
              '/home': (context) => HomePage(),
              '/absen': (context) => AbsenPage(),
              '/sign-in': (context) => SignInPage(),
              '/rekap': (context) => RekapPage(),
              '/blank': (context) => BlankPage(),
            },
          );
        },
      ),
    );
  }
}
