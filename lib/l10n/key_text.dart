import 'dart:convert';

import '../src/preferences_key.dart';
import '../storages/share_local.dart';

String getT(String key) {
  final dataLang =
      jsonDecode(shareLocal.getString(PreferencesKey.LANGUAGE_BE_ALL));
  final lang = shareLocal.getString(PreferencesKey.LANGUAGE_NAME) ??
      'english'; //default build app
  return dataLang[lang][key];
}

class KeyT {
  static const String unknown = "unknown";
  static const String add_new_car = "add_new_car";
  static const String login = "login";
  static const String email = "email";
  static const String password = "password";
  static const String forgot_password = "forgot_password";
  static const String register = "register";
  static const String notification = "notification";
  static const String change_password = "change_password";
  static const String logout = "logout";
  static const String continue_my = "continue_my";
  static const String processing_the_request = "processing_the_request";
  static const String please_wait_a_moment = "please_wait_a_moment";
  static const String success = "success";
  static const String fail = "fail";
  static const String warning = "warning";
  static const String this_account_is_invalid = "this_account_is_invalid";
  static const String invalid_phone_number = "invalid_phone_number";
  static const String password_must_be_at_least_6_characters =
      "password_must_be_at_least_6_characters";
  static const String name_cannot_be_left_blank = "name_cannot_be_left_blank";
  static const String login_has_expired = "login_has_expired";
  static const String press_again_to_exit = "press_again_to_exit";
  static const String full_name = "full_name";
  static const String account_information = "account_information";
  static const String policy_terms = "policy_terms";
  static const String save = "save";
  static const String home_page = "home_page";
  static const String introduce = "introduce";
  static const String enter_full_name = "enter_full_name";
  static const String enter_your_email = "enter_your_email";
  static const String enter_your_password = "enter_your_password";
  static const String login_session_expired_please_login_again =
      "login_session_expired_please_login_again";
  static const String ok = "ok";
  static const String new_photo_shoot = "new_photo_shoot";
  static const String new_video_recoding = "new_video_recoding";
  static const String pick_file = "pick_file";
  static const String pick_photo = "pick_photo";
  static const String go_to_setting = "go_to_setting";
  static const String you_have_not_granted_access_to_photos =
      "you_have_not_granted_access_to_photos";
  static const String an_error_occurred = "an_error_occurred";
  static const String enter_number_phone_or_license_plates =
      "enter_number_phone_or_license_plates";
  static const String phone = "phone";
  static const String enter_phone = "enter_phone";
  static const String license_plates = "license_plates";
  static const String enter_license_plates = "enter_license_plates";
  static const String you_must_enter_your_phone_number_or_license_plates =
      "you_must_enter_your_phone_number_or_license_plates";
  static const String check = "check";
  static const String add_success = "add_success";
  static const String please_enter_all_required_fields =
      "please_enter_all_required_fields";
  static const String select = "select";
  static const String go = "go";
  static const String cancel = "cancel";
  static const String preview_image = "preview_image";
  static const String car_brand = "car_brand";
  static const String car_series = "car_series";
  static const String version = "version";
  static const String year_of_manufacture = "year_of_manufacture";
  static const String car_class = "car_class";
  static const String style = "style";
  static const String close = "close";
  static const String number_seats = "number_seats";
  static const String call_operator = "call_operator";
  static const String call_ended = "call_ended";
  static const String account_verification = "account_verification";
  static const String please_enter_the_otp_sent_to_the_email =
      "please_enter_the_otp_sent_to_the_email";
  static const String have_not_received_the_code = "have_not_received_the_code";
  static const String send_again = "send_again";
  static const String confirm = "confirm";
  static const String verification_codes = "verification_codes";
  static const String update_password_successful = "update_password_successful";
  static const String update_password = "update_password";
  static const String enter_a_new_password_to_log_into_your_account =
      "enter_a_new_password_to_log_into_your_account";
  static const String password_not_match = "password_not_match";
  static const String completed = "completed";
  static const String enter_password_again = "enter_password_again";
  static const String please_enter_email_register_account =
      "please_enter_email_register_account";
  static const String user = "user";
  static const String change_address_application = "change_address_application";
  static const String check_the_information = "check_the_information";
  static const String account = "account";
  static const String print_finger_face_id = "print_finger_face_id";
  static const String login_with_fingerprint_face_id =
      "login_with_fingerprint_face_id";
  static const String begin = "begin";
  static const String after = "after";
  static const String you_have_not_granted_permission_to_access_the_photo =
      "you_have_not_granted_permission_to_access_the_photo";
  static const String add_attachment = "add_attachment";
  static const String delete_attachment = "delete_attachment";
  static const String see_attachment = "see_attachment";
  static const String select_attachment = "select_attachment";
  static const String no_data = "no_data";
  static const String add = "add";
  static const String individual = "individual";
  static const String organization = "organization";
  static const String new_data_added_successfully =
      "new_data_added_successfully";
  static const String the_amount_paid_cannot_be_greater_than_the_total_amount =
      "the_amount_paid_cannot_be_greater_than_the_total_amount";
  static const String discuss = "discuss";
  static const String come_back = "come_back";
  static const String enter_content = "enter_content";
  static const String check_in = "check_in";
  static const String your_position = "your_position";
  static const String check_in_again = "check_in_again";
  static const String delete = "delete";
  static const String location = "location";
  static const String edit_information = "edit_information";
  static const String update_data_successfully = "update_data_successfully";
  static const String click_to_sign = "click_to_sign";
  static const String unpaid = "unpaid";
  static const String the_amount_cannot_be_greater_than_the_outstanding_amount =
      "the_amount_cannot_be_greater_than_the_outstanding_amount";
  static const String rate_star_please = "rate_star_please";
  static const String not_yet = "not_yet";
  static const String find = "find";
  static const String add_discuss = "add_discuss";
  static const String edit = "edit";
  static const String information = "information";
  static const String are_you_sure_you_want_to_delete =
      "are_you_sure_you_want_to_delete";
  static const String total_amount = "total_amount";
  static const String select_product = "select_product";
  static const String find_product = "find_product";
  static const String code_product = "code_product";
  static const String price = "price";
  static const String dvt = "dvt";
  static const String vat = "vat";
  static const String sale = "sale";
  static const String enter_price_sale = "enter_price_sale";
  static const String
      you_cannot_enter_a_discount_greater_than_the_price_of_the_product =
      "you_cannot_enter_a_discount_greater_than_the_price_of_the_product";
  static const String you_cannot_enter_more_than_100 =
      "you_cannot_enter_more_than_100";
  static const String enter = "enter";
  static const String enter_price = "enter_price";
  static const String sign = "sign";
  static const String pay = "pay";
  static const String call = "call";
  static const String detail = "detail";
  static const String unread = "unread";
  static const String readed = "readed";
  static const String delete_success = "delete_success";
  static const String enter_name_barcode_qr_code = "enter_name_barcode_qr_code";
  static const String select_filter = "select_filter";
  static const String pick_filter = "pick_filter";
  static const String sales = "sales";
  static const String real_revenue = "real_revenue";
  static const String number_contract = "number_contract";
  static const String report = "report";
  static const String turn_over = "turn_over";
  static const String sales_product = "sales_product";
  static const String employee_turnover = "employee_turnover";
  static const String all_company = "all_company";
  static const String all = "all";
  static const String hide_details = "hide_details";
  static const String undefined = "undefined";
  static const String contract = "contract";
  static const String done = "done";
  static const String car = "car";
  static const String check_out = "check_out";
  static const String enter_current_password = "enter_current_password";
  static const String current_password = "current_password";
  static const String enter_your_new_password = "enter_your_new_password";
  static const String new_password = "new_password";
  static const String avatar = "avatar";
  static const String number_phone = "number_phone";
  static const String address = "address";
  static const String no = "no";
  static const String yes = "yes";
  static const String login_fail_please_try_again =
      "login_fail_please_try_again";
  static const String the_device_has_not_setup_fingerprint_face =
      "the_device_has_not_setup_fingerprint_face";
  static const String doing = "doing";
  static const String client = "client";
  static const String action = "action";
  static const String copy_success = "copy_success";
  static const String copy = "copy";
  static const String select_type = "select_type";
  static const String you_can_only_choose = "you_can_only_choose";
  static const String value = "value";
  static const String sign_again = "sign_again";
  static const String you_have_not_done_the_sign_yet =
      "you_have_not_done_the_sign_yet";
  static const String electronic_signature = "electronic_signature";
  static const String have_not_granted_location_access =
      "have_not_granted_location_access";
  static const String number = "number";
  static const String are_you_sure_you_want_to_sign_out =
      "are_you_sure_you_want_to_sign_out";
  static const String agree = "agree";
  static const String enter_address_application_below =
      "enter_address_application_below";
  static const String this_email_is_invalid = "this_email_is_invalid";
  static const String turn_on_login_with_finger_print_faceid =
      "turn_on_login_with_finger_print_faceid";
  static const String you_did_not_enter_a_number_phone =
      "you_did_not_enter_a_number_phone";
  static const String enter_the_quantity = "enter_the_quantity";
  static const String search = "search";
  static const String into_money = "into_money";
  static const String count_product_validate = "count_product_validate";
  static const String already_exist = "already_exist";
  static const String validate_address_app = "validate_address_app";
}
