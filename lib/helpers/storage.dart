import 'package:just_do_it/services/get_it/get_it_initializer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static final _sharedPreferences = getIt<SharedPreferences>();

  Future<void> setAccessToken(String? accessToken) async {
    if (accessToken == null) {
      await _sharedPreferences.remove('access');
      return;
    }
    await _sharedPreferences.setString('access', accessToken);
  }

  static bool get isAuthorized => _sharedPreferences.getString("access") != null;

  String? getAccessToken() {
    return _sharedPreferences.getString('access');
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
