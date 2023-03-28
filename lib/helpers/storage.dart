import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Future<void> setAccessToken(String? accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // todo handle the error msg when accessToken is null
    if (accessToken == null) {
      await prefs.remove('access');
      return;
    }
    await prefs.setString('access', accessToken);
  }

  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access');
  }
}
