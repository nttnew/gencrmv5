import 'dart:async';
import 'dart:io';
import 'package:gen_crm/src/models/model_generator/add_data_response.dart';
import 'package:gen_crm/src/models/model_generator/get_phone_cus.dart';
import 'package:gen_crm/src/models/model_generator/infor_acc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:gen_crm/src/models/model_generator/add_customer.dart';
import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:gen_crm/src/models/model_generator/chance_customer.dart';
import 'package:gen_crm/src/models/model_generator/change_infor_acc_request.dart';
import 'package:gen_crm/src/models/model_generator/clue_customer.dart';
import 'package:gen_crm/src/models/model_generator/contract.dart';
import 'package:gen_crm/src/models/model_generator/contract_customer.dart';
import 'package:gen_crm/src/models/model_generator/customer.dart';
import 'package:gen_crm/src/models/model_generator/customer_contract.dart';
import 'package:gen_crm/src/models/model_generator/detail_customer.dart';
import 'package:gen_crm/src/models/model_generator/get_infor.dart';
import 'package:gen_crm/src/models/model_generator/list_notification.dart';
import 'package:gen_crm/src/models/model_generator/login_response.dart';
import 'package:gen_crm/src/models/model_generator/note.dart';
import 'package:gen_crm/src/models/model_generator/note_clue.dart';
import 'package:gen_crm/src/models/model_generator/support.dart';
import 'package:gen_crm/src/models/model_generator/param_del_notif.dart';
import 'package:gen_crm/src/models/model_generator/param_read_notifi.dart';
import 'package:gen_crm/src/models/model_generator/update_pass_request.dart';
import 'package:gen_crm/src/models/model_generator/work_clue.dart';
import 'package:gen_crm/src/models/model_generator/work.dart';

import 'package:retrofit/retrofit.dart';
import 'package:gen_crm/src/base.dart';
import 'package:gen_crm/src/models/index.dart';

import '../models/model_generator/chance.dart';
import '../models/model_generator/contact_by_customer.dart';
import '../models/model_generator/detail_contract.dart';
import '../models/model_generator/clue.dart';
import '../models/model_generator/clue_detail.dart';
import '../models/model_generator/job_chance.dart';
import '../models/model_generator/job_customer.dart';
import '../models/model_generator/policy.dart';
import '../models/model_generator/product_response.dart';
import '../models/model_generator/report_contact.dart';
import '../models/model_generator/report_employee.dart';
import '../models/model_generator/report_general.dart';
import '../models/model_generator/report_option.dart';
import '../models/model_generator/report_product.dart';
import '../models/model_generator/support_customer.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "https://demo.gencrm.com/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
  // ================================> GET <===================================

  @GET(BASE_URL.GET_INFO_USER)
  Future<ResponseDataStatus> getInfoUser();

  @GET(BASE_URL.OTP_RESET_PASSWORD)
  Future<ResponseOtpForgotPassword> otpForgotPassword(@Query("email") String email, @Query("otp_code") String otpCode);

  @GET(BASE_URL.FIRST_INTRODUCE)
  Future<FirstIntroResponse> firstIntroduce();

  @GET(BASE_URL.GET_LOGO)
  Future<LogoResponse> getLogo();

  @GET(BASE_URL.GET_LIST_NEW)
  Future<ListNewsResponse> getListNews(@Query('pageSize') int pageSize, @Query('currentPage') int currentPage);

  @GET(BASE_URL.GET_LIST_DOCUMENTS)
  Future<ListDocumentsResponse> getListDocuments();

  @GET(BASE_URL.INTRODUCE)
  Future<IntroduceResponse> getIntroduce();

  @GET(BASE_URL.GET_LIST_COURSE)
  Future<CoursesResponse> getCourse();

  @GET(BASE_URL.DETAIL_COURSE)
  Future<DetailCoursesResponse> getDetailCourse(@Query('id') int id);

  @GET(BASE_URL.LIST_CUSTOMER)
  Future<ListCustomerResponse> getListCustomer(
      @Query('page') int page,
      @Query('filter') String filter,
      @Query('search') String search);

  @GET(BASE_URL.LIST_CHANCE)
  Future<ListChanceResponse> getListChance(
      @Query('page') int page,
      @Query('filter') String filter,
      @Query('search') String search);

  @GET(BASE_URL.DETAIL_CUSTOMER)
  Future<DetailCustomerResponse> getDetailCustomer(
      @Query('id') int id);

  @GET(BASE_URL.LIST_DETAIL_CHANCE)
  Future<ListDetailChanceResponse> getListDetailChance(
      @Query('id') int id);

  @GET(BASE_URL.ADD_JOB_CHANCE)
  Future<AddJobResponse> getAddJobChance(
      @Query('id') int id);

  @GET(BASE_URL.JOB_CHANCE)
  Future<JobChance> getJobChance(
      @Query('id') int id);

  @GET(BASE_URL.CLUE_CUSTOMER)
  Future<ClueCustomerResponse> getClueCustomer(
      @Query('customer_id') int customer_id);

  @GET(BASE_URL.CHANCE_CUSTOMER)
  Future<ChanceCustomerResponse> getChanceCustomer(
      @Query('customer_id') int customer_id);

  @GET(BASE_URL.CONTRACT_CUSTOMER)
  Future<ContractCustomerResponse> getContractCustomer(
      @Query('customer_id') int customer_id);

  @GET(BASE_URL.JOB_CUSTOMER)
  Future<JobCustomerResponse> getJobCustomer(
      @Query('customer_id') int customer_id);

  @GET(BASE_URL.SUPPORT_CUSTOMER)
  Future<SupportCustomerResponse> getSupportCustomer(
      @Query('customer_id') int customer_id);

  @GET(BASE_URL.DETAIL_SUPPORT)
  Future<ListDetailChanceResponse> getDetailSupport(
      @Query('id') String id);

  @GET(BASE_URL.LIST_CONTRACT)
  Future<ContractResponse> getListContract(
      @Query('page') int page,
      @Query('search') String search,
      @Query('filter') String filter,
      );

  @GET(BASE_URL.LIST_SUPPORT)
  Future<SupportResponse> getListSupport(
      @Query('page') int page,
      @Query('search') String search,
      @Query('filter') String filter,
      );

  @GET(BASE_URL.LIST_CLUE)
  Future<ListClueResponse> getListClue(
      @Query('page') int page,
      @Query('filter') String filter,
      @Query('search') String search);

  @GET(BASE_URL.ADD_CUSTOMER_GET)
  Future<AddCustomerIndividual> getAddCustomer(
      @Query('la_ca_nhan') int la_ca_nhan,
      @Query('id') String? id
      );

  @GET(BASE_URL.ADD_CUSTOMER_GET)
  Future<AddCustomerIndividual> getAddCustomerOr();

  @GET(BASE_URL.PAYMENT_CONTRACT)
  Future<PaymentContractResponse> getPaymentContract(
      @Query('id') int id);

  @GET(BASE_URL.JOB_CONTRACT)
  Future<JobChance> getJobContract(
      @Query('id') int id);

  @DELETE(BASE_URL.DELETE_CUSTOMER)
  Future<BaseResponse> deleteCustomer(
      // @Query('id') int id
      @Body() Map<String,dynamic> map
      );

  @GET(BASE_URL.DETAIL_CONTRACT)
  Future<DetailContractResponse> getDetailContract(
      @Query('id') int id);

  @GET(BASE_URL.SUPPORT_CONTRACT)
  Future<SupportContractResponse> getSupportContract(
      @Query('id') int id);

  @GET(BASE_URL.DETAIL_CLUE)
  Future<DetailClue> getDetailClue(@Query('id') String id ,);
  @GET(BASE_URL.WORK_CLUE)
  Future<WorkClueResponse> getWorkClue(@Query('id') String id ,);
  @GET(BASE_URL.NOTE_CLUE)
  Future<ListNoteClueResponse> getNoteClue(@Query('id') String id ,);
  @GET(BASE_URL.POLICY)
  Future<PolicyResponse> getPolicy();
  @GET(BASE_URL.GET_INFOR)
  Future<InforResponse> getInfor();
  @GET(BASE_URL.LIST_UNREAD_NOTIFICATION)
  Future<ListNotificationResponse> getListUnReadNotification(
      @Query('page') int page,
      );
  @GET(BASE_URL.LIST_READED_NOTIFICATION)
  Future<ListNotificationResponse> getListReadedNotification(
      @Query('page') int page,
      );
  @DELETE(BASE_URL.DELETE_NOTIFICATION)
  Future<BaseResponse> deleteNotifi(
      @Body() DelNotifiParam delnotifi,
      );
  @GET(BASE_URL.LIST_JOB)
  Future<WorkResponse> getListJob(
      @Query('pageIndex') String pageIndex,
      @Query('text') String text,
      @Query('filter_id') String filter_id,
      );
  @GET(BASE_URL.INFOR_ACC)
  Future<InforAccResponse> getInforAcc();

  @GET(BASE_URL.REPORT_OPTIONS)
  Future<TimeResponse> getReportOption();

  @GET(BASE_URL.REPORT_OPTIONS_2)
  Future<FilterResponse> getReportOption2();

  //Dương
  @GET(BASE_URL.GET_UPDATE_CUSTOMER)
  Future<AddCustomerIndividual> getUpdateCustomer(
      @Query('id') String id
      );

  @DELETE(BASE_URL.DELETE_CONTRACT)
  Future<BaseResponse> deleteContract(
      // @Query('id') int id
      @Body() Map<String,dynamic> map
      );

  @DELETE(BASE_URL.DELETE_JOB)
  Future<BaseResponse> deleteJob(
      // @Query('id') int id
      @Body() Map<String,dynamic> map
      );

  @GET(BASE_URL.DETAIL_JOB)
  Future<DetailWorkResponse> detailJob(
      @Query('id') int id
      );

  @GET(BASE_URL.GET_FORM_ADD_CONTACT_CUS)
  Future<AddCustomerIndividual> getFormaddContactCus(
      @Query('customer_id') String customer_id
      );

  @GET(BASE_URL.GET_FORM_ADD_OPPORT_CUS)
  Future<AddCustomerIndividual> getFormAddOppCus(
      @Query('customer_id') String customer_id
      );

  @GET(BASE_URL.GET_FORM_ADD_CONTRACT_CUS)
  Future<AddCustomerIndividual> getFormAddContractCus(
      @Query('customer_id') String customer_id
      );

  @GET(BASE_URL.GET_FORM_ADD_JOB_CUS)
  Future<AddCustomerIndividual> getFormAddJobCus(
      @Query('customer_id') String customer_id
      );

  @GET(BASE_URL.GET_FORM_ADD_SUPPORT_CUS)
  Future<AddCustomerIndividual> getFormAddSupportCus(
      @Query('customer_id') String customer_id
      );

  @GET(BASE_URL.GET_FORM_ADD_AGENCY)
  Future<AddCustomerIndividual> getFormAddAgency(
      @Query('id') String? id
      );

  @GET(BASE_URL.GET_FORM_ADD_CHANCE)
  Future<AddCustomerIndividual> getFormAddChance(
      @Query('id') String? id
      );

  @GET(BASE_URL.GET_FORM_ADD_CONTRACT)
  Future<AddCustomerIndividual> getFormAddContract(
      @Query('idch') String? id
      );

  @GET(BASE_URL.GET_FORM_ADD_JOB)
  Future<AddCustomerIndividual> getFormAddJob(
      @Query('id') String? id
      );

  @GET(BASE_URL.GET_FORM_ADD_SUPPORT)
  Future<AddCustomerIndividual> getFormAddSupport(
      @Query('id') String? id
      );

  @GET(BASE_URL.GET_FORM_ADD_JOB_OPP)
  Future<AddCustomerIndividual> getFormAddJobOpp(
      @Query('id') String? id
      );

  @GET(BASE_URL.GET_FORM_ADD_JOB_CHANCE)
  Future<AddCustomerIndividual> getFormAddJobChance(
      @Query('id') String? id
      );

  @DELETE(BASE_URL.DELETE_CONTACT)
  Future<BaseResponse> deleteContact(
      // @Query('id') int id
      @Body() Map<String,dynamic> map
      );

  @DELETE(BASE_URL.DELETE_CHANCE)
  Future<BaseResponse> deleteChance(
      // @Query('id') int id
      @Body() Map<String,dynamic> map
      );

  @GET(BASE_URL.FORM_EDIT_CONTACT)
  Future<AddCustomerIndividual> getFormEditContact(
      @Query('id') String? id
      );

  @GET(BASE_URL.FORM_EDIT_SUPPORT)
  Future<AddCustomerIndividual> getFormEditSupport(
      @Query('id') String? id
      );

  @GET(BASE_URL.GET_CUSTOMER_CONTRACT)
  Future<CustomerContractResponse> getCustomerContract(
      @Query('page') String? page,
      @Query('querySearch') String? querySearch
      );

  @DELETE(BASE_URL.DELETE_SUPPORT)
  Future<BaseResponse> deleteSupport(
      @Body() Map<String,dynamic> map
      );

  @DELETE(BASE_URL.DELETE_NOTE_CUS)
  Future<BaseResponse> deleteNoteCus(
      @Body() Map<String,dynamic> map
      );

  @DELETE(BASE_URL.DELETE_NOTE_CONTACT)
  Future<BaseResponse> deleteNoteContact(
      @Body() Map<String,dynamic> map
      );

  @DELETE(BASE_URL.DELETE_NOTE_OOP)
  Future<BaseResponse> deleteNoteOop(
      @Body() Map<String,dynamic> map
      );

  @DELETE(BASE_URL.DELETE_NOTE_CONTRACT)
  Future<BaseResponse> deleteNoteContract(
      @Body() Map<String,dynamic> map
      );

  @DELETE(BASE_URL.DELETE_NOTE_JOB)
  Future<BaseResponse> deleteNoteJob(
      @Body() Map<String,dynamic> map
      );

  @DELETE(BASE_URL.DELETE_NOTE_SUP)
  Future<BaseResponse> deleteNoteSup(
      @Body() Map<String,dynamic> map
      );

  @GET(BASE_URL.GET_FORM_EDIT_CONTRACT)
  Future<AddCustomerIndividual> getFormEditContract(
      @Query('id') String? id
      );

  @GET(BASE_URL.GET_FORM_ADD_JOB_CONTRACT)
  Future<AddCustomerIndividual> getFormAddJobContract(
      @Query('id') String? id
      );

  @GET(BASE_URL.GET_FORM_ADD_SUPPORT_CONTRACT)
  Future<AddCustomerIndividual> getFormAddSupportContract(
      @Query('id') String? id
      );

  @GET(BASE_URL.GET_CONTACT_BY_CUSTOMER)
  Future<ContactByCustomerResponse> getContactByCustomer(
      @Query('customer_id') String? id
      );

  @GET(BASE_URL.GET_NOTE_OPP)
  Future<NoteResponse> getNoteOpp(
      @Query('id') String? id,
      @Query('page') String? page
      );

  @GET(BASE_URL.GET_NOTE_CUS)
  Future<NoteResponse> getNoteCus(
      @Query('id') String? id,
      @Query('page') String? page
      );

  @GET(BASE_URL.GET_NOTE_CONTACT)
  Future<NoteResponse> getNoteContact(
      @Query('id') String? id,
      @Query('page') String? page
      );

  @GET(BASE_URL.GET_NOTE_CONTRACT)
  Future<NoteResponse> getNoteContract(
      @Query('id') String? id,
      @Query('page') String? page
      );


  @GET(BASE_URL.GET_NOTE_JOB)
  Future<NoteResponse> getNoteJob(
      @Query('id') String? id,
      @Query('page') String? page
      );


  @GET(BASE_URL.GET_NOTE_SUP)
  Future<NoteResponse> getNoteSup(
      @Query('id') String? id,
      @Query('page') String? page
      );


  @GET(BASE_URL.LIST_PRODUCT)
  Future<ProductResponse> getListProduct(
      @Query('page') String? page,
      @Query('querySearch') String? querySearch
      );

  @GET(BASE_URL.GET_PHONE_CUS)
  Future<GetPhoneCusResponse> getPhoneCus(
      @Query('id') String? id
      );

  @GET(BASE_URL.GET_PHONE_CUS)
  Future<GetPhoneCusResponse> getPhoneAgency(
      @Query('daumoi_id') String? id
      );

  @GET(BASE_URL.LOGOUT)
  Future<BaseResponse> logout();



  // =================================> POST <==================================

  @POST(BASE_URL.LOGIN)
  Future<LoginResponse> loginApp(@Body() LoginAppRequest loginAppRequest);

  @POST(BASE_URL.REGISTER)
  Future<ResponseStatus> registerApp(@Body() RegisterAppRequest registerAppRequest);

  @POST(BASE_URL.CHANGE_PASSWORD)
  Future<ResponseStatus> changePassword(@Body() ParamChangePassword paramChangePassword);

  @POST(BASE_URL.FORGOT_PASSWORD)
  Future<ParamForgotPassword> forgotPassword(@Body() ParamRequestForgotPassword paramRequestForgotPassword);

  @POST(BASE_URL.FORGOT_PASSWORD_OTP)
  Future<BaseResponse> forgotPasswordOtp(@Body() ParamRequestForgotPasswordOtp paramRequestForgotPasswordOtp);

  @POST(BASE_URL.RESET_PASSWORD)
  Future<BaseResponse> resetPassword(@Body() ParamResetPassword paramResetPassword);

  @POST(BASE_URL.EDIT_PROFILE)
  Future<ResponseDataStatus> postUpdateProfile(@Body() ParamChangeInfo infoUser);

  @POST(BASE_URL.EDIT_PROFILE)
  Future<ResponseDataStatus> postUpdateProfileNotImage(@Body() ParamChangeInfoNotImage infoUser);

  @POST(BASE_URL.ORDER_COURSE)
  Future<ResponseDataStatus> orderCourse(@Body() ParamOrderCourse paramOrderCourse);

  @POST(BASE_URL.REPORT_CONTACT)
  Future<ContactReportResponse> reportContact(@Body() RequestBodyReport requestBodyReport);

  @POST(BASE_URL.REPORT_GENERAL)
  Future<DataGeneralResponse> reportGeneral(@Body() RequestBodyReport requestBodyReport);

  @POST(BASE_URL.REPORT_EMPLOYEE)
  Future<DataEmployResponse> reportEmployee(@Body() RequestEmployReport requestEmployReport);

  @POST(BASE_URL.REPORT_PRODUCT)
  Future<ReportProductResponse> reportProduct(@Body() RequestBodyReportProduct requestBodyReportProduct);

  @POST(BASE_URL.PROFILE)
  Future<ResponseDataStatus> postImages(
      @Part() File image,
      @Query('code') String code,
      @Query('email') String email,
      @Query('name') String name
  );
  //Quân
  @POST(BASE_URL.UPDATE_PASS)
  Future<BaseResponse> updatePass(@Body()  UpdatePassRequest);
  @POST(BASE_URL.READ_NOTIFICATION)
  Future<BaseResponse> readNotification(@Body()  ReadNotifiParam);

  @POST(BASE_URL.CHANGE_INFOR_ACC)
  @MultiPart()
  Future<BaseResponse> changeInforAccNoAvatar(@Part(name:"ho_va_ten") String fullName,@Part(name:"email") String email, @Part(name:"dien_thoai") String phone,@Part(name:"dia_chi") String address );
  @POST(BASE_URL.CHANGE_INFOR_ACC)
  @MultiPart()
  Future<BaseResponse> changeInforAcc(@Part(name:"ho_va_ten") String fullName,@Part(name:"email") String email, @Part(name:"dien_thoai") String phone,@Part(name:"dia_chi") String address ,@Part(name:"avatar") File avatar);
  //Dương
  @POST(BASE_URL.ADD_CUSTOMER_INDIVIDUAL_POST)
  Future<AddDataResponse> addIndividualCustomer(
      @Body() Map<String,dynamic> map
      );

  @POST(BASE_URL.ADD_CUSTOMER_OR)
  Future<AddDataResponse> addOrganizationCustomer(
      @Body() Map<String,dynamic> map
      );

  @POST(BASE_URL.EDIT_CUSTOMER)
  Future<EditCusResponse> editCustomer(
      @Body() Map<String,dynamic> map
      );

  @POST(BASE_URL.ADD_CONTACT_CUS)
  Future<AddDataResponse> addContactCus(
      @Body() Map<String,dynamic> map
      );

  @POST(BASE_URL.ADD_OPPORTUNITY)
  Future<AddDataResponse> addOpportunity(
      @Body() Map<String,dynamic> map
      );

  @POST(BASE_URL.ADD_CONTRACT)
  Future<AddDataResponse> addContract(
      @Body() Map<String,dynamic> map
      );

  @POST(BASE_URL.ADD_JOB)
  Future<AddDataResponse> addJob(
      @Body() Map<String,dynamic> map
      );

  @POST(BASE_URL.ADD_SUPPORT)
  Future<AddDataResponse> addSupport(
      @Body() Map<String,dynamic> map
      );

  @POST(BASE_URL.SAVE_UPDATE_JOB)
  Future<AddDataResponse> saveUpdateJob(
      @Body() Map<String,dynamic> map
      );

  @POST(BASE_URL.ADD_NOTE_CUS)
  Future<BaseResponse> addNoteCus(
      @Part(name: "id") String id,
      @Part(name: "content") String content,
      );

  @POST(BASE_URL.ADD_NOTE_CONTACT)
  Future<BaseResponse> addNoteContact(
      @Part(name: "id") String id,
      @Part(name: "content") String content,
      );

  @POST(BASE_URL.ADD_NOTE_OOP)
  Future<BaseResponse> addNoteOpp(
      @Part(name: "id") String id,
      @Part(name: "content") String content,
      );

  @POST(BASE_URL.ADD_NOTE_CONTRACT)
  Future<BaseResponse> addNoteContract(
      @Part(name: "id") String id,
      @Part(name: "content") String content,
      );

  @POST(BASE_URL.ADD_NOTE_JOB)
  Future<BaseResponse> addNoteJob(
      @Part(name: "id") String id,
      @Part(name: "content") String content,
      );

  @POST(BASE_URL.ADD_NOTE_SUP)
  Future<BaseResponse> addNoteSup(
      @Part(name: "id") String id,
      @Part(name: "content") String content,
      );

  @POST(BASE_URL.EDIT_NOTE_CUS)
  Future<BaseResponse> editNoteCus(
      @Body() Map<String,dynamic> data
      );

  @POST(BASE_URL.EDIT_NOTE_CONTACT)
  Future<BaseResponse> editNoteContact(
      @Body() Map<String,dynamic> data
      );

  @POST(BASE_URL.EDIT_NOTE_OOP)
  Future<BaseResponse> editNoteOop(
      @Body() Map<String,dynamic> data
      );

  @POST(BASE_URL.EDIT_NOTE_CONTRACT)
  Future<BaseResponse> editNoteContract(
      @Body() Map<String,dynamic> data
      );

  @POST(BASE_URL.EDIT_NOTE_JOB)
  Future<BaseResponse> editNoteJob(
      @Body() Map<String,dynamic> data
      );

  @POST(BASE_URL.EDIT_NOTE_SUP)
  Future<BaseResponse> editNoteSup(
      @Body() Map<String,dynamic> data
      );

  @POST(BASE_URL.UPLOAD_FILE_CUS)
  Future<BaseResponse> uploadFileCus(
      @Part(name: "main_id") String id,
      @Part(name: "files") File file
      );

  @POST(BASE_URL.UPLOAD_FILE_CONTACT)
  Future<BaseResponse> uploadFileContact(
      @Part(name: "main_id") String id,
      @Part(name: "files") File file
      );

  @POST(BASE_URL.UPLOAD_FILE_CONTRACT)
  Future<BaseResponse> uploadFileContract(
      @Part(name: "main_id") String id,
      @Part(name: "files") File file
      );

  @POST(BASE_URL.UPLOAD_FILE_JOB)
  Future<BaseResponse> uploadFileJob(
      @Part(name: "main_id") String id,
      @Part(name: "files") File file
      );

  @POST(BASE_URL.UPLOAD_FILE_OPP)
  Future<BaseResponse> uploadFileOpp(
      @Part(name: "main_id") String id,
      @Part(name: "files") File file
      );

  @POST(BASE_URL.UPLOAD_FILE_SUPPORT)
  Future<BaseResponse> uploadFileSupport(
      @Part(name: "main_id") String id,
      @Part(name: "files") File file
      );
}