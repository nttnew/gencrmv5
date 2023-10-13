import 'package:dio/dio.dart' show Dio;
import 'package:gen_crm/src/src_index.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart' as Foundation;
import '../src/app_const.dart';
import '../storages/share_local.dart';

class DioProvider {
  static final Dio dio = Dio();
  static void instance({String? token, String? sess, String? baseUrl}) {
    dio
      ..options.baseUrl = baseUrl ??
          shareLocal.getString(PreferencesKey.URL_BASE) ??
          BASE_URL.URL_DEMO5
      ..options.connectTimeout =
          Duration(milliseconds: BASE_URL.connectionTimeout).inMilliseconds
      ..options.receiveTimeout =
          Duration(milliseconds: BASE_URL.connectionTimeout).inMilliseconds
      ..options.headers = {
        BASE_URL.language:
            shareLocal.getString(PreferencesKey.LANGUAGE_NAME) ?? '',
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
      };
    if (Foundation.kDebugMode) {
      dio.interceptors.add(dioLogger());
    }
  }
}

PrettyDioLogger dioLogger() {
  return PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    maxWidth: 100,
  );
}
