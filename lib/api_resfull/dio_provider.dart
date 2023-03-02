// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart' show Dio, LogInterceptor;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:get/get.dart';

import '../widgets/widget_dialog.dart';

class DioProvider {
  static final Dio dio = Dio();
  static void instance({String? token,String? sess,String? baseUrl}) {
    dio
      ..options.baseUrl =baseUrl ?? dotenv.env[PreferencesKey.BASE_URL]!
      ..options.connectTimeout = Duration(milliseconds: BASE_URL.connectionTimeout)
      ..options.receiveTimeout = Duration(milliseconds: BASE_URL.connectionTimeout)
      ..options.headers = {
        BASE_URL.content_type: BASE_URL.application_json,
        //BASE_URL.auth_type: "Bearer $token"
        BASE_URL.auth_type:sess!=null? "PHPSESSID=$sess":'',
        "Authorization":token!=null?token:""
      }
      ..options.followRedirects = false
      ..options.validateStatus =   (status) {
        if(status == 401){
          try{
            Get.dialog(WidgetDialog(
              title: MESSAGES.NOTIFICATION,
              content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
              textButton1: "OK",
              backgroundButton1: COLORS.PRIMARY_COLOR,
              onTap1: () {
                AppNavigator.navigateLogout();
              },
            ));
          } catch (e){
            print("lỗi $e");
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
    // return dio;
  }
}
