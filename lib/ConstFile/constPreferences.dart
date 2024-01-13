import 'package:shared_preferences/shared_preferences.dart';

class ConstPreferences {


  var TOKEN = "TOKEN";



  Future<void> setToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN, value);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN);
  }

}
