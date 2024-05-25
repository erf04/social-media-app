import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  // Private constructor
  SharedPreferencesManager._privateConstructor();

  // Static instance of SharedPreferencesManager
  static final SharedPreferencesManager _instance =
      SharedPreferencesManager._privateConstructor();

  // Getter to access the instance
  static SharedPreferencesManager get instance => _instance;

  // SharedPreferences instance
  SharedPreferences? _preferences;

  // Initialize the SharedPreferences instance
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Example method to set a value
  Future<void> setString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  // Example method to get a value
  String? getString(String key) {
    return _preferences?.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  // Example method to get a value
  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  Future<void> remove(String key) async{
    _preferences?.remove(key);
  }
}
