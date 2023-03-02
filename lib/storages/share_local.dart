import 'package:shared_preferences/shared_preferences.dart';

class ShareLocal {
  static ShareLocal? _local;
  static SharedPreferences? _preferences;
  ShareLocal._();
  static Future instance () async {
    return await getInstance();
  }
  static Future getInstance () async {
    if(_local == null){
      _local = ShareLocal._();
      await _local!.init();
    }
    return _local;
  }
  Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }
  static bool _beforCheck(){
    if(_local == null){
      return true;
    }
    return false;
  }
  getString(String key) {
    if (_beforCheck()) return null;
    return _preferences!.getString(key);
  }
  Future<bool>? putString(String key, String value) {
    if (_beforCheck()) return null;
    return _preferences!.setString(key, value);
  }

  getStringList(String key){
    if(_beforCheck()) return null;
    return _preferences!.getStringList(key);
  }
  Future<bool>? putStringList(String key, List<String> arraysListString){
    if(_beforCheck()) return null;
    return _preferences!.setStringList(key, arraysListString);
  }

  getBools(String key){
    if(_beforCheck()) return null;
    return _preferences!.getBool(key);
  }
  Future<bool>? putBools(String key, bool value) {
    if (_beforCheck()) return null;
    return _preferences!.setBool(key, value);
  }

  getInt(String key){
    if(_beforCheck()) return null;
    return _preferences!.getInt(key);
  }
  Future<bool>? putInt(String key, int value){
    if(_beforCheck()) return null;
    return _preferences!.setInt(key, value);
  }
}
ShareLocal shareLocal = ShareLocal._();
