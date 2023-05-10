import 'package:get/get.dart';
import 'package:gen_crm/src/router.dart';

import '../models/product_model.dart';

class AppNavigator {
  AppNavigator._();

  static navigateBack() async => Get.back();

  static navigateSplash() async => await Get.toNamed(ROUTE_NAMES.SPLASH);

  static navigateLogin() async =>
      await Get.toNamed(ROUTE_NAMES.LOGIN, arguments: 'login');

  static navigateDetailWork() async =>
      await Get.toNamed(ROUTE_NAMES.DETAIL_WORK);

  static navigateDeatailSupport(String id, String title) async =>
      await Get.toNamed(ROUTE_NAMES.DETAIL_SUPPORT, arguments: [id, title]);

  static navigateDeatailWork(int id, String title) async =>
      await Get.toNamed(ROUTE_NAMES.DETAIL_WORK, arguments: [id, title]);

  static navigateAddCustomer() async =>
      await Get.toNamed(ROUTE_NAMES.ADD_CUSTOMER);

  // static navigateAddServiceVoucher() async =>
  //     await Get.toNamed(ROUTE_NAMES.ADDSERVICEVOUCHER);

  static navigateAddServiceVoucherStepTwo(String title) async =>
      await Get.toNamed(ROUTE_NAMES.ADD_SERVICE_VOUCHER_STEP_TWO,
          arguments: title);

  static navigateFormAdd(String title, int type,
          {int? id, bool isCheckIn = false}) async =>
      await Get.toNamed(ROUTE_NAMES.FORM_ADD,
          arguments: [title, type, id, isCheckIn]);

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

  static navigateContract(String name) async =>
      await Get.toNamed(ROUTE_NAMES.CONTRACT, arguments: name);

  static navigateAddContract(
          {String? id, String? customer_id, required String title}) async =>
      await Get.toNamed(ROUTE_NAMES.ADD_CONTRACT,
          arguments: [id, customer_id, title]);

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

  static navigateEditDataScreen(String id, int type) async =>
      await Get.toNamed(ROUTE_NAMES.FORM_EDIT, arguments: [id, type]);

  static navigateEditContractScreen(String id) async =>
      await Get.toNamed(ROUTE_NAMES.EDIT_CONTRACT, arguments: id);

  static navigateAddNoteScreen(int type, String id) async =>
      await Get.toNamed(ROUTE_NAMES.ADD_NOTE, arguments: [type, id]);

  static navigateNotification() async =>
      await Get.toNamed(ROUTE_NAMES.NOTIFICATION);

  static navigateAddProduct(
          Function add, Function reload, List<ProductModel> data) async =>
      await Get.toNamed(ROUTE_NAMES.ADD_PRODUCT,
          arguments: [add, reload, data]);

  static navigateProduct(String title) async =>
      await Get.toNamed(ROUTE_NAMES.PRODUCT, arguments: title);

  static navigateDetailProduct(String title, String id) async =>
      await Get.toNamed(ROUTE_NAMES.DETAIL_PRODUCT, arguments: [title, id]);

  static navigateCheckIn() async =>
      await Get.toNamed(ROUTE_NAMES.CHECK_IN);
}
