import 'dart:convert';
import 'dart:io';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/get_infor_acc/get_infor_acc_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/widgets/widget_appbar.dart';
import 'package:gen_crm/models/index.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
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
import 'add_service_voucher/add_service_voucher_screen.dart';
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
  late final bool isRegister;

  ///////////////// UI
  final _key = GlobalKey<ExpandableFabState>();
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
      } else if (id == ModuleMy.CUSTOMER) {
        shareLocal.putString(PreferencesKey.NAME_CUSTOMER, name);
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
              } else if (id == ModuleMy.SAN_PHAM_KH) {
                AppNavigator.navigateProductCustomer(name);
              }
            }),
      );
    }
    listMenu.add(
      ButtonMenuModel(
          title: 'Báo cáo',
          image: ICONS.IC_REPORT_PNG,
          backgroundColor: Color(0xff5D5FEF),
          onTap: () async {
            String? money = await shareLocal.getString(PreferencesKey.MONEY);
            AppNavigator.navigateReport(money ?? "đ");
          }),
    );
    setState(() {});
  }

  _handelRouterMenuPlus(String id, String name) {
    if (ModuleText.CUSTOMER == id) {
      AppNavigator.navigateAddCustomer('Thêm ${name.toLowerCase()} cá nhân');
    } else if (ModuleText.DAU_MOI == id) {
      AppNavigator.navigateFormAdd(name, 2);
    } else if (ModuleText.LICH_HEN == id) {
      AppNavigator.navigateFormAdd(name, 3);
    } else if (ModuleText.HOP_DONG == id) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddServiceVoucherScreen(
              title: name.toUpperCase().capitalizeFirst ?? '')));
    } else if (ModuleText.CONG_VIEC == id) {
      AppNavigator.navigateFormAdd(name, 14);
    } else if (ModuleText.CSKH == id) {
      AppNavigator.navigateFormAdd(name, 6);
    } else if (ModuleText.THEM_MUA_XE == id) {
      //todo
    } else if (ModuleText.THEM_BAN_XE == id) {
      //todo
    }
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
    final String domainUrl = shareLocal.getString(PreferencesKey.URL_BASE);
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
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: LoginBloc.of(context).listMenuFlash.isNotEmpty
          ? ExpandableFab(
              key: _key,
              distance: 65,
              type: ExpandableFabType.up,
              child: Icon(Icons.add, size: 40),
              closeButtonStyle: const ExpandableFabCloseButtonStyle(
                child: Icon(Icons.close),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff1AA928),
              ),
              backgroundColor: Color(0xff1AA928),
              overlayStyle: ExpandableFabOverlayStyle(
                blur: 5,
              ),
              children: LoginBloc.of(context)
                  .listMenuFlash
                  .reversed
                  .map(
                    (e) => GestureDetector(
                      onTap: () async {
                        final state = _key.currentState;
                        if (state != null) {
                          if (state.isOpen) {
                            final id = e.id ?? '';
                            final name = e.name ?? '';
                            await _handelRouterMenuPlus(id, name);
                            state.toggle();
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: COLORS.BLACK.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: WidgetText(
                              title: e.name ?? '',
                              style: AppStyle.DEFAULT_18_BOLD.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: COLORS.BLACK.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                ModuleText.getIconMenu(e.id.toString()),
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            )
          : SizedBox(),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(
            MESSAGES.BACK_TO_EXIT,
            style: AppStyle.DEFAULT_16.copyWith(color: COLORS.WHITE),
          ),
        ),
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
                      isAvatar: true,
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
                      isAvatar: true,
                      image: '',
                      width: 50,
                      height: 50,
                      borderRadius: 25,
                    ),
                  ),
                );
              }
            }),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listMenu.length % 2 != 0
                            ? listMenu.length - 1
                            : listMenu.length,
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
                    if (listMenu.length % 2 != 0)
                      GestureDetector(
                        onTap: listMenu.last.onTap,
                        child: Container(
                            margin: EdgeInsets.only(top: 25),
                            width: (MediaQuery.of(context).size.width - 50),
                            height:
                                (MediaQuery.of(context).size.width - 75) / 2,
                            child: ItemMenu(
                              data: listMenu.last,
                              isLast: true,
                            )),
                      ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
