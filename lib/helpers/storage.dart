import 'package:just_do_it/services/get_it/get_it_initializer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static final _sharedPreferences = getIt<SharedPreferences>();
  Future<void> clearData()async{
    await _sharedPreferences.clear();
  }
  Future<void> setRefreshToken(String? refreshToken) async {
    if (refreshToken != null) {
      await _sharedPreferences.setString('refresh', refreshToken);
    }
  }
  Future<void> setAccessToken(String? accessToken) async {
    if (accessToken != null) {
      await _sharedPreferences.setString('access', accessToken);
    }
  }

  static bool get isAuthorized => _sharedPreferences.getString("access") != null;

  String? getAccessToken() {
    return _sharedPreferences.getString('access');
  }
  String? getRefreshToken() {
    return _sharedPreferences.getString('refresh');
  }

  Future<void> setListHistory(String value) async {
    if (value.isNotEmpty) {
      List<String> list = _sharedPreferences.getStringList('history') ?? [];
      list.add(value);
      await _sharedPreferences.setStringList('history', list);
    }
  }

  Future<List<String>> getListHistory() async {
    return _sharedPreferences.getStringList('history') ?? [];
  }
}
