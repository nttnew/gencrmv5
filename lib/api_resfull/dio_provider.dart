import 'package:dio/dio.dart'
    show Dio, InterceptorsWrapper, RequestOptions, Response;
import 'package:gen_crm/src/src_index.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart' as Foundation;
import '../src/app_const.dart';
import '../storages/share_local.dart';

class DioProvider {
  static bool isSessionExpiredShown =
      false; // Biến cờ để kiểm soát việc hiển thị dialog

  static final Dio dio = Dio();

  static void instance({
    String? token,
    String? sess,
    String? baseUrl,
  }) {
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
      ..options.validateStatus = (code) {
        if (isFail(code) && !isSessionExpiredShown) {
          try {
            isSessionExpiredShown = true;
            loginSessionExpired(() {
              isSessionExpiredShown = false;
            });
          } catch (e) {}
        }
        return code! < BASE_URL.FAIL_503;
      };

    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          if (response.data is Map<String, dynamic>) {
            try {
              if (isFail(int.tryParse(response.data['code'].toString()))) {
                // Kiểm tra dữ liệu nếu pass sai cúc luôn
                return handler.next(
                  Response(
                    requestOptions: RequestOptions(path: ''),
                    data: {
                      'code': int.tryParse(response.data['code'].toString()),
                    }, // Trả về null cho dữ liệu
                  ), // Trả về dữ liệu null
                ); // Trả về phản hồi cho người gọi
              }
            } catch (e) {
              throw e;
            }
          }

          return handler.next(response); // Trả về phản hồi cho người gọi
        },
      ),
    );

    // Kiểm tra và thêm logger nếu chưa có
    if (Foundation.kDebugMode &&
        !dio.interceptors
            .any((interceptor) => interceptor is PrettyDioLogger)) {
      dio.interceptors.add(dioLogger());
    }
  }
}

PrettyDioLogger dioLogger() {
  return PrettyDioLogger(requestHeader: true, requestBody: true, maxWidth: 120);
}
