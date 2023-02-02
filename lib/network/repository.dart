import 'package:dio/dio.dart';
import 'package:just_do_it/constants/server.dart';
import 'package:just_do_it/models/user_reg.dart';

class Repository {
  var dio = Dio();

  // регистрация профиля
  Future<bool> confirmRegister(UserRegModel userRegModel) async {
    final response = await dio.post(
      '$server/auth/',
      data: userRegModel.toJson(),
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
    );

    print('object ${response.data}');

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // подтвердить регистраци
  Future<bool> confirmCodeRegistration(String phone, String code) async {
    final response = await dio.put(
      '$server/auth/',
      data: {"phone_number": phone, "code": code},
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
    );

    print('object ${response.data}');

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // забыли пароль, сбросить код
  Future<bool> resetPassword(String login) async {
    final response = await dio.post(
      '$server/auth/reset_password',
      data: {"phone_number": login},
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
    );

    print('object ${response.data}');

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // подтвердить код в забыли пароль
  Future<bool> confirmRestorePassword(String code) async {
    final response = await dio.post(
      '$server/auth/',
      data: {"code": code},
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
    );

    print('object ${response.data}');

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
