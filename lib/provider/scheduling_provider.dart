import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:aplikasi_asabri_nullsafety/data/preferences/preferences_helper.dart';
import 'package:aplikasi_asabri_nullsafety/utils/background_service.dart';
import 'package:aplikasi_asabri_nullsafety/utils/date_time_helper.dart';
import 'package:flutter/material.dart';

class SchedulingProvider extends ChangeNotifier {
  PreferencesHelper? preferencesHelper;

  SchedulingProvider({required this.preferencesHelper}) {
    _scheduledNews();
  }

  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> _scheduledNews() async {
    _isScheduled = await preferencesHelper!.isDailyNewsActive;
    if (_isScheduled) {
      print('Scheduling News Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling News Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }

  Future<bool> _scheduledNewsGo() async {
    _isScheduled = await preferencesHelper!.isDailyNewsActive;
    if (_isScheduled) {
      print('Scheduling News Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(hours: 24),
        2,
        BackgroundService.callback,
        startAt: DateTimeHelperGo.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling News Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }

  void enableDailyNews(bool value) {
    preferencesHelper!.setDailyNews(value);
    _scheduledNews();
    _scheduledNewsGo();
  }
}
