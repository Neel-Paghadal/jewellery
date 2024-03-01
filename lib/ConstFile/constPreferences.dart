import 'package:shared_preferences/shared_preferences.dart';

class ConstPreferences {


  var TOKEN = "TOKEN";
  var LANGUAGES = "LANGUAGES";
  var ROLE = "ROLE";
  var CODE = "CODE";
  SharedPreferences? _prefs;



  Future<void> setToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN, value);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN);
  }

  Future<void> setCode(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(CODE, value);
  }

  Future<String?> getCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(CODE);
  }

  /*String? getString(String key) {
        return _prefs!.getString(key);
  }
  bool? containsKey(String key) {
    if (_prefs == null) {
      initSharedPreferences();
    } else {
      return _prefs?.containsKey(key);
    }

  }*/



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

  void clearSinglePreferences(String key) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }

}
