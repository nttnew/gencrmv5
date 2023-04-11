import 'dart:async';
import 'package:dio/dio.dart';
import 'package:gen_crm/src/models/model_generator/delete_token_res.dart';
import 'package:gen_crm/src/models/model_generator/notification_res.dart';
import 'package:retrofit/retrofit.dart';
import 'package:gen_crm/src/base.dart';

import '../models/model_generator/call_token_res.dart';

part 'call_client.g.dart';

@RestApi(baseUrl: "https://demo.gencrm.com/")
abstract class CallClient {
  factory CallClient(Dio dio, {String baseUrl}) = _CallClient;

  @POST(BASE_URL.CALL_TOKEN)
  Future<CallTokenResponse> callToken(
    @Field('pn_token') String pnToken,
    @Field('pn_type') String pnType,
    @Field('app_id') String appId,
    @Field('domain') String domain,
    @Field('extension') String extension,
  );

  @DELETE(BASE_URL.CALL_DELETE_TOKEN)
  Future<DeleteTokenResponse> callDeleteToken(
    @Field('pn_token') String pnToken,
    @Field('domain') String domain,
    @Field('extension') String extension,
  );

  @POST(BASE_URL.CALL_NOTIFICATION)
  Future<NotificationCallResponse> callNotification(
    @Field('from') String from,
    @Field('to') String to,
    @Field('callid') String callId,
    @Field('caller_name') String callerName,
    @Field('caller_number') String callerNumber,
  );
}
