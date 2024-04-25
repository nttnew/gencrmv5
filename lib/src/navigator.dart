import 'package:get/get.dart';
import 'package:gen_crm/src/router.dart';
import '../l10n/key_text.dart';
import '../models/product_model.dart';
import 'app_const.dart';
import 'models/model_generator/xe_dich_vu_response.dart';

class AppNavigator {
  AppNavigator._();

  static navigateBack({bool? reload}) async => Get.back(result:reload);

  static navigateSplash() async => await Get.toNamed(ROUTE_NAMES.SPLASH);

  static navigateLogin() async =>
      await Get.toNamed(ROUTE_NAMES.LOGIN, arguments: 'login');

  static navigateDetailSupport(
    String id,{Function? onRefreshForm}
  ) async =>
      await Get.toNamed(
        ROUTE_NAMES.DETAIL_SUPPORT,
        arguments: id,
      )?.then(
            (v) {
          if (onRefreshForm != null && v != null) onRefreshForm();
          return v;
        },
      );

  static navigateDetailWork(
    int id,{Function? onRefreshForm}
  ) async =>
      await Get.toNamed(
        ROUTE_NAMES.DETAIL_WORK,
        arguments: id,
      )?.then(
            (v) {
          if (onRefreshForm != null && v != null) onRefreshForm();
          return v;
        },
      );

  static navigateForm({
    String? title,
    required String type,
    int? id,
    String? sdt,
    String? bienSo,
    bool isCheckIn = false,
    String typeCheckIn = TypeCheckIn.CHECK_IN,
    bool isGetData = false, //getdata cho khsp
    Function? onRefreshForm,
    bool isPreventDuplicates = false,
    ProductModel? product,
    String? idDetail,
    String? idPay,
  }) async =>
      await Get.toNamed(ROUTE_NAMES.FORM_ADD,
          preventDuplicates: isPreventDuplicates,
          arguments: [
            title ?? getT(KeyT.edit_information),
            type,
            id,
            isCheckIn,
            typeCheckIn,
            isGetData,
            product,
            sdt,
            bienSo,
            idDetail,
            idPay,
          ])?.then(
        (v) {
          if (onRefreshForm != null && v != null) onRefreshForm();
          return v;
        },
      );

  static navigateAddWork() async => await Get.toNamed(ROUTE_NAMES.ADD_WORK);

  static navigateDetailCustomer(
    String id,
  ) async =>
      await Get.toNamed(
        ROUTE_NAMES.DETAIL_CUSTOMER,
        arguments: id,
      );

  static navigateAddSupport() async =>
      await Get.toNamed(ROUTE_NAMES.ADD_SUPPORT);

  static navigateLogout() async =>
      await Get.offAllNamed(ROUTE_NAMES.LOGIN, arguments: 'logout');

  static navigateMain({dynamic data}) async =>
      await Get.offAllNamed(ROUTE_NAMES.MAIN, arguments: data);

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

  static navigateReport() async => await Get.toNamed(ROUTE_NAMES.REPORT);

  static navigateCustomer() async => await Get.toNamed(ROUTE_NAMES.CUSTOMER);

  static navigateClue() async => await Get.toNamed(ROUTE_NAMES.CLUE);

  static navigateDetailClue(
    String id,
  {Function? onRefreshForm}
  ) async =>
      await Get.toNamed(
        ROUTE_NAMES.INFO_CLUE,
        arguments: id,
      )?.then(
            (v) {
          if (onRefreshForm != null && v != null) onRefreshForm();
          return v;
        },
      );

  static navigateAddClue() async => await Get.toNamed(ROUTE_NAMES.ADD_CLUE);

  static navigateCall({
    required String title,
  }) async =>
      await Get.toNamed(
        ROUTE_NAMES.CALL,
        arguments: title,
      );

  static navigateContract() async => await Get.toNamed(ROUTE_NAMES.CONTRACT);

  static navigateDetailContract(
    String id,{Function? onRefreshForm}
  ) async =>
      await Get.toNamed(
        ROUTE_NAMES.INFO_CONTRACT,
        arguments: id,
      )?.then(
            (v) {
          if (onRefreshForm != null && v != null) onRefreshForm();
          return v;
        },
      );

  static navigateSupport() async => await Get.toNamed(ROUTE_NAMES.SUPPORT);

  static navigateChance() async => await Get.toNamed(ROUTE_NAMES.CHANCE);

  static navigateAddChance(String id) async =>
      await Get.toNamed(ROUTE_NAMES.ADD_CHANCE, arguments: id);

  static navigateDetailChance(
    String id,
  {Function? onRefreshForm}
  ) async =>
      await Get.toNamed(
        ROUTE_NAMES.INFO_CHANCE,
        arguments: id,
      )?.then(
            (v) {
          if (onRefreshForm != null && v != null) onRefreshForm();
          return v;
        },
      );

  static navigateWork() async => await Get.toNamed(
        ROUTE_NAMES.WORK,
      );

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

  static navigateProduct() async => await Get.toNamed(
        ROUTE_NAMES.PRODUCT,
      );

  static navigateDetailProduct(String id) async => await Get.toNamed(
        ROUTE_NAMES.DETAIL_PRODUCT,
        arguments: id,
      );

  static navigateCheckIn(
    String id,
    String module,
    String type, {
    Function? onRefreshCheckIn,
  }) async =>
      await Get.toNamed(ROUTE_NAMES.CHECK_IN, arguments: [id, module, type])
          ?.then((v) {
        if (onRefreshCheckIn != null && v != null) onRefreshCheckIn();
        return v;
      });

  static navigateProductCustomer() async => await Get.toNamed(
        ROUTE_NAMES.PRODUCT_CUSTOMER,
      );

  static navigateDetailProductCustomer(String id) async => await Get.toNamed(
        ROUTE_NAMES.DETAIL_PRODUCT_CUSTOMER,
        arguments: id,
      );

  static navigateFormSign(
    String title,
    String id, {
    String type = '',
    Function? onRefreshForm,
  }) async =>
      await Get.toNamed(ROUTE_NAMES.FORM_SIGN, arguments: [
        title,
        id,
        type,
      ])?.then(
        (v) {
          if (onRefreshForm != null && v != null) onRefreshForm();
          return v;
        },
      );

  static navigateListServicePark(
    Function add,
    Function reload,
    List<ProductModel> data,
    String title,
  ) async =>
      await Get.toNamed(ROUTE_NAMES.LIST_SERVICE_PARK, arguments: [
        add,
        reload,
        data,
        title,
      ]);

  static navigateInPhieu({required String link}) async => await Get.toNamed(
        ROUTE_NAMES.IN_PHIEU,
        arguments: [link],
      );

  static navigateBieuMau({
    required String idDetail,
  }) async =>
      await Get.toNamed(
        ROUTE_NAMES.LIST_BIEU_MAU,
        arguments: [idDetail],
      );

  static navigateDetailCarMain(XeDichVu detail) async => await Get.toNamed(
        ROUTE_NAMES.DETAIL_CAR_MAIN,
        arguments: detail,
      );
}
