import 'dart:async';
import 'package:gen_crm/api_resfull/dio_provider.dart';
import 'package:gen_crm/src/models/model_generator/call_token_res.dart';
import 'package:gen_crm/src/models/model_generator/delete_token_res.dart';
import 'package:gen_crm/src/src_index.dart';

import '../src/api/call_client.dart';
import '../src/models/model_generator/notification_res.dart';

class CallRepository {
  var dio = DioProvider.dio;
  CallRepository() {
    DioProvider.instance(baseUrl: BASE_URL.DOMAIN_CALL);
  }

  //==========================================> GET <=========================================

  Future<CallTokenResponse> postTokenCall(
    String pnToken,
    String pnType,
    String appId,
    String domain,
    String extension,
  ) async =>
      await CallClient(dio, baseUrl: dio.options.baseUrl).callToken(
        pnToken,
        pnType,
        appId,
        domain,
        extension,
      );

  Future<DeleteTokenResponse> deleteTokenCall(
    String pnToken,
    String domain,
    String extension,
  ) async =>
      await CallClient(dio, baseUrl: dio.options.baseUrl).callDeleteToken(
        pnToken,
        domain,
        extension,
      );

  Future<NotificationCallResponse> postCallNotification(
    String from,
    String to,
    String callId,
    String callerName,
    String callerNumber,
  ) async =>
      await CallClient(dio, baseUrl: dio.options.baseUrl)
          .callNotification(from, to, callId, callerName, callerNumber);
}
