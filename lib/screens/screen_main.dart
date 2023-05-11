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
import 'package:gen_crm/widgets/widget_appbar.dart';
import 'package:gen_crm/models/index.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:is_lock_screen/is_lock_screen.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';
import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/services/pitel_service.dart';
import 'package:plugin_pitel/sip/src/sip_ua_helper.dart';
import 'package:plugin_pitel/voip_push/push_notif.dart';
import 'package:plugin_pitel/sip/sip_ua.dart';
import '../bloc/login/login_bloc.dart';
import '../src/app_const.dart';
import '../storages/share_local.dart';
import '../widgets/item_menu.dart';
import 'call/call_screen.dart';
import 'menu/home/menu_flash.dart';
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
  late final bool isRegister;

  ///////////////// UI
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  List<ButtonMenuModel> listMenu = [];
  void getMenu() async {
    String menu = await shareLocal.getString(PreferencesKey.MENU);
    List listM = jsonDecode(menu);
    for (final value in listM) {
      String id = value['id'];
      String name = value['name'];
      if (id == ModuleMy.HOP_DONG) {
        String titleReport = name + ' đang làm';
        shareLocal.putString(PreferencesKey.NAME_REPORT, titleReport);
      }
      listMenu.add(
        ButtonMenuModel(
            title: name,
            image: ModuleMy.getIcon(id),
            backgroundColor: ModuleMy.getColor(id),
            onTap: () {
              if (id == ModuleMy.LICH_HEN) {
                AppNavigator.navigateChance(name);
              } else if (id == ModuleMy.CONG_VIEC) {
                AppNavigator.navigateWork(name);
              } else if (id == ModuleMy.HOP_DONG) {
                AppNavigator.navigateContract(name);
              } else if (id == ModuleMy.CSKH) {
                AppNavigator.navigateSupport(name);
              } else if (id == ModuleMy.CUSTOMER) {
                AppNavigator.navigateCustomer(name);
              } else if (id == ModuleMy.DAU_MOI) {
                AppNavigator.navigateClue(name);
              } else if (id == ModuleMy.SAN_PHAM) {
                AppNavigator.navigateProduct(name);
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
    setState(() {});
  }
  //////////////////////

  @override
  void initState() {
    callInit();
    GetInforAccBloc.of(context).add(InitGetInforAcc());
    GetListUnReadNotifiBloc.of(context).add(CheckNotification());
    getMenu();
    LoginBloc.of(context).getListMenuFlash();
    super.initState();
  }

  //////////////////// HANDEL CALL

  void callInit() {
    isRegister =
        (shareLocal.getString(PreferencesKey.REGISTER_CALL) ?? "true") ==
            "true";
    state = pitelCall.getRegisterState();
    LoginBloc.of(context).receivedMsg.add(LoginBloc.UNREGISTER);
    _bindEventListeners();
    if (isRegister) {
      shareLocal.putString(PreferencesKey.REGISTER_CALL, 'false');
      _getDeviceToken();
    }
    WidgetsBinding.instance.addObserver(this);
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

  Future<void> _getDeviceToken() async {
    final deviceToken = await PushVoipNotif.getDeviceToken();
    shareLocal.putString(PreferencesKey.DEVICE_TOKEN, deviceToken);
    handleRegisterBase(context, pitelService, deviceToken);
    _registerDeviceToken(deviceToken);
  }

  Future<void> _registerDeviceToken(String deviceToken) async {
    final String domainUrl = 'https://demo-gencrm.com/';
    // shareLocal.getString(PreferencesKey.URL_BASE);
    final String domain = domainUrl.substring(
        domainUrl.indexOf('//') + 2, domainUrl.lastIndexOf('/'));
    final String user =
        LoginBloc.of(context).loginData?.info_user?.extension ?? '';
    bool isAndroid = Platform.isAndroid;
    await pitelClient.registerDeviceToken(
      deviceToken: deviceToken,
      platform: isAndroid ? 'android' : 'ios',
      bundleId: isAndroid ? PACKAGE_ID : BUNDLE_ID, // BundleId/packageId
      domain: domain,
      extension: user,
      appMode: kReleaseMode ? 'production' : 'dev',
    );
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

  void _bindEventListeners() {
    pitelCall.addListener(this);
  }

  void _removeEventListeners() {
    pitelCall.removeListener(this);
  }

  @override
  void callStateChanged(String callId, PitelCallState state) {
    if (state.state == PitelCallStateEnum.ENDED) {
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
    if (!lockScreen && Platform.isIOS) {
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
                      return MenuFlash();
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
                    title: state.inforAcc.fullname,
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
                        image: state.inforAcc.avatar ?? '',
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
                    return GestureDetector(
                      onTap: listMenu[index].onTap,
                      child: ItemMenu(data: listMenu[index]),
                    );
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
