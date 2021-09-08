import 'package:aplikasi_asabri_nullsafety/cubit/auth_cubit.dart';
import 'package:aplikasi_asabri_nullsafety/cubit/rekap_cubit.dart';
import 'package:aplikasi_asabri_nullsafety/data/preferences/preferences_helper.dart';
import 'package:aplikasi_asabri_nullsafety/pages/absen_page.dart';
import 'package:aplikasi_asabri_nullsafety/pages/home_page.dart';
import 'package:aplikasi_asabri_nullsafety/pages/rekap_page.dart';
import 'package:aplikasi_asabri_nullsafety/pages/sign_in_page.dart';
import 'package:aplikasi_asabri_nullsafety/pages/sign_up_page.dart';
import 'package:aplikasi_asabri_nullsafety/provider/preferences_provider.dart';
import 'package:aplikasi_asabri_nullsafety/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => RekapCubit(),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: Consumer<PreferencesProvider>(builder: (context, provider, child) {
        return MaterialApp(
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
          initialRoute: '/splashPage',
          routes: {
            '/splashPage': (context) => SplashPage(),
            '/home': (context) => HomePage(),
            '/absen': (context) => AbsenPage(),
            '/sign-up': (context) => SignUpPage(),
            '/sign-in': (context) => SignInPage(),
            '/rekap': (context) => RekapPage(),
          },
        );
      }),
    );
  }
}
