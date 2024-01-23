import 'package:shared_preferences/shared_preferences.dart';

class ConstPreferences {


  var TOKEN = "TOKEN";
  var LANGUAGES = "LANGUAGES";
  var ROLE = "ROLE";



  Future<void> setToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN, value);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN);
  }
  Future<void> setLanguages(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGES, value);
  }

  Future<String?> getLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(LANGUAGES);
  }
  Future<void> setRole(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ROLE, value);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ROLE);
  }

  void clearPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

}
