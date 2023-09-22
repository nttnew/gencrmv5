import 'package:get/get.dart';
import 'package:gen_crm/src/router.dart';

import '../models/product_model.dart';
import 'app_const.dart';

class AppNavigator {
  AppNavigator._();

  static navigateBack() async => Get.back();

  static navigateSplash() async => await Get.toNamed(ROUTE_NAMES.SPLASH);

  static navigateLogin() async =>
      await Get.toNamed(ROUTE_NAMES.LOGIN, arguments: 'login');

  static navigateDetailSupport(String id, String title) async =>
      await Get.toNamed(ROUTE_NAMES.DETAIL_SUPPORT, arguments: [id, title]);

  static navigateDetailWork(
    int id,
    String title,
  ) async =>
      await Get.toNamed(ROUTE_NAMES.DETAIL_WORK, arguments: [id, title]);

  static navigateAddCustomer(
    String title, {
    bool isResultData = false,
  }) async =>
      await Get.toNamed(ROUTE_NAMES.ADD_CUSTOMER,
          arguments: [title, isResultData]);

  static navigateAddServiceVoucherStepTwo(String title) async =>
      await Get.toNamed(ROUTE_NAMES.ADD_SERVICE_VOUCHER_STEP_TWO,
          arguments: title);

  static navigateFormAdd(
    String title,
    int type, {
    int? id,
    bool isCheckIn = false,
    String typeCheckIn = TypeCheckIn.CHECK_IN,
    bool isResultData = false,
    bool isGetData = false, //getdata cho khsp
    Function? onRefresh,
  }) async =>
      await Get.toNamed(ROUTE_NAMES.FORM_ADD, arguments: [
        title,
        type,
        id,
        isCheckIn,
        typeCheckIn,
        isResultData,
        isGetData,
      ])?.whenComplete(() {
        if (onRefresh != null) onRefresh();
      });

  static navigateFormAddCustomerGroup(
    String title,
    int type, {
    int? id,
    bool isCheckIn = false,
    String typeCheckIn = TypeCheckIn.CHECK_IN,
    bool isResultData = false,
    bool isGetData = false, //getdata cho khsp
  }) async =>
      await Get.toNamed(ROUTE_NAMES.FORM_ADD_CUSTOMER_GROUP, arguments: [
        title,
        type,
        id,
        isCheckIn,
        typeCheckIn,
        isResultData,
        isGetData,
      ]);

  static navigateAddWork() async => await Get.toNamed(ROUTE_NAMES.ADD_WORK);

  static navigateDetailCustomer(String id, String name) async =>
      await Get.toNamed(ROUTE_NAMES.DETAIL_CUSTOMER, arguments: [id, name]);

  static navigateAddSupport() async =>
      await Get.toNamed(ROUTE_NAMES.ADD_SUPPORT);

  static navigateLogout() async =>
      await Get.offAllNamed(ROUTE_NAMES.LOGIN, arguments: 'logout');

  static navigateMain({dynamic data}) async =>
      await Get.offAllNamed(ROUTE_NAMES.MAIN, arguments: data);

  static navigateIntro() async => await Get.offAllNamed(ROUTE_NAMES.INTRO);

  static navigateForgotPassword() async =>
      await Get.toNamed(ROUTE_NAMES.FORGOT_PASSWORD);

  static navigateForgotPasswordOTP(email, username) async =>
      await Get.toNamed(ROUTE_NAMES.FORGOT_PASSWORD_OTP,
          arguments: [email, username]);

  static navigateForgotPasswordReset(email, username) async =>
      await Get.toNamed(ROUTE_NAMES.FORGOT_PASSWORD_RESET,
          arguments: [email, username]);

  static navigateChangePassword() async =>
      await Get.toNamed(ROUTE_NAMES.CHANGE_PASSWORD);

  static navigateInformationAccount() async =>
      await Get.toNamed(ROUTE_NAMES.INFORMATION_ACCOUNT);

  static navigateReport(String money) async =>
      await Get.toNamed(ROUTE_NAMES.REPORT, arguments: money);

  static navigateCustomer(String name) async =>
      await Get.toNamed(ROUTE_NAMES.CUSTOMER, arguments: name);

  static navigateClue(String name) async =>
      await Get.toNamed(ROUTE_NAMES.CLUE, arguments: name);

  static navigateInfoClue(String id, String name) async =>
      await Get.toNamed(ROUTE_NAMES.INFO_CLUE, arguments: [id, name]);

  static navigateAddClue() async => await Get.toNamed(ROUTE_NAMES.ADD_CLUE);

  static navigateCall({required String title}) async =>
      await Get.toNamed(ROUTE_NAMES.CALL, arguments: title);

  static navigateContract(String name) async =>
      await Get.toNamed(ROUTE_NAMES.CONTRACT, arguments: name);

  static navigateAddContract({
    String? id,
    String? customer_id,
    required String title,
    Function? onRefresh,
    ProductModel? product,
  }) async =>
      await Get.toNamed(ROUTE_NAMES.ADD_CONTRACT,
          arguments: [id, customer_id, title, product])?.whenComplete(() {
        if (onRefresh != null) onRefresh();
      });

  static navigateInfoContract(String id, String name) async =>
      await Get.toNamed(ROUTE_NAMES.INFO_CONTRACT, arguments: [id, name]);

  static navigateSupport(String name) async =>
      await Get.toNamed(ROUTE_NAMES.SUPPORT, arguments: name);

  static navigateChance(String name) async =>
      await Get.toNamed(ROUTE_NAMES.CHANCE, arguments: name);

  static navigateAddChance(String id) async =>
      await Get.toNamed(ROUTE_NAMES.ADD_CHANCE, arguments: id);

  static navigateInfoChance(String id, String name) async =>
      await Get.toNamed(ROUTE_NAMES.INFO_CHANCE, arguments: [id, name]);

  static navigateWork(String name) async =>
      await Get.toNamed(ROUTE_NAMES.WORK, arguments: name);

  static navigateAboutUs() async => await Get.toNamed(ROUTE_NAMES.ABOUT_US);

  static navigatePolicy() async => await Get.toNamed(ROUTE_NAMES.POLICY);

  static navigateChangeInformationAccount(arguments) async =>
      await Get.toNamed(ROUTE_NAMES.CHANGE_INFORMATION_ACCOUNT,
          arguments: arguments);

  static navigateDetailNew(arguments) async =>
      await Get.toNamed(ROUTE_NAMES.DETAIL_NEW, arguments: arguments);

  static navigateDetailDocument(arguments) async =>
      await Get.toNamed(ROUTE_NAMES.DETAIL_DOCUMENT, arguments: arguments);

  static navigateEditInfo(arguments) async =>
      await Get.toNamed(ROUTE_NAMES.EDIT_INFO, arguments: arguments);

  static navigateSearch() async => await Get.toNamed(ROUTE_NAMES.SEARCH_SCREEN);

  static navigateCourseDetailScreen(arguments) async =>
      await Get.toNamed(ROUTE_NAMES.COURSE_DETAIL_SCREEN, arguments: arguments);

  static navigateBuyCourseScreen(arguments) async =>
      await Get.toNamed(ROUTE_NAMES.BUY_COURSE, arguments: arguments);

  static navigateEditDataScreen(String id, int type,
          {Function? onRefresh}) async =>
      await Get.toNamed(ROUTE_NAMES.FORM_EDIT, arguments: [id, type])
          ?.whenComplete(() {
        if (onRefresh != null) onRefresh();
      });

  static navigateEditContractScreen(String id, {Function? onRefresh}) async =>
      await Get.toNamed(ROUTE_NAMES.EDIT_CONTRACT, arguments: id)
          ?.whenComplete(() {
        if (onRefresh != null) onRefresh();
      });

  static navigateAddNoteScreen(String module, String id,
          {Function? onRefresh}) async =>
      await Get.toNamed(ROUTE_NAMES.ADD_NOTE, arguments: [module, id])
          ?.whenComplete(() {
        if (onRefresh != null) onRefresh();
      });

  static navigateNotification() async =>
      await Get.toNamed(ROUTE_NAMES.NOTIFICATION);

  static navigateAddProduct(
          Function add, Function reload, List<ProductModel> data,
          {String? group}) async =>
      await Get.toNamed(ROUTE_NAMES.ADD_PRODUCT,
          arguments: [add, reload, data, group]);

  static navigateProduct(String title) async =>
      await Get.toNamed(ROUTE_NAMES.PRODUCT, arguments: title);

  static navigateDetailProduct(String title, String id) async =>
      await Get.toNamed(ROUTE_NAMES.DETAIL_PRODUCT, arguments: [title, id]);

  static navigateCheckIn(String id, String module, String type,
          {Function? onRefresh}) async =>
      await Get.toNamed(ROUTE_NAMES.CHECK_IN, arguments: [id, module, type])
          ?.whenComplete(() {
        if (onRefresh != null) onRefresh();
      });

  static navigateProductCustomer(String title) async =>
      await Get.toNamed(ROUTE_NAMES.PRODUCT_CUSTOMER, arguments: title);

  static navigateDetailProductCustomer(String title, String id) async =>
      await Get.toNamed(ROUTE_NAMES.DETAIL_PRODUCT_CUSTOMER,
          arguments: [title, id]);

  static navigateFormSign(
    String title,
    String id,
  ) async =>
      await Get.toNamed(ROUTE_NAMES.FORM_SIGN, arguments: [title, id]);

  static navigateListServicePark(Function add, Function reload,
          List<ProductModel> data, String title) async =>
      await Get.toNamed(ROUTE_NAMES.LIST_SERVICE_PARK,
          arguments: [add, reload, data, title]);
}
