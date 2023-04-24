import 'dart:convert';
import 'dart:io';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/get_infor_acc/get_infor_acc_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/screens/add_service_voucher/add_service_voucher_screen.dart';
import 'package:gen_crm/widgets/widget_appbar.dart';
import 'package:get/get.dart';
import 'package:gen_crm/models/index.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:is_lock_screen/is_lock_screen.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';
import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/services/pitel_service.dart';
import 'package:plugin_pitel/services/sip_info_data.dart';
import 'package:plugin_pitel/sip/src/sip_ua_helper.dart';
import 'package:plugin_pitel/voip_push/push_notif.dart';
import 'package:plugin_pitel/sip/sip_ua.dart';
import '../bloc/login/login_bloc.dart';
import '../src/app_const.dart';
import '../storages/share_local.dart';
import '../widgets/item_menu.dart';
import 'call/call_screen.dart';
import 'menu/menu_left/menu_drawer/main_drawer.dart';

final checkIsPushNotif = StateProvider<bool>((ref) => false);

class ScreenMain extends ConsumerStatefulWidget {
  final PitelCall _pitelCall = PitelClient.getInstance().pitelCall;
  @override
  _ScreenMainState createState() => _ScreenMainState();
}

class _ScreenMainState extends ConsumerState<ScreenMain>
    with WidgetsBindingObserver
    implements SipPitelHelperListener {
  PitelCall get pitelCall => widget._pitelCall;
  PitelClient pitelClient = PitelClient.getInstance();
  final pitelService = PitelServiceImpl();
  String state = '';
  bool lockScreen = false;
  late final String deviceToken;

  ///////////////// UI
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  List<ButtonMenuModel> listMenu = [];
  String getIconMenu(String id) {
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
    }
    return ICONS.IC_WORK_3X_PNG;
  }

  getMenu() async {
    String menu = await shareLocal.getString(PreferencesKey.MENU);
    List listM = jsonDecode(menu);
    for (int i = 0; i < listM.length; i++) {
      listMenu.add(
        ButtonMenuModel(
            title: listM[i]['name'],
            image: listM[i]['id'] == 'opportunity'
                ? ICONS.IC_CHANCE_3X_PNG
                : listM[i]['id'] == 'job'
                    ? ICONS.IC_WORK_3X_PNG
                    : listM[i]['id'] == 'contract'
                        ? ICONS.IC_CONTRACT_3X_PNG
                        : listM[i]['id'] == 'support'
                            ? ICONS.IC_SUPPORT_3X_PNG
                            : listM[i]['id'] == 'customer'
                                ? ICONS.IC_CUSTOMER_3X_PNG
                                : ICONS.IC_CLUE_3X_PNG,
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
    listMenu.add(
      ButtonMenuModel(
          title: 'Báo cáo',
          image: ICONS.IC_WORK_3X_PNG,
          backgroundColor: Color(0xff5D5FEF),
          onTap: () async {
            String? money = await shareLocal.getString(PreferencesKey.MONEY);
            AppNavigator.navigateReport(money ?? "đ");
          }),
    );
    listMenu.add(
      ButtonMenuModel(
          title: 'Sản phẩm',
          image: ICONS.IC_WORK_3X_PNG,
          backgroundColor: Color(0xff946b4c),
          onTap: () {
            AppNavigator.navigateProduct();
          }),
    );
    setState(() {});
  }

  _buildItemMenu({required ButtonMenuModel data, required int index}) {
    return GestureDetector(
      onTap: data.onTap,
      child: ItemMenu(data: data),
    );
  }

  //////////////////////

  @override
  void initState() {
    callInit();
    Future.delayed(Duration(milliseconds: 300), () {
      GetInforAccBloc.of(context).add(InitGetInforAcc());
      GetListUnReadNotifiBloc.of(context).add(CheckNotification());
    });
    getMenu();
    LoginBloc.of(context).getListMenuFlash();
    super.initState();
  }

  //////////////////// HANDEL CALL

  void callInit() async {
    state = pitelCall.getRegisterState();
    LoginBloc.of(context).receivedMsg.add(LoginBloc.UNREGISTER);
    _bindEventListeners();
    await _getDeviceToken();
    await handleRegister();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> handleRegister() async {
    await LoginBloc.of(context).getDataCall();
    final String domainUrl = 'https://demo-gencrm.com/';
    //shareLocal.getString(PreferencesKey.URL_BASE);
    final String domain = domainUrl.substring(
        domainUrl.indexOf('//') + 2, domainUrl.lastIndexOf('/'));
    final int user =
        int.parse(LoginBloc.of(context).loginData?.info_user?.extension ?? '0');
    final String pass =
        LoginBloc.of(context).loginData?.info_user?.password_extension ?? '';
    final String outboundServer = LoginBloc.of(context)
            .loginData
            ?.info_user
            ?.info_setup_callcenter
            ?.outbound ??
        '';
    final String apiDomain = LoginBloc.of(context)
            .loginData
            ?.info_user
            ?.info_setup_callcenter
            ?.domain ??
        '';
    final sipInfo = SipInfoData.fromJson({
      "authPass": pass,
      "registerServer": domain,
      "outboundServer": outboundServer,
      "userID": user,
      "authID": user,
      "accountName": "${user}",
      "displayName": "${user}@${domain}",
      "dialPlan": null,
      "randomPort": null,
      "voicemail": null,
      "wssUrl": BASE_URL.URL_WSS,
      "userName": "${user}@${domain}",
      "apiDomain": getCheckHttp(apiDomain),
    });
    await pitelService.setExtensionInfo(sipInfoData);
    await _registerDeviceToken();
  }

  Future<void> _registerDeviceToken() async {
    final String domainUrl = 'https://demo-gencrm.com/';
    // shareLocal.getString(PreferencesKey.URL_BASE);
    final String domain = domainUrl.substring(
        domainUrl.indexOf('//') + 2, domainUrl.lastIndexOf('/'));
    final String user =
        LoginBloc.of(context).loginData?.info_user?.extension ?? '';
    bool isAndroid = Platform.isAndroid;
    // await pitelClient.registerDeviceToken(
    //   deviceToken: deviceToken,
    //   platform: isAndroid ? 'android' : 'ios',
    //   bundleId: isAndroid ? 'vn.gen_crm' : 'com.gencrm', // BundleId/packageId
    //   domain: domain,
    //   extension: user,
    //   appMode: kReleaseMode ? 'production' : 'dev',
    // );
    final response = await pitelClient.registerDeviceToken(
      deviceToken: deviceToken,
      platform: 'android',
      bundleId: 'vn.gen_crm',
      domain: 'demo-gencrm.com',
      extension: '102',
      // appMode: kReleaseMode ? 'production' : 'dev',
      appMode: 'dev',
    );
  }

  Future<void> _getDeviceToken() async {
    deviceToken = await PushVoipNotif.getDeviceToken();
    await shareLocal.putString(PreferencesKey.DEVICE_TOKEN, deviceToken);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      final isLock = await isLockScreen();
      setState(() {
        lockScreen = isLock ?? false;
      });
    }
  }

  @override
  void registrationStateChanged(PitelRegistrationState state) {
    switch (state.state) {
      case PitelRegistrationStateEnum.REGISTRATION_FAILED:
        goBack();
        break;
      case PitelRegistrationStateEnum.NONE:
      case PitelRegistrationStateEnum.UNREGISTERED:
        LoginBloc.of(context).receivedMsg.add(LoginBloc.UNREGISTER);
        break;
      case PitelRegistrationStateEnum.REGISTERED:
        LoginBloc.of(context).receivedMsg.add(LoginBloc.REGISTERED);
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
    if (state.state == PitelCallStateEnum.ENDED && lockScreen) {
      FlutterCallkitIncoming.endAllCalls();
    }
  }

  @override
  void onCallReceived(String callId) {
    pitelCall.setCallCurrent(callId);
    if (Platform.isIOS) {
      pitelCall.answer();
    }
    if (Platform.isAndroid) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CallScreenWidget()));
    }
    if (!lockScreen) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CallScreenWidget()));
    }
  }

  @override
  void onCallInitiated(String callId) {
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
    var msgBody = msg.request.body as String;
    LoginBloc.of(context).receivedMsg.add(msgBody);
  }

  @override
  void transportStateChanged(PitelTransportState state) {}

  /////////////////END

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(onPress: (v) => handleOnPressItemMenu(_drawerKey, v)),
      floatingActionButton: LoginBloc.of(context).listMenuFlash.isNotEmpty
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
                        return SvgPicture.asset(ICONS.IC_NOTIFICATION_SVG);
                      } else {
                        return SvgPicture.asset(ICONS.IC_NOTIFICATION2_SVG);
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
                        return SvgPicture.asset(ICONS.IC_NOTIFICATION_SVG);
                      } else {
                        return SvgPicture.asset(ICONS.IC_NOTIFICATION2_SVG);
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
              SizedBox(
                height: 25,
              ),
              GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listMenu.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 25,
                    mainAxisSpacing: 25,
                  ),
                  itemBuilder: (context, index) {
                    return _buildItemMenu(data: listMenu[index], index: index);
                  }),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
