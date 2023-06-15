import 'dart:ui';
import 'icon_constants.dart';

class BASE_URL {
  BASE_URL._();
  static const int SIZE_DEFAULT = 10; //todo
  static const int PAGE_DEFAULT = 1; //todo
  static const URL_WSS = 'wss://wss-mobile.tel4vn.com:7444'; //todo
  static const URL_DEMO = 'https://car.gencrm.com/';
  static const GET_INFO_USER = 'api/user/profile';
  static const LOGIN = 'loginmobile.php';
  static const LOGOUT = 'lougoutmobile.php';
  static const REGISTER = 'api/user/register-user';
  static const PROFILE = 'api/user/profile';
  static const EDIT_PROFILE = 'api/user/update-info-user';
  static const CHANGE_PASSWORD = 'api/user/change-password';
  static const OTP_RESET_PASSWORD = 'api/user/vertify-otp';
  static const FIRST_INTRODUCE = 'api/user/introductions';
  static const INTRODUCE = 'api/user/introductions2';
  static const GET_LOGO = 'api/user/config-logo';
  static const GET_LIST_NEW = 'api/user/news';
  static const GET_LIST_DOCUMENTS = 'api/user/documentations';
  static const GET_LIST_COURSE = 'api/user/list-course';
  static const DETAIL_COURSE = 'api/user/detail-course';
  static const ORDER_COURSE = 'api/user/order';
  static const ABOUT_US = 'modules/genmobile2/app/getinfo';
  static const REPORT_EMPLOYEE =
      'modules/genmobile2/dashboard/baocaodoanhsoNhanvien';
  static const REPORT_PRODUCT =
      'modules/genmobile2/dashboard/baocaoDoanhsoSanpham';
  static const FORGOT_PASSWORD = 'modules/genmobile2/helper/validUser';
  static const FORGOT_PASSWORD_OTP = 'modules/genmobile2/helper/validCode';
  static const RESET_PASSWORD = 'modules/genmobile2/helper/updatePass';
  static const LIST_CHANCE = 'modules/genmobile2/opportunity/list';
  static const LIST_DETAIL_CHANCE = 'modules/genmobile2/opportunity/detail';
  static const JOB_CHANCE = 'modules/genmobile2/opportunity/listJob';
  static const ADD_JOB_CHANCE = 'modules/genmobile2/opportunity/addJob';
  static const REPORT_OPTIONS = 'modules/genmobile2/dashboard/getParamsBcDs';
  static const REPORT_OPTIONS_2 =
      'modules/genmobile2/dashboard/getParamsFilter';
  static const REPORT_CONTACT = 'modules/genmobile2/dashboard/hopdongnv';
  static const REPORT_GENERAL =
      'modules/genmobile2/dashboard/baocaoDoanhsoChung';
  static const LIST_CUSTOMER = 'modules/genmobile2/customer/list';
  static const DETAIL_CUSTOMER = 'modules/genmobile2/customer/detail';
  static const CLUE_CUSTOMER = 'modules/genmobile2/customer/listContacts';
  static const CHANCE_CUSTOMER =
      'modules/genmobile2/customer/listOpportunities';
  static const CONTRACT_CUSTOMER = 'modules/genmobile2/customer/listContracts';
  static const JOB_CUSTOMER = 'modules/genmobile2/customer/listJobs';
  static const SUPPORT_CUSTOMER = 'modules/genmobile2/customer/listSupports';
  static const DETAIL_SUPPORT = 'modules/genmobile2/support/detail';
  static const LIST_CONTRACT = 'modules/genmobile2/contract/list';
  static const LIST_SUPPORT = 'modules/genmobile2/support/list';
  static const ADD_CUSTOMER_GET = 'modules/genmobile2/customer/edit';
  static const ADD_SERVICE_VOUCHER = 'modules/genmobile2/quickCreate/contract';
  static const POST_INFO_CAR = 'modules/genmobile2/product/getTTXE';
  static const SAVE_SERVICE_VOUCHER = 'modules/genmobile2/quickCreate/save';
  static const LIST_CAR_INFO = 'modules/genmobile2/product/versions';
  static const ADD_CUSTOMER_INDIVIDUAL_POST =
      'modules/genmobile2/customer/saveIndividual';
  static const DETAIL_CONTRACT = 'modules/genmobile2/contract/detail';
  static const PAYMENT_CONTRACT = 'modules/genmobile2/contract/listPayment';
  static const JOB_CONTRACT = 'modules/genmobile2/contract/listJob';
  static const SUPPORT_CONTRACT = 'modules/genmobile2/contract/listSupports';
  static const DELETE_CUSTOMER = 'modules/genmobile2/customer/delete';
  static const ADD_CUSTOMER_OR = 'modules/genmobile2/customer/saveOrganization';
  static const EDIT_CUSTOMER = 'modules/genmobile2/customer/saveUpdate';
  static const LIST_JOB = 'modules/genmobile2/job/getlist';
  static const GET_UPDATE_CUSTOMER = 'modules/genmobile2/customer/getUpdate';
  static const DELETE_CONTRACT = 'modules/genmobile2/contract/delete';
  static const DELETE_JOB = 'modules/genmobile2/job/delete';
  static const DETAIL_JOB = 'modules/genmobile2/job/detail';
  static const GET_FORM_ADD_CONTACT_CUS =
      'modules/genmobile2/customer/addContact';
  static const ADD_CONTACT_CUS = 'modules/genmobile2/agencycustomer/save';
  static const GET_FORM_ADD_OPPORT_CUS =
      'modules/genmobile2/customer/addOpportunity';
  static const ADD_OPPORTUNITY = 'modules/genmobile2/opportunity/save';
  static const GET_FORM_ADD_CONTRACT_CUS =
      'modules/genmobile2/customer/addContract';
  static const ADD_CONTRACT = 'modules/genmobile2/contract/save';
  static const GET_FORM_ADD_JOB_CUS = 'modules/genmobile2/customer/addJob';
  static const ADD_JOB = 'modules/genmobile2/job/save';
  static const GET_FORM_ADD_SUPPORT_CUS =
      'modules/genmobile2/customer/addSupport';
  static const ADD_SUPPORT = 'modules/genmobile2/support/save';
  static const GET_FORM_ADD_AGENCY = 'modules/genmobile2/agencycustomer/edit';
  static const GET_FORM_ADD_CHANCE = 'modules/genmobile2/opportunity/edit';
  static const GET_FORM_ADD_CONTRACT = 'modules/genmobile2/contract/add';
  static const GET_FORM_ADD_JOB = 'modules/genmobile2/job/edit';
  static const GET_FORM_ADD_SUPPORT = 'modules/genmobile2/support/add';
  static const GET_FORM_ADD_JOB_OPP =
      'modules/genmobile2/agencycustomer/addJob';
  static const GET_FORM_ADD_JOB_CHANCE =
      'modules/genmobile2/opportunity/addJob';
  static const DELETE_CONTACT = 'modules/genmobile2/agencycustomer/delete';
  static const FORM_EDIT_CONTACT = 'modules/genmobile2/agencycustomer/edit';
  static const DELETE_CHANCE = 'modules/genmobile2/opportunity/delete';
  static const SAVE_UPDATE_JOB = 'modules/genmobile2/job/saveUpdate';
  static const FORM_EDIT_SUPPORT = 'modules/genmobile2/support/edit';
  static const DELETE_SUPPORT = 'modules/genmobile2/support/delete';
  static const GET_CUSTOMER_CONTRACT = 'modules/genmobile2/customer/list_Kh';
  static const GET_FORM_EDIT_CONTRACT = 'modules/genmobile2/contract/edit';
  static const GET_FORM_ADD_JOB_CONTRACT = 'modules/genmobile2/contract/addJob';
  static const GET_FORM_ADD_SUPPORT_CONTRACT =
      'modules/genmobile2/contract/addSupport';
  static const GET_CONTACT_BY_CUSTOMER =
      'modules/genmobile2/agencycustomer/getContactsByCustomer';
  static const ADD_NOTE = 'modules/genmobile2/{module}/addNote';
  static const EDIT_NOTE = 'modules/genmobile2/{module}/updateNote';
  static const GET_LIST_NOTE = 'modules/genmobile2/{module}/listNotes';
  static const DELETE_NOTE = 'modules/genmobile2/{module}/deleteNote';
  static const LIST_PRODUCT = 'modules/genmobile2/product/list_all';
  static const GET_PHONE_CUS = 'modules/genmobile2/customer/getPhone';
  static const UPLOAD_FILE = 'modules/genmobile2/{module}/fileupload';
  static const GET_FILE = 'modules/genmobile2/documents/list';
  static const DELETE_FILE = 'modules/genmobile2/documents/delete';
  static const INFO_ACC = 'modules/genmobile2/profile/info';
  static const LIST_CLUE = 'modules/genmobile2/agencycustomer/list';
  static const DETAIL_CLUE = 'modules/genmobile2/agencycustomer/detail';
  static const WORK_CLUE = 'modules/genmobile2/agencycustomer/listJobs';
  static const POLICY = 'modules/genmobile2/app/getpolicy';
  static const GET_INFOR = 'modules/genmobile2/app/getinfo';
  static const UPDATE_PASS = 'modules/genmobile2/profile/changepass';
  static const CHANGE_INFOR_ACC = 'modules/genmobile2/profile/update';
  static const LIST_UNREAD_NOTIFICATION =
      'modules/genmobile2/notification/list';
  static const LIST_READED_NOTIFICATION =
      'modules/genmobile2/notification/listRead';
  static const DELETE_NOTIFICATION = 'modules/genmobile2/notification/delete';
  static const READ_NOTIFICATION = 'modules/genmobile2/notification/read';
  static const GET_XE = 'modules/genmobile2/product/getsanphamkh';
  static const GROUP_PRODUCT = 'modules/genmobile2/product/getCats';
  static const PRODUCT = 'modules/genmobile2/product/list';
  static const DETAIL_PRODUCT = 'modules/genmobile2/product/view';
  static const ADD_PRODUCT = 'modules/genmobile2/product/form';
  static const EDIT_PRODUCT = 'modules/genmobile2/product/form';
  static const ADD_PRODUCT_MODULE = 'modules/genmobile2/product/save';
  static const DELETE_PRODUCT = 'modules/genmobile2/product/delete';
  static const GET_LIST_BAO_CAO = 'modules/genmobile2/dashboard/list';
  static const HOME_BAO_CAO = 'modules/genmobile2/dashboard/xetrongxuong';
  static const SAVE_CHECK_IN = 'modules/genmobile2/{module}/checkIn';
  static const LIST_PRODUCT_CUSTOMER =
      'modules/genmobile2/productCustomer/list';
  static const PRODUCT_CUSTOMER_DETAIL =
      'modules/genmobile2/productCustomer/detail';
  static const GET_FORM_ADD_PRODUCT_CUSTOMER =
      'modules/genmobile2/productCustomer/form';
  static const SAVE_FROM_PRODUCT_CUSTOMER_ADD =
      'modules/genmobile2/productCustomer/save';
  static const GET_FORM_EDIT_PRODUCT_CUSTOMER =
      'modules/genmobile2/productCustomer/form';
  static const SAVE_FROM_PRODUCT_CUSTOMER_EDIT =
      'modules/genmobile2/productCustomer/save';
  static const PRODUCT_CUSTOMER_DELETE =
      'modules/genmobile2/productCustomer/delete';
  static const GET_FORM_SIGN = 'modules/genmobile2/contract/formKn';
  static const SAVE_SIGN = 'modules/genmobile2/contract/saveKn';
  static const GET_LIST_HT_PRODUCT_CUSTOMER =
      'modules/genmobile2/productCustomer/tabHt';
  static const GET_LIST_CH_PRODUCT_CUSTOMER =
      'modules/genmobile2/productCustomer/tabCh';
  static const GET_LIST_CV_PRODUCT_CUSTOMER =
      'modules/genmobile2/productCustomer/tabCv';
  static const GET_LIST_HD_PRODUCT_CUSTOMER =
      'modules/genmobile2/productCustomer/tabHd';
  static const GET_FORM_CH_PRODUCT_CUSTOMER =
      'modules/genmobile2/productCustomer/getFormCh';
  static const GET_FORM_HD_PRODUCT_CUSTOMER =
      'modules/genmobile2/productCustomer/getFormHd';
  static const GET_FORM_CV_PRODUCT_CUSTOMER =
      'modules/genmobile2/productCustomer/getFormCv';
  static const GET_FORM_HT_PRODUCT_CUSTOMER =
      'modules/genmobile2/productCustomer/getFormHt';
  static const GET_LIST_MANAGER_FILTER =
      'modules/genmobile2/settings/nql';
  static const GET_ADDRESS_CUSTOMER =
      'modules/genmobile2/customer/getAddress';

  static const int receiveTimeout = 15000;
  static const ENV = 'assets/.env';
  static const int connectionTimeout = 45000; //todo timeout them coong viec
  static const content_type = 'Content-Type';
  static const application_json = 'application/json';
  static const PHPSESSID = 'PHPSESSID';
  static const AUTHORIZATION = 'Authorization';
  static const multipart_form_data = 'multipart/form-data';
  static const auth_type = 'Cookie';

  static String bearer(String token) => token;

  static const headerDemoKey = 'Demo-Header';
  static const headerDemoValue = 'demo header';

  static const SUCCESS = 0;
  static const SUCCESS_200 = 200;
  static const SUCCESS_999 = 999;
  static const FAIL = 9100;

  static const ACTIVE = 1;
  static const LOCK = 0;
  static const KHACH_HANG = 'Khách hàng';
  static const TEN_KHACH_HANG = 'Tên khách hàng';
  static const NOTE_ID = 'noteid';
  static const ID = 'id';
  static const CONTENT = 'content';
  static const DEVICE_TOKEN = 'device_token';
}

class Module {
  static const String KHACH_HANG = 'khachhang';
  static const String HOP_DONG = 'hopdong';
  static const String HO_TRO = 'hotro';
  static const String CONG_VIEC = 'congviec';
  static const String CO_HOI_BH = 'cohoibh';
  static const String SAN_PHAM_KH = 'sanphamkh';
  static const String DAU_MOI = 'daumoi';
  static const String PRODUCT = 'sanpham';
}

// job cv customer: khách hang support ho tro contact đầu mối
String getURLModule(String module) {
  if (module == Module.HOP_DONG) {
    return 'contract';
  } else if (module == Module.KHACH_HANG) {
    return 'customer';
  } else if (module == Module.DAU_MOI) {
    return 'agencycustomer';
  } else if (module == Module.CONG_VIEC) {
    return 'job';
  } else if (module == Module.HO_TRO) {
    return 'support';
  } else if (module == Module.CO_HOI_BH) {
    return 'opportunity';
  } else if (module == Module.PRODUCT) {
    return 'product';
  } else if (module == Module.SAN_PHAM_KH) {
    return 'productCustomer';
  }
  return '';
}

class ModuleMy {
  static const String CUSTOMER = 'customer';
  static const String DAU_MOI = 'contact';
  static const String LICH_HEN = 'opportunity';
  static const String HOP_DONG = 'contract';
  static const String CONG_VIEC = 'job';
  static const String CSKH = 'support';
  static const String SAN_PHAM = 'product';
  static const String SAN_PHAM_KH = 'sanphamkh';

  static String getIcon(String id) {
    if (ModuleMy.CUSTOMER == id) {
      return ICONS.IC_CUSTOMER_3X_PNG;
    } else if (ModuleMy.DAU_MOI == id) {
      return ICONS.IC_CLUE_3X_PNG;
    } else if (ModuleMy.LICH_HEN == id) {
      return ICONS.IC_CHANCE_3X_PNG;
    } else if (ModuleMy.HOP_DONG == id) {
      return ICONS.IC_CONTRACT_3X_PNG;
    } else if (ModuleMy.CONG_VIEC == id) {
      return ICONS.IC_WORK_3X_PNG;
    } else if (ModuleMy.CSKH == id) {
      return ICONS.IC_SUPPORT_3X_PNG;
    } else if (ModuleMy.SAN_PHAM == id) {
      return ICONS.IC_CONTRACT_3X_PNG;
    } else if (ModuleMy.SAN_PHAM_KH == id) {
      return ICONS.IC_CHANCE_3X_PNG;
    }
    return ICONS.IC_WORK_3X_PNG;
  }

  static Color getColor(String id) {
    if (ModuleMy.CUSTOMER == id) {
      return Color(0xff369FFF);
    } else if (ModuleMy.DAU_MOI == id) {
      return Color(0xffFDC9D2);
    } else if (ModuleMy.LICH_HEN == id) {
      return Color(0xffA5A6F6);
    } else if (ModuleMy.HOP_DONG == id) {
      return Color(0xffFFC000);
    } else if (ModuleMy.CONG_VIEC == id) {
      return Color(0xffFF993A);
    } else if (ModuleMy.CSKH == id) {
      return Color(0xff8AC53E);
    } else if (ModuleMy.SAN_PHAM == id) {
      return Color(0xff22b290);
    } else if (ModuleMy.SAN_PHAM_KH == id) {
      return Color(0xff9c4bbb);
    }
    return Color(0xffFF993A);
  }
}

class ModuleText {
  static const String CUSTOMER = 'them_khach_hang';
  static const String DAU_MOI = 'them_dau_moi';
  static const String LICH_HEN = 'them_co_hoi';
  static const String HOP_DONG = 'them_hop_dong';
  static const String CONG_VIEC = 'them_cong_viec';
  static const String CSKH = 'them_ho_tro';
  static const String THEM_MUA_XE = 'them_mua_xe';
  static const String THEM_BAN_XE = 'them_ban_xe';
  static const String THEM_SAN_PHAM_KH = 'them_sanphamkh';

  static String getIconMenu(String id) {
    if (ModuleText.CUSTOMER == id) {
      return ICONS.IC_CUSTOMER_3X_PNG;
    } else if (ModuleText.DAU_MOI == id) {
      return ICONS.IC_CLUE_3X_PNG;
    } else if (ModuleText.LICH_HEN == id) {
      return ICONS.IC_CHANCE_3X_PNG;
    } else if (ModuleText.HOP_DONG == id) {
      return ICONS.IC_CONTRACT_3X_PNG;
    } else if (ModuleText.CONG_VIEC == id) {
      return ICONS.IC_WORK_3X_PNG;
    } else if (ModuleText.CSKH == id) {
      return ICONS.IC_SUPPORT_3X_PNG;
    } else if (ModuleText.THEM_SAN_PHAM_KH == id) {
      return ICONS.IC_CHANCE_3X_PNG;
    }
    return ICONS.IC_WORK_3X_PNG;
  }
}
