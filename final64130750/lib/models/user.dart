import 'package:shared_preferences/shared_preferences.dart';

class User {

  static Future<String?> getUID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("uID");
  }

  static Future<void> setUID(String uID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("uID", uID);
  }
}
