import 'package:dio/dio.dart';
import 'package:just_do_it/services/dio/custom_interceptor.dart';

final dio = getDioInstance();
Dio getDioInstance() {
  print('getting dio instance');
  final dio = Dio();
  dio.interceptors.add(CustomInterceptors());

  return dio;
}
