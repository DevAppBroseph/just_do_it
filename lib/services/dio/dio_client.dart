import 'package:dio/dio.dart';
import 'package:just_do_it/constants/server.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/services/dio/custom_interceptor.dart';

final dio = getDioInstance();
Dio getDioInstance() {
  print('getting dio instance');
  final dio = Dio();
  dio.interceptors.add(CustomInterceptors());

  return dio;
}
