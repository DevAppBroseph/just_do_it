import 'package:dio/dio.dart';
import 'package:just_do_it/constants/server.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/services/dio/dio_client.dart';

class CustomInterceptors extends Interceptor {


  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        err.response?.data["code"] == "token_not_valid" &&
        Storage().getAccessToken() != null) {
      try {
        final newAccessToken = await getRefreshedToken();
        await Storage().setAccessToken(newAccessToken);
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        return handler.resolve(await dio.fetch(err.requestOptions));
      } catch (_) {
        await Storage().clearData();
      }
    } else {
      return handler.resolve(Response(
          data: err.response?.data,
          requestOptions: err.requestOptions,
          statusCode: err.response?.statusCode));
    }
  }
}

Future<String> getRefreshedToken() async {
  final refreshToken = Storage();
  final response = await Dio().post(
    '$server/auth/api/token/refresh/',
    data: FormData.fromMap({"refresh": refreshToken}),
  );
  return response.data["access"];
}
