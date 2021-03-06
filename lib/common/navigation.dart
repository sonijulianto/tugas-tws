import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Navigation {
  static intentWithData(String routeName) {
    navigatorKey.currentState?.pushNamed('/splashPage');
  }

  static back() => navigatorKey.currentState?.pop();
}
