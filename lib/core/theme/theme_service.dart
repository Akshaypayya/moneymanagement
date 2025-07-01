import 'package:growk_v2/views.dart'; // adjust if needed for SharedPreferencesHelper

class ThemeService {
  static const _key = 'isDark';

  static Future<void> saveTheme(bool isDark) async {
    await SharedPreferencesHelper.saveBool(_key, isDark);
  }

  static Future<bool> loadTheme() async {
    // Use getBool, which returns bool?; fallback to false if null
    return SharedPreferencesHelper.getBool(_key) ?? false;
  }
}
