import 'dart:convert';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/get_infor_acc/get_infor_acc_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/screens/add_service_voucher/add_service_voucher_screen.dart';
import 'package:gen_crm/widgets/widget_appbar.dart';
import 'package:get/get.dart';
import 'package:gen_crm/models/index.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';
import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/services/pitel_service.dart';
import 'package:plugin_pitel/services/sip_info_data.dart';
import 'package:plugin_pitel/sip/src/sip_ua_helper.dart';

import '../bloc/login/login_bloc.dart';
import '../storages/share_local.dart';
import 'call_video/call_screen.dart';
import 'menu/menu_left/menu_drawer/main_drawer.dart';

class ScreenMain extends StatefulWidget {
  @override
  _ScreenMainState createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain>
    implements SipPitelHelperListener {
  //call
  static const String UNREGISTER = 'UNREGISTER';
  static const String PASSWORD = 'GenCRM@2023##'; //
  static const String DOMAIN = 'demo-gencrm.com';
  static const String OUTBOUND_PROXY = 'pbx-mobile.tel4vn.com:50061';
  static const String URL_WSS = 'wss://wss-mobile.tel4vn.com:7444';
  static const String URL_API = 'https://pbx-mobile.tel4vn.com';
  static const int UUSER = 101;
  static const String USER_NAME = 'user1';
  late final PitelCall pitelCall;
  late final PitelClient pitelClient;
  String state = '';
  //
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<ButtonMenuModel> listMenu = [];

  String getIconMenu(String id) {
    if (ModuleText.CUSTOMER == id) {
      return ICONS.CUSTUMER_3X;
    } else if (ModuleText.DAU_MOI == id) {
      return ICONS.CLUE_3X;
    } else if (ModuleText.LICH_HEN == id) {
      return ICONS.CHANCE_3X;
    } else if (ModuleText.HOP_DONG == id) {
      return ICONS.CONTRACT_3X;
    } else if (ModuleText.CONG_VIEC == id) {
      return ICONS.WORK_3X;
    } else if (ModuleText.CSKH == id) {
      return ICONS.SUPPORT_3X;
    }
    return ICONS.WORK_3X;
  }

  @override
  void initState() {
    pitelClient = LoginBloc.of(context).pitelClient;
    pitelCall = LoginBloc.of(context).pitelCall;
    //call
    state = pitelCall.getRegisterState();
    LoginBloc.of(context).receivedMsg.add(UNREGISTER);
    _bindEventListeners();
    final sipInfo = SipInfoData.fromJson({
      "authPass": PASSWORD,
      "registerServer": DOMAIN,
      "outboundServer": OUTBOUND_PROXY,
      "userID": UUSER,
      "authID": UUSER,
      "accountName": "${UUSER}",
      "displayName": "${UUSER}@${DOMAIN}",
      "dialPlan": null,
      "randomPort": null,
      "voicemail": null,
      "wssUrl": URL_WSS,
      "userName": "${USER_NAME}@${DOMAIN}",
      "apiDomain": URL_API
    });
    final pitelClientImpl = PitelServiceImpl();
    pitelClientImpl.setExtensionInfo(sipInfo);
    //
    Future.delayed(Duration(milliseconds: 300), () {
      GetInforAccBloc.of(context).add(InitGetInforAcc());
      GetListUnReadNotifiBloc.of(context).add(CheckNotification());
    });
    getMenu();
    LoginBloc.of(context).getListMenuFlash();
    super.initState();
  }

  @override
  void registrationStateChanged(PitelRegistrationState state) {
    switch (state.state) {
      case PitelRegistrationStateEnum.REGISTRATION_FAILED:
        goBack();//todo failed
        break;
      case PitelRegistrationStateEnum.NONE:
      case PitelRegistrationStateEnum.UNREGISTERED:
      case PitelRegistrationStateEnum.REGISTERED:
        LoginBloc.of(context).receivedMsg.add(LoginBloc.REGISTERED);
        break;
    }
  }
  //call

  getMenu() async {
    String menu = await shareLocal.getString(PreferencesKey.MENU);
    List listM = jsonDecode(menu);
    for (int i = 0; i < listM.length; i++) {
      listMenu.add(
        ButtonMenuModel(
            title: listM[i]['name'],
            image: listM[i]['id'] == 'opportunity'
                ? ICONS.CHANCE_3X
                : listM[i]['id'] == 'job'
                    ? ICONS.WORK_3X
                    : listM[i]['id'] == 'contract'
                        ? ICONS.CONTRACT_3X
                        : listM[i]['id'] == 'support'
                            ? ICONS.SUPPORT_3X
                            : listM[i]['id'] == 'customer'
                                ? ICONS.CUSTUMER_3X
                                : ICONS.CLUE_3X,
            backgroundColor: listM[i]['id'] == 'opportunity'
                ? Color(0xffFDC9D2)
                : listM[i]['id'] == 'job'
                    ? Color(0xffFF993A)
                    : listM[i]['id'] == 'contract'
                        ? Color(0xffFFC000)
                        : listM[i]['id'] == 'support'
                            ? Color(0xff8AC53E)
                            : listM[i]['id'] == 'customer'
                                ? Color(0xff369FFF)
                                : Color(0xffA5A6F6),
            onTap: () {
              if (listM[i]['id'] == 'opportunity') {
                AppNavigator.navigateChance(listM[i]['name']);
              } else if (listM[i]['id'] == 'job') {
                AppNavigator.navigateWork(listM[i]['name']);
              } else if (listM[i]['id'] == 'contract') {
                AppNavigator.navigateContract(listM[i]['name']);
              } else if (listM[i]['id'] == 'support') {
                AppNavigator.navigateSupport(listM[i]['name']);
              } else if (listM[i]['id'] == 'customer') {
                AppNavigator.navigateCustomer(listM[i]['name']);
              } else {
                AppNavigator.navigateClue(listM[i]['name']);
              }
            }),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(onPress: handleOnPressItemMenu),
      floatingActionButton: listMenu.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: Color(0xff1AA928),
              onPressed: () {
                showModalBottomSheet(
                    isDismissible: false,
                    enableDrag: false,
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    builder: (BuildContext context) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...List<Widget>.generate(
                                LoginBloc.of(context).listMenuFlash.length,
                                (i) {
                              return GestureDetector(
                                onTap: () {
                                  Get.back();

                                  String id = LoginBloc.of(context)
                                      .listMenuFlash[i]
                                      .id
                                      .toString();
                                  String name = LoginBloc.of(context)
                                      .listMenuFlash[i]
                                      .name
                                      .toString()
                                      .toLowerCase();
                                  if (ModuleText.CUSTOMER == id) {
                                    AppNavigator.navigateAddCustomer();
                                  } else if (ModuleText.DAU_MOI == id) {
                                    AppNavigator.navigateFormAdd(name, 2);
                                  } else if (ModuleText.LICH_HEN == id) {
                                    AppNavigator.navigateFormAdd(name, 3);
                                  } else if (ModuleText.HOP_DONG == id) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddServiceVoucherScreen(
                                                    title: name
                                                            .toUpperCase()
                                                            .capitalizeFirst ??
                                                        '')));
                                  } else if (ModuleText.CONG_VIEC == id) {
                                    AppNavigator.navigateFormAdd(name, 14);
                                  } else if (ModuleText.CSKH == id) {
                                    AppNavigator.navigateFormAdd(name, 6);
                                  } else if (ModuleText.THEM_MUA_XE == id) {
                                    //todo
                                  } else if (ModuleText.THEM_BAN_XE == id) {
                                    //todo
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AppValue.hSpaceLarge,
                                    Image.asset(
                                      getIconMenu(LoginBloc.of(context)
                                          .listMenuFlash[i]
                                          .id
                                          .toString()),
                                      height: 26,
                                      width: 26,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      LoginBloc.of(context)
                                          .listMenuFlash[i]
                                          .name
                                          .toString(),
                                      style: AppStyle.DEFAULT_16_BOLD
                                          .copyWith(color: Color(0xff006CB1)),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Container(
                                    width: AppValue.widths * 0.8,
                                    height: AppValue.heights * 0.06,
                                    decoration: BoxDecoration(
                                      color: HexColor("#D0F1EB"),
                                      borderRadius:
                                          BorderRadius.circular(17.06),
                                    ),
                                    child: Center(
                                      child: Text("Đóng"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Icon(Icons.add, size: 40),
            )
          : SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(
            MESSAGES.BACK_TO_EXIT,
            style: AppStyle.DEFAULT_16.copyWith(color: COLORS.WHITE),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<GetInforAccBloc, GetInforAccState>(
                  builder: (context, state) {
                if (state is UpdateGetInforAccState) {
                  return WidgetAppbar(
                    title:
                        state.inforAcc != null ? state.inforAcc.fullname : '',
                    textColor: Colors.black,
                    right: GestureDetector(onTap: () {
                      return AppNavigator.navigateNotification();
                    }, child: BlocBuilder<GetListUnReadNotifiBloc,
                        UnReadListNotifiState>(builder: (context, state) {
                      if (state is NotificationNeedRead) {
                        return SvgPicture.asset(
                            "assets/icons/notification.svg");
                      } else {
                        return SvgPicture.asset(
                            "assets/icons/notification2.svg");
                      }
                    })),
                    left: GestureDetector(
                      onTap: () {
                        if (_drawerKey.currentContext != null &&
                            !_drawerKey.currentState!.isDrawerOpen) {
                          _drawerKey.currentState!.openDrawer();
                        }
                      },
                      child: WidgetNetworkImage(
                        image: state.inforAcc != null
                            ? state.inforAcc.avatar!
                            : '',
                        width: 50,
                        height: 50,
                        borderRadius: 25,
                      ),
                    ),
                  );
                } else {
                  return WidgetAppbar(
                    title: '',
                    textColor: Colors.black,
                    right: GestureDetector(onTap: () {
                      return AppNavigator.navigateNotification();
                    }, child: BlocBuilder<GetListUnReadNotifiBloc,
                        UnReadListNotifiState>(builder: (context, state) {
                      if (state is NotificationNeedRead) {
                        return SvgPicture.asset(
                            "assets/icons/notification.svg");
                      } else {
                        return SvgPicture.asset(
                            "assets/icons/notification2.svg");
                      }
                    })),
                    left: GestureDetector(
                      onTap: () {
                        if (_drawerKey.currentContext != null &&
                            !_drawerKey.currentState!.isDrawerOpen) {
                          _drawerKey.currentState!.openDrawer();
                        }
                      },
                      child: WidgetNetworkImage(
                        image: '',
                        width: 50,
                        height: 50,
                        borderRadius: 25,
                      ),
                    ),
                  );
                }
              }),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listMenu.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 25,
                      // mainAxisExtent: 170
                    ),
                    itemBuilder: (context, index) {
                      // List<ButtonMenuModel> list = [];
                      return _buildItemMenu(
                          data: listMenu[index], index: index);
                    }),
              ),
              GestureDetector(
                onTap: () async {
                  String? money =
                      await shareLocal.getString(PreferencesKey.MONEY);
                  AppNavigator.navigateReport(money ?? "đ");
                },
                child: Container(
                  width: AppValue.widths,
                  height: AppValue.heights * 0.18,
                  margin: EdgeInsets.only(
                    left: 30,
                    bottom: 25,
                    right: 30,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff5D5FEF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   width: 90,
                      //   height: 90,
                      //   decoration: BoxDecoration(
                      //       shape: BoxShape.circle, color: Colors.white),
                      //   child: WidgetContainerImage(
                      //     image: ICONS.WORK_3X,
                      //     fit: BoxFit.contain,
                      //     width: 50,
                      //     height: 50,
                      //   ),
                      // ),
                      // AppValue.vSpaceTiny,
                      Text(
                        "Báo cáo",
                        style: AppStyle.DEFAULT_24_BOLD.copyWith(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontSize: 30,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildItemMenu({required ButtonMenuModel data, required int index}) {
    return GestureDetector(
      onTap: data.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: data.backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Container(
            //   child: Center(
            //     child: Container(
            //       // width: 50,
            //       // height: 50,
            //       // decoration: BoxDecoration(
            //       //     borderRadius: BorderRadius.circular(6),color: Colors.white),
            //       child: WidgetContainerImage(
            //         image: data.image,
            //         fit: BoxFit.contain,
            //         width: 30,
            //         height: 30,
            //         colorImage: Colors.black,
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(width: 8,),
            Expanded(
              child: Container(
                child: Text(
                  data.title,
                  style:
                      AppStyle.DEFAULT_24_BOLD.copyWith(fontFamily: 'Roboto'),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  handleOnPressItemMenu(value) async {
    switch (value['id']) {
      case '1':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateMain();
        break;
      case 'opportunity':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateChance(value['title']);
        break;
      case 'job':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateWork(value['title']);
        break;
      case 'contract':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateContract(value['title']);
        break;
      case 'support':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateSupport(value['title']);
        break;
      case 'customer':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateCustomer(value['title']);
        break;
      case 'contact':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateClue(value['title']);
        break;
      case 'report':
        _drawerKey.currentState!.openEndDrawer();
        String? money = await shareLocal.getString(PreferencesKey.MONEY);
        AppNavigator.navigateReport(money ?? "đ");
        break;
      case '2':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateInformationAccount();
        break;
      case '3':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateAboutUs();
        break;
      case '4':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigatePolicy();
        break;
      case '5':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateChangePassword();
        break;
      default:
        break;
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    _removeEventListeners();
  }

  //call
  void _bindEventListeners() {
    pitelCall.addListener(this);
  }

  void _removeEventListeners() {
    pitelCall.removeListener(this);
  }

  @override
  void callStateChanged(String callId, PitelCallState state) {
    // TODO: implement callStateChanged
  }

  @override
  void onCallReceived(String callId) {
    pitelCall.setCallCurrent(callId);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CallScreenWidget()));
  }

  @override
  void onCallInitiated(String callId) {
    print('fuck');
    pitelCall.setCallCurrent(callId);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CallScreenWidget()));
  }

  void goBack() {
    pitelClient.release();
    Navigator.of(context).pop();
  }

  @override
  void onNewMessage(PitelSIPMessageRequest msg) {
    // TODO: implement onNewMessage
  }

  @override
  void transportStateChanged(PitelTransportState state) {
    // TODO: implement transportStateChanged
  }
}
