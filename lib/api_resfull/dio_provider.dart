import 'package:dio/dio.dart' show Dio, LogInterceptor;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gen_crm/src/src_index.dart';

import '../src/app_const.dart';

class DioProvider {
  static final Dio dio = Dio();
  static void instance({String? token, String? sess, String? baseUrl}) {
    dio
      ..options.baseUrl = baseUrl ?? dotenv.env[PreferencesKey.BASE_URL]!
      ..options.connectTimeout =
          Duration(milliseconds: BASE_URL.connectionTimeout).inMilliseconds
      ..options.receiveTimeout =
          Duration(milliseconds: BASE_URL.connectionTimeout).inMilliseconds
      ..options.headers = {
        BASE_URL.content_type: BASE_URL.application_json,
        BASE_URL.auth_type: sess != null ? '${BASE_URL.PHPSESSID}=$sess' : '',
        BASE_URL.AUTHORIZATION: token != null ? token : ''
      }
      ..options.followRedirects = false
      ..options.validateStatus = (status) {
        if (status == 401) {
          try {
            loginSessionExpired();
          } catch (e) {
            throw e;
          }
        }
        return status! < 503;
      }
      ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ));
  }
}
