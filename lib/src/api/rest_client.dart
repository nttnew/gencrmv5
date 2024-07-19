import 'dart:async';
import 'dart:io';
import 'package:gen_crm/src/models/model_generator/add_data_response.dart';
import 'package:gen_crm/src/models/model_generator/detail_product_module_response.dart';
import 'package:gen_crm/src/models/model_generator/get_phone_cus.dart';
import 'package:gen_crm/src/models/model_generator/info_acc.dart';
import 'package:gen_crm/src/models/model_generator/manager_filter_response.dart';
import 'package:gen_crm/src/models/model_generator/product_customer_edit_response.dart';
import 'package:dio/dio.dart';
import 'package:gen_crm/src/models/model_generator/add_customer.dart';
import 'package:gen_crm/src/models/model_generator/base_response.dart';
import 'package:gen_crm/src/models/model_generator/chance_customer.dart';
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
import 'package:gen_crm/src/models/model_generator/support.dart';
import 'package:gen_crm/src/models/model_generator/work_clue.dart';
import 'package:gen_crm/src/models/model_generator/work.dart';
import 'package:gen_crm/src/preferences_key.dart';
import 'package:gen_crm/storages/share_local.dart';
import 'package:retrofit/retrofit.dart';
import 'package:gen_crm/src/base.dart';
import 'package:gen_crm/src/models/index.dart';
import '../models/model_generator/address_customer_response.dart';
import '../models/model_generator/bien_so_with_img.dart';
import '../models/model_generator/bieu_mau_response.dart';
import '../models/model_generator/contact_by_customer.dart';
import '../models/model_generator/detail_contract.dart';
import '../models/model_generator/clue.dart';
import '../models/model_generator/clue_detail.dart';
import '../models/model_generator/detail_product_customer_response.dart';
import '../models/model_generator/detail_xe_dich_vu.dart';
import '../models/model_generator/file_response.dart';
import '../models/model_generator/get_xe_response.dart';
import '../models/model_generator/group_product_response.dart';
import '../models/model_generator/job_chance.dart';
import '../models/model_generator/job_customer.dart';
import '../models/model_generator/list_car_response.dart';
import '../models/model_generator/list_ch_product_customer_response.dart';
import '../models/model_generator/list_cv_customer_response.dart';
import '../models/model_generator/list_hd_product_customer_response.dart';
import '../models/model_generator/list_ht_product_customer_response.dart';
import '../models/model_generator/list_product_customer_response.dart';
import '../models/model_generator/list_product_response.dart';
import '../models/model_generator/main_menu_response.dart';
import '../models/model_generator/pdf_response.dart';
import '../models/model_generator/policy.dart';
import '../models/model_generator/product_customer_save_response.dart';
import '../models/model_generator/product_service_pack_response.dart';
import '../models/model_generator/products_response.dart';
import '../models/model_generator/qr_code_payment_res.dart';
import '../models/model_generator/quick_create_response.dart';
import '../models/model_generator/report_contact.dart';
import '../models/model_generator/report_employee.dart';
import '../models/model_generator/report_general.dart';
import '../models/model_generator/report_option.dart';
import '../models/model_generator/report_product.dart';
import '../models/model_generator/response_bao_cao.dart';
import '../models/model_generator/response_bao_cao_so_quy.dart';
import '../models/model_generator/response_car_dashboard.dart';
import '../models/model_generator/response_edit_product.dart';
import '../models/model_generator/response_ntc_filter.dart';
import '../models/model_generator/response_save_product.dart';
import '../models/model_generator/save_checkin_response.dart';
import '../models/model_generator/service_pack_response.dart';
import '../models/model_generator/support_customer.dart';
import '../models/model_generator/xe_dich_vu_response.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "https://demo5.gencrm.com/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
  // ================================> GET <===================================

  @GET(BASE_URL.GET_INFO_USER)
  Future<ResponseDataStatus> getInfoUser();

  @GET(BASE_URL.OTP_RESET_PASSWORD)
  Future<ResponseOtpForgotPassword> otpForgotPassword(
    @Query("email") String email,
    @Query("otp_code") String otpCode,
  );

  @GET(BASE_URL.FIRST_INTRODUCE)
  Future<FirstIntroResponse> firstIntroduce();

  @GET(BASE_URL.GET_LOGO)
  Future<LogoResponse> getLogo();

  @GET(BASE_URL.GET_LIST_NEW)
  Future<ListNewsResponse> getListNews(
    @Query('pageSize') int pageSize,
    @Query('currentPage') int currentPage,
  );

  @GET(BASE_URL.GET_LIST_DOCUMENTS)
  Future<ListDocumentsResponse> getListDocuments();

  @GET(BASE_URL.INTRODUCE)
  Future<IntroduceResponse> getIntroduce();

  @GET(BASE_URL.GET_LIST_COURSE)
  Future<CoursesResponse> getCourse();

  @GET(BASE_URL.DETAIL_COURSE)
  Future<DetailCoursesResponse> getDetailCourse(
    @Query('id') int id,
  );

  @GET(BASE_URL.LIST_CUSTOMER)
  Future<ListCustomerResponse> getListCustomer(
    @Query('page') int page,
    @Query('filter') String filter,
    @Query('search') String search,
    @Query('nguoi_quan_ly') String? manager,
    @Query('qr') String? qr,
  );

  @GET(BASE_URL.LIST_CHANCE)
  Future<ListChanceResponse> getListChance(
    @Query('page') int page,
    @Query('filter') String filter,
    @Query('search') String search,
    @Query('nguoi_quan_ly') String? manager,
  );

  @GET(BASE_URL.DETAIL_CUSTOMER)
  Future<DetailCustomerResponse> getDetailCustomer(
    @Query('id') int id,
  );

  @GET(BASE_URL.LIST_DETAIL_CHANCE)
  Future<ListDetailChanceResponse> getListDetailChance(
    @Query('id') int id,
  );

  @GET(BASE_URL.ADD_JOB_CHANCE)
  Future<AddJobResponse> getAddJobChance(
    @Query('id') int id,
  );

  @GET(BASE_URL.JOB_CHANCE)
  Future<JobChance> getJobChance(
    @Query('id') int id,
    @Query('page') int page,
  );

  @GET(BASE_URL.CLUE_CUSTOMER)
  Future<ClueCustomerResponse> getClueCustomer(
    @Query('customer_id') int customer_id,
    @Query('page') int page,
  );

  @GET(BASE_URL.CHANCE_CUSTOMER)
  Future<ChanceCustomerResponse> getChanceCustomer(
    @Query('customer_id') int customer_id,
    @Query('page') int page,
  );

  @GET(BASE_URL.CONTRACT_CUSTOMER)
  Future<ContractCustomerResponse> getContractCustomer(
    @Query('customer_id') int customer_id,
    @Query('page') int page,
  );

  @GET(BASE_URL.JOB_CUSTOMER)
  Future<JobCustomerResponse> getJobCustomer(
    @Query('customer_id') int customer_id,
    @Query('page') int page,
  );

  @GET(BASE_URL.SUPPORT_CUSTOMER)
  Future<SupportCustomerResponse> getSupportCustomer(
    @Query('customer_id') int customer_id,
    @Query('page') int page,
  );

  @GET(BASE_URL.DETAIL_SUPPORT)
  Future<ListDetailChanceResponse> getDetailSupport(@Query('id') String id);

  @GET(BASE_URL.LIST_CONTRACT)
  Future<ContractResponse> getListContract(
    @Query('page') int page,
    @Query('search') String search,
    @Query('filter') String filter,
    @Query('nguoi_quan_ly') String? manager,
  );

  @GET(BASE_URL.LIST_SUPPORT)
  Future<SupportResponse> getListSupport(
    @Query('page') int page,
    @Query('search') String search,
    @Query('filter') String filter,
    @Query('nguoi_quan_ly') String? manager,
  );

  @GET(BASE_URL.LIST_CLUE)
  Future<ListClueResponse> getListClue(
    @Query('page') int page,
    @Query('filter') String filter,
    @Query('search') String search,
    @Query('nguoi_quan_ly') String? manager,
  );

  @GET(BASE_URL.ADD_CUSTOMER_GET)
  Future<AddCustomerIndividual> getAddCustomer(
    @Query('la_ca_nhan') int la_ca_nhan,
    @Query('id') String? id,
  );

  @POST(BASE_URL.ADD_SERVICE_VOUCHER)
  Future<AddCustomerIndividual> postAddServiceVoucher(
    @Field('so_dien_thoai') String soDienThoai,
    @Field('bien_so') String bienSo,
  );

  @POST(BASE_URL.SAVE_SERVICE_VOUCHER)
  Future<dynamic> saveServiceVoucher(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.LIST_CAR_INFO)
  Future<ListCarInfo> getVersionInfoCar();

  @GET(BASE_URL.ADD_CUSTOMER_GET)
  Future<AddCustomerIndividual> getAddCustomerOr();

  @GET(BASE_URL.PAYMENT_CONTRACT)
  Future<PaymentContractResponse> getPaymentContract(
    @Query('id') int id,
  );

  @GET(BASE_URL.JOB_CONTRACT)
  Future<JobChance> getJobContract(
    @Query('id') int id,
    @Query('page') int page,
  );

  @DELETE(BASE_URL.DELETE_CUSTOMER)
  Future<BaseResponse> deleteCustomer(
    @Body() Map<String, dynamic> map,
  );

  @GET(BASE_URL.DETAIL_CONTRACT)
  Future<DetailContractResponse> getDetailContract(
    @Query('id') int id,
  );

  @GET(BASE_URL.SUPPORT_CONTRACT)
  Future<SupportContractResponse> getSupportContract(
    @Query('id') int id,
    @Query('page') int page,
  );

  @GET(BASE_URL.DETAIL_CLUE)
  Future<DetailClue> getDetailClue(
    @Query('id') String id,
  );
  @GET(BASE_URL.WORK_CLUE)
  Future<WorkClueResponse> getWorkClue(
    @Query('id') String id,
    @Query('page') int page,
  );

  @GET(BASE_URL.POLICY)
  Future<PolicyResponse> getPolicy();

  @GET(BASE_URL.GET_INFOR)
  Future<InforResponse> getInfor();

  @GET(BASE_URL.LIST_UNREAD_NOTIFICATION)
  Future<NotificationResponse> getListUnReadNotification(
    @Query('page') int page,
  );

  @GET(BASE_URL.LIST_READED_NOTIFICATION)
  Future<NotificationResponse> getListReadedNotification(
    @Query('page') int page,
  );
  @DELETE(BASE_URL.DELETE_NOTIFICATION)
  Future<BaseResponse> deleteNotifi(
    @Field('id') String id,
  );

  @GET(BASE_URL.LIST_JOB)
  Future<WorkResponse> getListJob(
    @Query('pageIndex') String pageIndex,
    @Query('text') String text,
    @Query('filter_id') String filter_id,
    @Query('nguoi_quan_ly') String? manager,
  );
  @GET(BASE_URL.INFO_ACC)
  Future<InfoAccResponse> getInforAcc();

  @GET(BASE_URL.REPORT_OPTIONS)
  Future<TimeResponse> getReportOption();

  @GET(BASE_URL.REPORT_OPTIONS_2)
  Future<FilterResponse> getReportOption2();

  @GET(BASE_URL.GET_UPDATE_CUSTOMER)
  Future<AddCustomerIndividual> getUpdateCustomer(
    @Query('id') String id,
  );

  @DELETE(BASE_URL.DELETE_CONTRACT)
  Future<BaseResponse> deleteContract(
    @Body() Map<String, dynamic> map,
  );

  @DELETE(BASE_URL.DELETE_JOB)
  Future<BaseResponse> deleteJob(
    @Body() Map<String, dynamic> map,
  );

  @GET(BASE_URL.DETAIL_JOB)
  Future<DetailWorkResponse> detailJob(
    @Query('id') int id,
  );

  @GET(BASE_URL.GET_FORM_ADD_CONTACT_CUS)
  Future<AddCustomerIndividual> getFormaddContactCus(
    @Query('customer_id') String customer_id,
  );

  @GET(BASE_URL.GET_FORM_ADD_OPPORT_CUS)
  Future<AddCustomerIndividual> getFormAddOppCus(
    @Query('customer_id') String customer_id,
  );

  @GET(BASE_URL.GET_FORM_ADD_CONTRACT_CUS)
  Future<AddCustomerIndividual> getFormAddContractCus(
    @Query('customer_id') String customer_id,
  );

  @GET(BASE_URL.GET_FORM_ADD_JOB_CUS)
  Future<AddCustomerIndividual> getFormAddJobCus(
    @Query('customer_id') String customer_id,
  );

  @GET(BASE_URL.GET_FORM_ADD_SUPPORT_CUS)
  Future<AddCustomerIndividual> getFormAddSupportCus(
    @Query('customer_id') String customer_id,
  );

  @GET(BASE_URL.GET_FORM_ADD_AGENCY)
  Future<AddCustomerIndividual> getFormAddAgency(
    @Query('id') String? id,
  );

  @GET(BASE_URL.GET_FORM_ADD_CHANCE)
  Future<AddCustomerIndividual> getFormAddChance(
    @Query('id') String? id,
  );

  @GET(BASE_URL.GET_FORM_ADD_CONTRACT)
  Future<AddCustomerIndividual> getFormAddContract(
    @Query('idch') String? id,
  );

  @GET(BASE_URL.GET_FORM_ADD_JOB)
  Future<AddCustomerIndividual> getFormAddJob(
    @Query('id') String? id,
  );

  @GET(BASE_URL.GET_FORM_ADD_SUPPORT)
  Future<AddCustomerIndividual> getFormAddSupport(
    @Query('id') String? id,
  );

  @GET(BASE_URL.GET_FORM_ADD_JOB_OPP)
  Future<AddCustomerIndividual> getFormAddJobOpp(
    @Query('id') String? id,
  );

  @GET(BASE_URL.GET_FORM_ADD_JOB_CHANCE)
  Future<AddCustomerIndividual> getFormAddJobChance(
    @Query('id') String? id,
  );

  @DELETE(BASE_URL.DELETE_CONTACT)
  Future<BaseResponse> deleteContact(
    @Body() Map<String, dynamic> map,
  );

  @DELETE(BASE_URL.DELETE_CHANCE)
  Future<BaseResponse> deleteChance(
    @Body() Map<String, dynamic> map,
  );

  @GET(BASE_URL.FORM_EDIT_CONTACT)
  Future<AddCustomerIndividual> getFormEditContact(
    @Query('id') String? id,
  );

  @GET(BASE_URL.FORM_EDIT_SUPPORT)
  Future<AddCustomerIndividual> getFormEditSupport(
    @Query('id') String? id,
  );

  @GET(BASE_URL.GET_CUSTOMER_CONTRACT)
  Future<CustomerContractResponse> getCustomerContract(
    @Query('page') String? page,
    @Query('querySearch') String? querySearch,
  );

  @DELETE(BASE_URL.DELETE_SUPPORT)
  Future<BaseResponse> deleteSupport(
    @Body() Map<String, dynamic> map,
  );

  @DELETE(BASE_URL.DELETE_NOTE)
  Future<BaseResponse> deleteNote(
    @Path("module") String module,
    @Body() Map<String, dynamic> map,
  );

  @GET(BASE_URL.GET_FORM_EDIT_CONTRACT)
  Future<AddCustomerIndividual> getFormEditContract(
    @Query('id') String? id,
  );

  @GET(BASE_URL.GET_FORM_ADD_JOB_CONTRACT)
  Future<AddCustomerIndividual> getFormAddJobContract(
    @Query('id') String? id,
  );

  @GET(BASE_URL.GET_FORM_ADD_SUPPORT_CONTRACT)
  Future<AddCustomerIndividual> getFormAddSupportContract(
    @Query('id') String? id,
  );

  @GET(BASE_URL.GET_CONTACT_BY_CUSTOMER)
  Future<ContactByCustomerResponse> getContactByCustomer(
    @Query('customer_id') String? id,
  );

  @GET(BASE_URL.GET_LIST_NOTE)
  Future<NoteResponse> getNoteList(
    @Path('module') String module,
    @Query('id') String id,
    @Query('page') String page,
  );

  @GET(BASE_URL.LIST_PRODUCT)
  Future<ProductsResponse> getListProduct(
    @Query('page') String? page,
    @Query('querySearch') String? querySearch,
    @Query('group') String? group,
  );

  @GET(BASE_URL.GET_PHONE_CUS)
  Future<GetPhoneCusResponse> getPhoneCus(
    @Query('id') String? id,
  );

  @GET(BASE_URL.GET_PHONE_CUS)
  Future<GetPhoneCusResponse> getPhoneAgency(
    @Query('daumoi_id') String? id,
  );

  @POST(BASE_URL.LOGOUT)
  Future<BaseResponse> logout(
    @Body() Map<String, dynamic> map,
  );

  // =================================> POST <==================================

  @POST(BASE_URL.LOGIN)
  Future<LoginResponse> loginApp(
    @Body() LoginAppRequest loginAppRequest,
  );

  @POST(BASE_URL.REGISTER)
  Future<ResponseStatus> registerApp(
    @Body() RegisterAppRequest registerAppRequest,
  );

  @POST(BASE_URL.CHANGE_PASSWORD)
  Future<ResponseStatus> changePassword(
    @Body() ParamChangePassword paramChangePassword,
  );

  @POST(BASE_URL.FORGOT_PASSWORD)
  Future<ParamForgotPassword> forgotPassword(
    @Body() ParamRequestForgotPassword paramRequestForgotPassword,
  );

  @POST(BASE_URL.FORGOT_PASSWORD_OTP)
  Future<BaseResponse> forgotPasswordOtp(
    @Body() ParamRequestForgotPasswordOtp paramRequestForgotPasswordOtp,
  );

  @POST(BASE_URL.RESET_PASSWORD)
  Future<BaseResponse> resetPassword(
    @Body() ParamResetPassword paramResetPassword,
  );

  @POST(BASE_URL.EDIT_PROFILE)
  Future<ResponseDataStatus> postUpdateProfile(
    @Body() ParamChangeInfo infoUser,
  );

  @POST(BASE_URL.EDIT_PROFILE)
  Future<ResponseDataStatus> postUpdateProfileNotImage(
    @Body() ParamChangeInfoNotImage infoUser,
  );

  @POST(BASE_URL.ORDER_COURSE)
  Future<ResponseDataStatus> orderCourse(
    @Body() ParamOrderCourse paramOrderCourse,
  );

  @POST(BASE_URL.REPORT_CONTACT)
  Future<ContactReportResponse> reportContact(
    @Body() RequestBodyReport requestBodyReport,
  );

  @POST(BASE_URL.REPORT_GENERAL)
  Future<DataGeneralResponse> reportGeneral(
    @Body() RequestBodyReport requestBodyReport,
  );

  @POST(BASE_URL.REPORT_EMPLOYEE)
  Future<DataEmployResponse> reportEmployee(
      @Body() RequestEmployReport requestEmployReport);

  @POST(BASE_URL.REPORT_PRODUCT)
  Future<ReportProductResponse> reportProduct(
    @Body() RequestBodyReportProduct requestBodyReportProduct,
  );

  @POST(BASE_URL.PROFILE)
  Future<ResponseDataStatus> postImages(
    @Part() File image,
    @Query('code') String code,
    @Query('email') String email,
    @Query('name') String name,
  );

  @POST(BASE_URL.UPDATE_PASS)
  Future<BaseResponse> updatePass(
    @Body() UpdatePassRequest,
  );

  @POST(BASE_URL.READ_NOTIFICATION)
  Future<BaseResponse> readNotification(
    @Field('id') String id,
  );

  @POST(BASE_URL.CHANGE_INFOR_ACC)
  @MultiPart()
  Future<BaseResponse> changeInforAccNoAvatar(
    @Part(name: "ho_va_ten") String fullName,
    @Part(name: "email") String email,
    @Part(name: "dien_thoai") String phone,
    @Part(name: "dia_chi") String address,
  );

  @POST(BASE_URL.CHANGE_INFOR_ACC)
  @MultiPart()
  Future<BaseResponse> changeInforAcc(
    @Part(name: "ho_va_ten") String fullName,
    @Part(name: "email") String email,
    @Part(name: "dien_thoai") String phone,
    @Part(name: "dia_chi") String address,
    @Part(name: "avatar") File avatar,
  );

  @POST(BASE_URL.ADD_CUSTOMER_INDIVIDUAL_POST)
  Future<AddDataResponse> addIndividualCustomer(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.ADD_CUSTOMER_OR)
  Future<AddDataResponse> addOrganizationCustomer(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.EDIT_CUSTOMER)
  Future<EditCusResponse> editCustomer(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.ADD_CONTACT_CUS)
  Future<AddDataResponse> addContactCus(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.ADD_OPPORTUNITY)
  Future<AddDataResponse> addOpportunity(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.ADD_CONTRACT)
  Future<AddDataResponse> addContract(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.ADD_JOB)
  Future<AddDataResponse> addJob(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.ADD_SUPPORT)
  Future<AddDataResponse> addSupport(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.SAVE_UPDATE_JOB)
  Future<AddDataResponse> saveUpdateJob(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.ADD_NOTE)
  Future<BaseResponse> addNote(
    @Path("module") String module,
    @Part(name: "id") String id,
    @Part(name: "content") String content,
  );

  @POST(BASE_URL.EDIT_NOTE)
  Future<BaseResponse> editNote(
    @Path('module') String module,
    @Body() Map<String, dynamic> data,
  );

  @POST(BASE_URL.UPLOAD_FILE)
  @MultiPart()
  Future<BaseResponse> uploadMultiFile(
    @Part(name: "main_id") String id,
    @Part(name: 'files[]') List<MultipartFile> files,
    @Path('module') String module,
    @Part(name: 'is_after') bool? isAfter,
  );

  @POST(BASE_URL.UPLOAD_FILE)
  @MultiPart()
  Future<BaseResponse> uploadFile(
    @Part(name: "main_id") String id,
    @Part(name: "files") File file,
    @Part(name: 'is_after') bool isAfter,
    @Path('module') String module,
  );

  @GET(BASE_URL.GET_FILE)
  Future<FileResponse> getFile(
    @Query('module') String module,
    @Query('id') int id,
  );

  @POST(BASE_URL.DELETE_FILE)
  Future<dynamic> deleteFile(
    @Part(name: 'id') String ids,
  );

  @POST(BASE_URL.GET_XE)
  Future<GetXeResponse> getXe(
    @Part(name: 'id') String id,
  );

  @GET(BASE_URL.GROUP_PRODUCT)
  Future<GroupProductResponse> getGroupProduct();

  @POST(BASE_URL.PRODUCT)
  Future<ListProductResponse> getListProductModule(
    @Part(name: "chung_loai_san_pham") String? typeProduct,
    @Part(name: "txt") String? txt,
    @Part(name: "page") String page,
    @Part(name: "filter") String? filter,
    @Query('nguoi_quan_ly') String? manager,
  );

  @GET(BASE_URL.DETAIL_PRODUCT)
  Future<DetailProductResponse> getDetailProduct(
    @Query('id') String id,
  );

  @GET(BASE_URL.ADD_PRODUCT)
  Future<AddCustomerIndividual> getFormAddProduct();

  @GET(BASE_URL.EDIT_PRODUCT)
  Future<AddCustomerIndividual> getEditProduct(
    @Query('id') String id,
  );

  @POST(BASE_URL.ADD_PRODUCT_MODULE)
  @MultiPart()
  Future<ResponseSaveProduct> addProduct(
    @Part() FormDataCustom data,
  );

  @POST(BASE_URL.DELETE_PRODUCT)
  Future<dynamic> deleteProduct(
    @Part(name: 'id') String id,
  );

  @POST(BASE_URL.ADD_PRODUCT_MODULE)
  @MultiPart()
  Future<ResponseEditProduct> editProduct(
    @Part() FormDataCustom map,
    @Query('id') int id,
  );

  @POST(BASE_URL.GET_LIST_BAO_CAO)
  Future<ResponseBaoCao> getListBaoCao(
    @Part(name: 'page') String page,
    @Part(name: 'time') String? time,
    @Part(name: 'timefrom') String? timeFrom,
    @Part(name: 'timeto') String? timeTo,
    @Part(name: 'diem_ban') String? diemBan,
    @Part(name: 'trang_thai') String? trangThai,
  );

  @POST(BASE_URL.HOME_BAO_CAO)
  Future<ResponseCarDashboard> getHomeBaoCao(
    @Part(name: 'time') String? time,
    @Part(name: 'timefrom') String? timeFrom,
    @Part(name: 'timeto') String? timeTo,
    @Part(name: 'diem_ban') String? diemBan,
  );

  @POST(BASE_URL.SAVE_CHECK_IN)
  Future<CheckInResponse> saveCheckIn(
    @Path('module') String module,
    @Part(name: 'id') String id,
    @Part(name: 'latitude') String latitude,
    @Part(name: 'longitude') String longitude,
    @Part(name: 'note_location') String location,
    @Part(name: 'type') String type,
  );

  @POST(BASE_URL.LIST_PRODUCT_CUSTOMER)
  Future<ListProductCustomerResponse> getListProductCustomer(
    @Part(name: 'page') String page,
    @Part(name: 'txt') String? txt,
    @Part(name: 'filter') String? filter,
    @Query('nguoi_quan_ly') String? manager,
  );

  @GET(BASE_URL.PRODUCT_CUSTOMER_DETAIL)
  Future<DetailProductCustomerResponse> getDetailProductCustomer(
    @Query('id') String id,
  );

  @GET(BASE_URL.GET_FORM_ADD_PRODUCT_CUSTOMER)
  Future<AddCustomerIndividual> getFormAddProductCustomer(
    @Query('customer_id') int? customer_id,
  );

  @GET(BASE_URL.GET_FORM_EDIT_PRODUCT_CUSTOMER)
  Future<AddCustomerIndividual> getFormEditProductCustomer(
    @Query('id') String id,
  );

  @POST(BASE_URL.SAVE_FROM_PRODUCT_CUSTOMER_ADD)
  Future<ResponseSaveProductCustomer> saveAddProductCustomer(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.SAVE_FROM_PRODUCT_CUSTOMER_EDIT)
  Future<ResponseEditProductCustomer> saveEditProductCustomer(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.PRODUCT_CUSTOMER_DELETE)
  Future<dynamic> deleteProductCustomer(
    @Part(name: 'id') String id,
  );

  @GET(BASE_URL.GET_FORM_SIGN)
  Future<AddCustomerIndividual> getFormSign(
    @Query('id') String id,
    @Path('module') String type,
  );

  @POST(BASE_URL.SAVE_SIGN)
  Future<ResponseSaveProductCustomer> saveSignature(
    @Body() Map<String, dynamic> map,
    @Path('module') String type,
  );

  @GET(BASE_URL.GET_LIST_CH_PRODUCT_CUSTOMER)
  Future<ListCHProductCustomerResponse> getListCHProductCustomer(
    @Query('spkh') int spkh,
    @Query('page') int page,
  );

  @GET(BASE_URL.GET_LIST_HD_PRODUCT_CUSTOMER)
  Future<ListHDProductCustomerResponse> getListHDProductCustomer(
    @Query('spkh') int spkh,
    @Query('page') int page,
  );

  @GET(BASE_URL.GET_LIST_CV_PRODUCT_CUSTOMER)
  Future<ListCVProductCustomerResponse> getListCVProductCustomer(
    @Query('spkh') int spkh,
    @Query('page') int page,
  );

  @GET(BASE_URL.GET_LIST_HT_PRODUCT_CUSTOMER)
  Future<ListHTProductCustomerResponse> getListHTProductCustomer(
    @Query('spkh') int spkh,
    @Query('page') int page,
  );

  @GET(BASE_URL.GET_FORM_CV_PRODUCT_CUSTOMER)
  Future<AddCustomerIndividual> getFormCVProductCustomer(
    @Query('spkh') int spkh,
  );

  @GET(BASE_URL.GET_FORM_HT_PRODUCT_CUSTOMER)
  Future<AddCustomerIndividual> getFormHTProductCustomer(
    @Query('spkh') int spkh,
  );

  @GET(BASE_URL.GET_FORM_HD_PRODUCT_CUSTOMER)
  Future<AddCustomerIndividual> getFormHDProductCustomer(
    @Query('spkh') int spkh,
  );

  @GET(BASE_URL.GET_FORM_CH_PRODUCT_CUSTOMER)
  Future<AddCustomerIndividual> getFormCHProductCustomer(
    @Query('spkh') int spkh,
  );

  @GET(BASE_URL.GET_LIST_MANAGER_FILTER)
  Future<ManagerFilterResponse> getListManagerFilter(
    @Query('module') String module,
  );

  @GET(BASE_URL.GET_ADDRESS_CUSTOMER)
  Future<AddressCustomerResponse?> getAddressCustomer(
    @Query('id') String id,
  );

  @GET(BASE_URL.GET_SERVICE_PACK)
  Future<ServiceParkResponse> getServicePack(
    @Query('txt') String? txt,
    @Query('page') String? page,
  );

  @GET(BASE_URL.GET_PRODUCT_SERVICE_PACK)
  Future<ProductServicePackModel> getProductServicePack(
    @Query('id') String id,
  );

  @GET(BASE_URL.GET_MENU)
  Future<MainMenuResponse> getMenuMain();

  @GET(BASE_URL.GET_LANGUAGES)
  Future<dynamic> getLanguage();

  @GET(BASE_URL.GET_NTC_FILTER)
  Future<NTCFilterModel> getNTCFilter();

  @GET(BASE_URL.GET_BAO_CAO_SO_QUY)
  Future<BaoCaoSoQuy> getBaoCaoSoQuy(
    @Query('nam') String nam,
    @Query('kytc') String kyTaiChinh,
    @Query('chinhanh') String chiNhanh,
    @Query('p') String page,
  );

  @GET(BASE_URL.GET_DATA_LOCATION)
  Future<dynamic> getDataLocation();

  @POST(BASE_URL.POST_XE_DICH_VU)
  Future<XeDichVuResponse> postXeDichVu(
    @Field('p') String page,
    @Field('tthd') String trangThai,
    @Field('chinhanh') String chiNhanh,
  );

  @POST(BASE_URL.POST_DETAIL_XE_DICH_VU)
  Future<DetailXeDichVuResponse> postDetailXeDichVu(
    @Field('hopdongid') String id,
  );

  @POST(BASE_URL.POST_UPDATE_TDNTH)
  Future<dynamic> postUpdateTDNTH(
    @Field('idct') String id,
    @Field('tiendo') String idTienDo,
    @Field('nguoithuchien') String idNTH,
  );

  @POST(BASE_URL.POST_UPDATE_TTHD)
  Future<dynamic> postUpdateTTHD(
    @Field('hopdongid') String id,
    @Field('tthd') String idTT,
  );

  @GET(BASE_URL.QUICK_CREATE_SEARCH)
  Future<QuickCreateResponse> getSearchQuickCreate(
    @Query('page') String page,
    @Query('bienso') String? bienSo,
    @Query('dienthoai') String? dienThoai,
    @Query('qr') String? qr,
  );

  @GET(BASE_URL.GET_FORM_PAYMENT)
  Future<AddCustomerIndividual> getFormPayment(
    @Query('id') String? id,
    @Query('detail') String? idDetail,
    @Query('id_payment') String? idPay,
  );

  @POST(BASE_URL.ADD_PAYMENT)
  Future<BaseResponse> addPayment(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.UPDATE_PAYMENT)
  Future<BaseResponse> updatePayment(
    @Body() Map<String, dynamic> map,
  );

  @POST(BASE_URL.DELETE_PAYMENT)
  Future<BaseResponse> deletePayment(
    @Field('id_contract') String idContract,
    @Field('id_payment') String idPayment,
  );

  // item: là id của bản ghi cần in
  // temp: là id của mẫu in
  // m: là id của module
  //m=5 tương ứng dịch vụ
  //m=3 cơ hội
  //m=6 hỗ trợ
  @GET(BASE_URL.GET_LIST_MODULE)
  Future<BieuMauResponse> getBieuMau(
    @Query('m') String module,
  );

  @GET(BASE_URL.GET_PDF)
  Future<PdfResponse> getPdf(
    @Query('m') String module,
    @Query('item') String idDetail,
    @Query('temp') String idBieuMau,
  );

  @POST(BASE_URL.QR_CODE_PAYMENT)
  Future<QrCodePaymentRes> getQRCode(
    @Field('amount') String amount,
    @Field('message') String message,
    @Field('id') String id,
  );

  @POST(BASE_URL.GET_BIEN_SO_XE_WITH_IMG)
  @MultiPart()
  Future<BienSoWithImgResponse> getBienSoWithImg(
    @Part(name: 'hinh_anh') File file,
  );
}

class FormDataCustom {
  FormDataCustom({this.formData});
  FormData? formData;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // Xử lý các trường
    formData?.fields.forEach((field) {
      data[field.key] = field.value;
    });

    data['file'] = formData?.files
        .map(
          (e) => e.value,
        )
        .toList();

    return data;
  }

  FormDataCustom.formMap(
    Map<String, dynamic> map,
    Map<String, dynamic> file,
  ) {
    final formData = FormData();

    map.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    file.forEach((key, value) {
      List<MultipartFile> multipartFiles = [];
      List<String> listFile = [];

      if (value is List<File>) {
        for (final e in value) {
          if (e.path.contains(shareLocal.getString(PreferencesKey.URL_BASE))) {
            listFile.add(
              e.path.replaceAll(
                  shareLocal.getString(PreferencesKey.URL_BASE), ''),
            );
          } else {
            multipartFiles.add(MultipartFile.fromFileSync(e.path));
          }
        }
      }
      formData.fields.add(
        MapEntry(
          key,
          listFile
              .toString()
              .replaceAll('[', '')
              .replaceAll(
                ']',
                '',
              )
              .replaceAll(' ', ''),
        ),
      );
      formData.files.addAll(multipartFiles.map((file) {
        return MapEntry('$key[]', file);
      }));
    });

    this.formData = formData;
  }
}
//@override   custom restClient.g
//   Future<ResponseSaveProduct> addProduct(data) async {
//     const _extra = <String, dynamic>{};
//     final queryParameters = <String, dynamic>{};
//     final _headers = <String, dynamic>{};
//     final _data = data.formData;
//     final _result = await _dio.fetch<Map<String, dynamic>>(
//         _setStreamType<ResponseSaveProduct>(Options(
//       method: 'POST',
//       headers: _headers,
//       extra: _extra,
//       contentType: 'multipart/form-data',
//     )
//             .compose(
//               _dio.options,
//               'modules/genmobile2/product/save',
//               queryParameters: queryParameters,
//               data: _data,
//             )
//             .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
//     final value = ResponseSaveProduct.fromJson(_result.data!);
//     return value;
//   }
