import 'package:flutter/material.dart';

class SettingsStore {
  static bool notifPromo = true;
  static bool notifStatus = true;
  static String language = 'id'; // 'id' or 'en'
  static String currency = 'IDR';
  static bool privacyHideAmount = false;
  static bool lockShopPay = false;
  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.light);
}
