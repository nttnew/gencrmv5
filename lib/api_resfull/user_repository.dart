import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart' show MultipartFile;
import 'package:gen_crm/api_resfull/dio_provider.dart';
import 'package:gen_crm/src/models/model_generator/chance_customer.dart';
import 'package:gen_crm/src/models/model_generator/clue_customer.dart';
import 'package:gen_crm/src/models/model_generator/contact_by_customer.dart';
import 'package:gen_crm/src/models/model_generator/customer.dart';
import 'package:gen_crm/src/models/model_generator/customer_contract.dart';
import 'package:gen_crm/src/models/model_generator/detail_contract.dart';
import 'package:gen_crm/src/models/model_generator/detail_customer.dart';
import 'package:gen_crm/src/models/model_generator/file_response.dart';
import 'package:gen_crm/src/models/model_generator/infor_acc.dart';
import 'package:gen_crm/src/models/model_generator/job_chance.dart';
import 'package:gen_crm/src/models/model_generator/job_customer.dart';
import 'package:gen_crm/src/models/model_generator/list_notification.dart';
import 'package:gen_crm/src/models/model_generator/login_response.dart';
import 'package:gen_crm/src/models/model_generator/note.dart';
import 'package:gen_crm/src/models/model_generator/note_clue.dart';
import 'package:gen_crm/src/models/model_generator/policy.dart';
import 'package:gen_crm/src/models/model_generator/product_response.dart';
import 'package:gen_crm/src/models/model_generator/report_employee.dart';
import 'package:gen_crm/src/models/model_generator/support.dart';
import 'package:gen_crm/src/models/model_generator/work_clue.dart';
import 'package:gen_crm/src/models/model_generator/work.dart';
import 'package:gen_crm/src/models/request/voucher_service_request.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/storages/share_local.dart';

import '../src/models/model_generator/add_data_response.dart';
import '../src/models/model_generator/add_voucher_response.dart';
import '../src/models/model_generator/clue.dart';
import '../src/models/model_generator/clue_detail.dart';
import '../src/models/model_generator/add_customer.dart';
import '../src/models/model_generator/base_response.dart';
import '../src/models/model_generator/contract.dart';
import '../src/models/model_generator/contract_customer.dart';
import '../src/models/model_generator/detail_product_module_response.dart';
import '../src/models/model_generator/get_infor.dart';
import '../src/models/model_generator/get_phone_cus.dart';
import '../src/models/model_generator/get_xe_response.dart';
import '../src/models/model_generator/group_product_response.dart';
import '../src/models/model_generator/list_car_response.dart';
import '../src/models/model_generator/list_product_response.dart';
import '../src/models/model_generator/param_del_notif.dart';
import '../src/models/model_generator/param_read_notifi.dart';
import '../src/models/model_generator/post_info_car_response.dart';
import '../src/models/model_generator/report_contact.dart';
import '../src/models/model_generator/report_general.dart';
import '../src/models/model_generator/report_option.dart';
import '../src/models/model_generator/report_product.dart';
import '../src/models/model_generator/response_save_product.dart';
import '../src/models/model_generator/support_customer.dart';
import '../src/models/model_generator/update_pass_request.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class UserRepository {
  var dio = DioProvider.dio;
  final _controller = StreamController<AuthenticationStatus>();
  final _controllerUser = StreamController<LoginData>();
  UserRepository() {
    if (shareLocal.getString(PreferencesKey.TOKEN) != '' ||
        shareLocal.getString(PreferencesKey.TOKEN) != null)
      DioProvider.instance(
          token: shareLocal.getString(PreferencesKey.TOKEN),
          sess: shareLocal.getString(PreferencesKey.SESS));
    else
      DioProvider.instance();
  }

  Future<ResponseDataStatus> getInfoUser() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getInfoUser();

  Future<FirstIntroResponse> getFirstIntro() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).firstIntroduce();

  Future<LogoResponse> getLogo() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getLogo();

  Future<ListNewsResponse> getListNews(
          {required int pageSize, required int currentPage}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getListNews(pageSize, currentPage);

  Future<ListDocumentsResponse> getListDocuments() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getListDocuments();

  Future<IntroduceResponse> getIntroduce() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getIntroduce();

  Future<CoursesResponse> getCourse() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getCourse();

  Future<DetailCoursesResponse> getDetailCourse(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getDetailCourse(id);

  Future<ListCustomerResponse> getListCustomer(
          int page, String filter, String search) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getListCustomer(page, filter, search);

  Future<ListChanceResponse> getListChance(
          int page, String filter, String search) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getListChance(page, filter, search);

  Future<DetailCustomerResponse> getDetailCustomer(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getDetailCustomer(id);

  Future<ClueCustomerResponse> getClueCustomer(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getClueCustomer(id);

  Future<ChanceCustomerResponse> getChanceCustomer(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getChanceCustomer(id);

  Future<ContractCustomerResponse> getContractCustomer(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getContractCustomer(id);

  Future<JobCustomerResponse> getJobCustomer(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getJobCustomer(id);

  Future<SupportCustomerResponse> getSupportCustomer(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getSupportCustomer(id);

  Future<ListDetailChanceResponse> getDetailSupport(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getDetailSupport(id);

  Future<ContractResponse> getListContract(
          int page, String search, String filter) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getListContract(page, search, filter);

  Future<SupportResponse> getListSupport(
          int page, String search, String filter) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getListSupport(page, search, filter);

  Future<AddCustomerIndividual> getAddCustomer(int isIndividual,
          {String? id}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getAddCustomer(isIndividual, id);

  Future<AddVoucherResponse> postAddServiceVoucher(
          String soDienThoai, String bienSo) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .postAddServiceVoucher(soDienThoai, bienSo);

  Future<InfoCar> postInfoCar(String idxe) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).postInfoCar(idxe);

  Future<dynamic> saveServiceVoucher(
          VoucherServiceRequest voucherServiceRequest) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .saveServiceVoucher(voucherServiceRequest);

  Future<ListCarInfo> getVersionInfoCar() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getVersionInfoCar();

  Future<PaymentContractResponse> getPaymentContract(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getPaymentContract(id);

  Future<JobChance> getJobContract(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getJobContract(id);

  Future<BaseResponse> deleteCustomer(Map<String, dynamic> id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).deleteCustomer(id);

  Future<JobChance> getJobChance(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getJobChance(id);

  Future<AddJobResponse> getAddJobChance(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getAddJobChance(id);

  Future<ListDetailChanceResponse> getListDetailChance(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getListDetailChance(id);

  Future<ListClueResponse> getListClue(
          int page, String filter, String search) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getListClue(page, filter, search);

  Future<DetailClue> getDetailClue(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getDetailClue(id);

  Future<WorkClueResponse> getWorkClue(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getWorkClue(id);

  Future<PolicyResponse> getPolicy() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getPolicy();

  Future<InforResponse> getInfor() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getInfor();

  Future<ListNoteClueResponse> getListNoteClue(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getNoteClue(id);

  Future<ListNotificationResponse> getListUnReadNotification(int page) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getListUnReadNotification(page);

  Future<ListNotificationResponse> getListReadedNotification(int page) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getListReadedNotification(page);

  Future<BaseResponse> deleteNotification(int id, String type) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .deleteNotifi(DelNotifiParam(id, type));

  Future<InforAccResponse> getInforAcc() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getInforAcc();

  Future<AddCustomerIndividual> getAddCusOr() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getAddCustomerOr();

  Future<TimeResponse> getReportOption() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getReportOption();

  Future<FilterResponse> getReportOption2() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getReportOption2();

  Future<DetailContractResponse> getDetailContract(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getDetailContract(id);

  Future<SupportContractResponse> getSupportContract(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getSupportContract(id);

  Future<WorkResponse> getListJob(
          String pageIndex, String text, String filter_id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getListJob(pageIndex, text, filter_id);

  Future<AddCustomerIndividual> getUpdateCustomer(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getUpdateCustomer(id);

  Future<BaseResponse> deleteContract(Map<String, dynamic> id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).deleteContract(id);

  Future<BaseResponse> deleteJob(Map<String, dynamic> id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).deleteJob(id);

  Future<DetailWorkResponse> detailJob(int id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).detailJob(id);

  Future<AddCustomerIndividual> getFormAddContactCus(
          String customer_id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getFormaddContactCus(customer_id);

  Future<AddCustomerIndividual> getFormAddOppCus(String customer_id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getFormAddOppCus(customer_id);

  Future<AddCustomerIndividual> getFormAddContractCus(
          String customer_id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getFormAddContractCus(customer_id);

  Future<AddCustomerIndividual> getFormAddJobCus(String customer_id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getFormAddJobCus(customer_id);

  Future<AddCustomerIndividual> getFormAddSupportCus(
          String customer_id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getFormAddSupportCus(customer_id);

  Future<AddCustomerIndividual> getFormAddAgency(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getFormAddAgency(id);

  Future<AddCustomerIndividual> getFormAddChance(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getFormAddChance(id);

  Future<AddCustomerIndividual> getFormAddContract(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getFormAddContract(id);

  Future<AddCustomerIndividual> getFormAddJob(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getFormAddJob(id);

  Future<AddCustomerIndividual> getFormAddSupport(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getFormAddSupport(id);

  Future<AddCustomerIndividual> getFormAddJobOpp(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getFormAddJobOpp(id);

  Future<AddCustomerIndividual> getFormAddJobChance(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getFormAddJobChance(id);

  Future<BaseResponse> deleteContact(Map<String, dynamic> id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).deleteContact(id);

  Future<BaseResponse> deleteChance(Map<String, dynamic> id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).deleteChance(id);

  Future<BaseResponse> deleteSupport(Map<String, dynamic> id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).deleteSupport(id);

  Future<BaseResponse> deleteNoteCus(String noteid, String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .deleteNoteCus({BASE_URL.NOTE_ID: noteid, BASE_URL.ID: id});

  Future<BaseResponse> deleteNoteContact(String noteid, String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .deleteNoteContact({BASE_URL.NOTE_ID: noteid, BASE_URL.ID: id});

  Future<BaseResponse> deleteNoteOop(String noteid, String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .deleteNoteOop({BASE_URL.NOTE_ID: noteid, BASE_URL.ID: id});

  Future<BaseResponse> deleteNoteContract(String noteid, String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .deleteNoteContract({BASE_URL.NOTE_ID: noteid, BASE_URL.ID: id});

  Future<BaseResponse> deleteNoteJob(String noteid, String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .deleteNoteJob({BASE_URL.NOTE_ID: noteid, BASE_URL.ID: id});

  Future<BaseResponse> deleteNoteSup(String noteid, String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .deleteNoteSup({BASE_URL.NOTE_ID: noteid, BASE_URL.ID: id});

  Future<AddCustomerIndividual> getFormEditClue(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getFormEditContact(id);

  Future<AddCustomerIndividual> getFormEditSupport(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getFormEditSupport(id);

  Future<AddCustomerIndividual> getFormEditContract(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getFormEditContract(id);

  Future<AddCustomerIndividual> getFormAddJobContract(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getFormAddJobContract(id);

  Future<AddCustomerIndividual> getFormAddSupportContract(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getFormAddSupportContract(id);

  Future<CustomerContractResponse> getCustomerContract(
          String page, String querySearch) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getCustomerContract(page, querySearch);

  Future<ContactByCustomerResponse> getContactByCustomer(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getContactByCustomer(id);

  Future<NoteResponse> getListNoteOpp(String id, String page) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getNoteOpp(id, page);

  Future<NoteResponse> getListNoteCus(String id, String page) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getNoteCus(id, page);

  Future<NoteResponse> getListNoteContact(String id, String page) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getNoteContact(id, page);

  Future<NoteResponse> getListNoteContract(String id, String page) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getNoteContract(id, page);

  Future<NoteResponse> getListNoteJob(String id, String page) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getNoteJob(id, page);

  Future<NoteResponse> getListNoteSup(String id, String page) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getNoteSup(id, page);

  Future<ProductResponse> getListProduct(
          String page, String querySearch) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .getListProduct(page, querySearch);

  Future<GetPhoneCusResponse> getPhoneCus(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getPhoneCus(id);

  Future<GetPhoneCusResponse> getPhoneAgency(String id) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getPhoneAgency(id);

  Future<BaseResponse> logout() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).logout();

  Future<LoginResponse> loginApp(
          {required String email,
          required String password,
          required String device_token,
          required String platform}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).loginApp(
          LoginAppRequest(
              email: email,
              password: password,
              device_token: device_token,
              platform: platform));

  Future<ResponseStatus> registerApp(
          {required String fullName,
          required String email,
          required String password}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).registerApp(
          RegisterAppRequest(
              fullname: fullName, email: email, password: password));

  Future<ResponseStatus> changePassword(
          {required ParamChangePassword paramChangePassword}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .changePassword(paramChangePassword);

  Future<ParamForgotPassword> forgotPassword(
          {required String email,
          required String username,
          required String timestamp}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).forgotPassword(
          ParamRequestForgotPassword(
              email: email, username: username, timestamp: timestamp));

  Future<BaseResponse> forgotPasswordOtp(
          {required String timestamp,
          required String code,
          required String email,
          required String username}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).forgotPasswordOtp(
          ParamRequestForgotPasswordOtp(
              timestamp: timestamp,
              code: code,
              email: email,
              username: username));

  Future<ContactReportResponse> reportContact(
          int? id, int? time, String? location, int? page, String? gt) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).reportContact(
          RequestBodyReport(
              id: id, diem_ban: location, time: time, page: page, gt: gt));

  Future<DataGeneralResponse> reportGeneral(
          int? time, String? location, int? page) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).reportGeneral(
          RequestBodyReport(
              diem_ban: location, time: time, page: page, id: null));

  Future<BaseResponse> resetPassword(
          {required String timestamp,
          required String newPass,
          required String email,
          required String username}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).resetPassword(
          ParamResetPassword(
              email: email,
              newPass: newPass,
              timestamp: timestamp,
              username: username));

  Future<ReportProductResponse> reportProduct(int time, String location,
          int? cl, String? timeFrom, String? timeTo) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).reportProduct(
          RequestBodyReportProduct(
              diem_ban: location,
              time: time,
              cl: cl,
              timefrom: timeFrom,
              timeto: timeTo));

  Future<DataEmployResponse> reportEmployee(
          int time, int? diem_ban, String? timefrom, String? timeto) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).reportEmployee(
          RequestEmployReport(
              diem_ban: diem_ban,
              time: time,
              timefrom: timefrom,
              timeto: timeto));

  Future<ResponseDataStatus> postUpdateProfile(
          {required ParamChangeInfo infoUser}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .postUpdateProfile(infoUser);

  Future<ResponseDataStatus> postUpdateProfileNotImage(
          {required ParamChangeInfoNotImage infoUser}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .postUpdateProfileNotImage(infoUser);

  Future<ResponseDataStatus> orderCourse(
          {required ParamOrderCourse paramOrderCourse}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .orderCourse(paramOrderCourse);

  Future<BaseResponse> updatePass(
          {required String username,
          required String oldpass,
          required String newpass}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).updatePass(
          UpdatePassRequest(
              username: username, oldpass: oldpass, newpass: newpass));

  Future<BaseResponse> changeInforAcc(
          {required String fullName,
          required String phone,
          required String email,
          required String address,
          required File avatar}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .changeInforAcc(fullName, email, phone, address, avatar);

  Future<BaseResponse> changeInforAccNoAvatar(
          {required String fullName,
          required String phone,
          required String email,
          required String address}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .changeInforAccNoAvatar(fullName, email, phone, address);

  Future<BaseResponse> readNotification(
          {required String id, required String type}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .readNotification(ReadNotifiParam(id, type));

  Future<AddDataResponse> addIndividualCustomer(
          {required Map<String, dynamic> data}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .addIndividualCustomer(data);

  Future<AddDataResponse> addOrganizationCustomer(
          {required Map<String, dynamic> data}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .addOrganizationCustomer(data);

  Future<EditCusResponse> editCustomer(
          {required Map<String, dynamic> data}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).editCustomer(data);

  Future<AddDataResponse> addContactCus(
          {required Map<String, dynamic> data}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).addContactCus(data);

  Future<AddDataResponse> addOpportunity(
          {required Map<String, dynamic> data}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).addOpportunity(data);

  Future<AddDataResponse> addContract(
          {required Map<String, dynamic> data}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).addContract(data);

  Future<AddDataResponse> addJob({required Map<String, dynamic> data}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).addJob(data);

  Future<AddDataResponse> addSupport(
          {required Map<String, dynamic> data}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).addSupport(data);

  Future<AddDataResponse> editJob({required Map<String, dynamic> data}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).saveUpdateJob(data);

  Future<BaseResponse> addNoteCus(
          {required String id, required String content}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .addNoteCus(id, content);

  Future<BaseResponse> addNoteContact(
          {required String id, required String content}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .addNoteContact(id, content);

  Future<BaseResponse> addNoteOpp(
          {required String id, required String content}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .addNoteOpp(id, content);

  Future<BaseResponse> addNoteContract(
          {required String id, required String content}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .addNoteContract(id, content);

  Future<BaseResponse> addNoteJob(
          {required String id, required String content}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .addNoteJob(id, content);

  Future<BaseResponse> addNoteSup(
          {required String id, required String content}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .addNoteSup(id, content);

  Future<BaseResponse> editNoteCus(
          {required String id,
          required String content,
          required String noteId}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).editNoteCus({
        BASE_URL.ID: id,
        BASE_URL.CONTENT: content,
        BASE_URL.NOTE_ID: noteId
      });

  Future<BaseResponse> editNoteContact(
          {required String id,
          required String content,
          required String noteId}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).editNoteContact({
        BASE_URL.ID: id,
        BASE_URL.CONTENT: content,
        BASE_URL.NOTE_ID: noteId
      });

  Future<BaseResponse> editNoteOop(
          {required String id,
          required String content,
          required String noteId}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).editNoteOop({
        BASE_URL.ID: id,
        BASE_URL.CONTENT: content,
        BASE_URL.NOTE_ID: noteId
      });

  Future<BaseResponse> editNoteContract(
          {required String id,
          required String content,
          required String noteId}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).editNoteContract({
        BASE_URL.ID: id,
        BASE_URL.CONTENT: content,
        BASE_URL.NOTE_ID: noteId
      });

  Future<BaseResponse> editNoteJob(
          {required String id,
          required String content,
          required String noteId}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).editNoteJob({
        BASE_URL.ID: id,
        BASE_URL.CONTENT: content,
        BASE_URL.NOTE_ID: noteId
      });

  Future<BaseResponse> editNoteSup(
          {required String id,
          required String content,
          required String noteId}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).editNoteSup({
        BASE_URL.ID: id,
        BASE_URL.CONTENT: content,
        BASE_URL.NOTE_ID: noteId
      });

  Future<BaseResponse> uploadMultiFileBase({
    required String id,
    required List<File> files,
    required String module,
    bool? isAfter,
  }) async {
    final multipartFiles = <MultipartFile>[];
    if (files.isNotEmpty) {
      for (final file in files) {
        final fileBytes = await file.readAsBytes();
        final multipartFile = MultipartFile.fromBytes(
          fileBytes,
          filename: file.path.split('/').last,
        );
        multipartFiles.add(multipartFile);
      }
    }
    return await RestClient(dio, baseUrl: dio.options.baseUrl)
        .uploadMultiFile(id, multipartFiles, module, isAfter);
  }

  Future<BaseResponse> uploadFile({
    required String id,
    required File files,
    required bool isAfter,
    required String module,
  }) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl)
          .uploadFile(id, files, isAfter, module);

  Future<FileResponse> getFile({
    required String module,
    required int id,
  }) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getFile(module, id);

  Future<dynamic> deleteFile({
    required String id,
  }) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).deleteFile(id);

  Future<GetXeResponse> getXe({
    required String id,
  }) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getXe(id);

  Future<GroupProductResponse> getGroupProduct() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getGroupProduct();

  Future<ListProductResponse> getListProductModule({
    String? typeProduct,
    String? txt,
    required String page,
    String? filter,
  }) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getListProductModule(
        typeProduct,
        txt,
        page,
        filter,
      );

  Future<DetailProductResponse> getDetailProduct({
    required String id,
  }) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getDetailProduct(id);

  Future<AddCustomerIndividual> getFormAddProduct() async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getFormAddProduct();

  Future<AddCustomerIndividual> getEditProduct({
    required String id,
  }) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).getEditProduct(id);

  Future<ResponseSaveProduct> addProduct(
          {required Map<String, dynamic> data}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).addProduct(data);

  Future<ResponseSaveProduct> editProduct(
          {required Map<String, dynamic> data, required int id}) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).editProduct(data, id);

  Future<dynamic> deleteProduct({
    required String id,
  }) async =>
      await RestClient(dio, baseUrl: dio.options.baseUrl).deleteProduct(id);

  //////////////////////

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Stream<LoginData> get statusUser async* {
    yield* _controllerUser.stream;
  }

  void logOut() => _controller.add(AuthenticationStatus.unauthenticated);

  void addUser(LoginData user) => _controllerUser.add(user);

  void dispose() {
    _controllerUser.close();
    _controller.close();
  }
}
