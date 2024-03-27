import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils{

  static SharedPreferences ?pref;

  //
  getPrefs() async {
    pref = await SharedPreferences.getInstance();
  }

  //
  setString(String key, String value) async {
    await pref!.setString(key, value);
  }

  //
  getString(String key) async {
    return await pref!.getString(key);
  }

  //
  getToken(String key) async {
    return pref!.getString("token");
  }

}