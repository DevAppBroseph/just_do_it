import 'package:dio/dio.dart';
import 'package:just_do_it/constants/server.dart';
import 'package:just_do_it/models/user_reg.dart';

class Repository {
  var dio = Dio();

  Future<void> sendProfile(UserRegModel userRegModel) async {
    final response = await dio.post(
      '$server/auth/',
      data: userRegModel.toJson(),
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
    );

    print('object ${response.data}');

    if (response.statusCode == 200) {
      try {} catch (e) {}
    } else {}
  }

  Future<void> confirmCode(String phone, String code) async {
    final response = await dio.post(
      '$server/auth/',
      data: {"phone_number": phone, "code": code},
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
    );

    print('object ${response.data}');

    if (response.statusCode == 200) {
      try {} catch (e) {}
    } else {}
  }
}
