import 'dart:convert';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gen_crm/bloc/get_infor_acc/get_infor_acc_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/screens/main/main_car.dart';
import 'package:gen_crm/widgets/widget_appbar.dart';
import 'package:gen_crm/models/index.dart';
import 'package:gen_crm/src/src_index.dart';
import '../bloc/login/login_bloc.dart';
import '../../l10n/key_text.dart';
import '../src/app_const.dart';
import '../storages/share_local.dart';
import '../widgets/widget_fingerprint_faceid.dart';
import 'main/main_default.dart';
import 'menu/menu_left/menu_drawer/main_drawer.dart';
import 'menu/widget/floating_action_button.dart';

class ScreenMain extends StatefulWidget {
  @override
  _ScreenMainState createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  final _key = GlobalKey<ExpandableFabState>();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  List<ButtonMenuModel> _listMenu = [];
  late LoginBloc _blocLogin;

  @override
  void initState() {
    _blocLogin = LoginBloc.of(context);
    _showFaceId();
    GetInfoAccBloc.of(context).add(InitGetInforAcc(isLoading: false));
    UnreadNotificationBloc.of(context).add(CheckNotification(isLoading: false));
    UnreadNotificationBloc.of(context).add(
      InitGetListUnReadNotificationEvent(
        BASE_URL.PAGE_DEFAULT,
        isLoading: false,
      ),
    );
    _getMenu();
    _blocLogin.getListMenuFlash();
    _blocLogin.getChiNhanh();
    super.initState();
  }

  void _getMenu() async {
    _listMenu = [];
    _addMenuReport(isCarCrm());
    String menu = await shareLocal.getString(PreferencesKey.MENU);
    List listM = jsonDecode(menu);
    for (final value in listM) {
      String id = value['id'];
      String name = value['name'];
      if (id == ModuleMy.HOP_DONG) {
        String titleReport = name + ' ${getT(KeyT.doing)}';
        shareLocal.putString(PreferencesKey.NAME_REPORT, titleReport);
      } else if (id == ModuleMy.CUSTOMER) {
        shareLocal.putString(PreferencesKey.NAME_CUSTOMER, name);
      }
      _listMenu.add(
        ButtonMenuModel(
            title: name,
            image: ModuleMy.getIcon(id),
            backgroundColor: ModuleMy.getColor(id),
            onTap: () {
              if (id == ModuleMy.LICH_HEN) {
                AppNavigator.navigateChance();
              } else if (id == ModuleMy.CONG_VIEC) {
                AppNavigator.navigateWork();
              } else if (id == ModuleMy.HOP_DONG) {
                AppNavigator.navigateContract();
              } else if (id == ModuleMy.CSKH) {
                AppNavigator.navigateSupport();
              } else if (id == ModuleMy.CUSTOMER) {
                AppNavigator.navigateCustomer();
              } else if (id == ModuleMy.DAU_MOI) {
                AppNavigator.navigateClue();
              } else if (id == ModuleMy.SAN_PHAM) {
                AppNavigator.navigateProduct();
              } else if (id == ModuleMy.SAN_PHAM_KH) {
                AppNavigator.navigateProductCustomer();
              }
            }),
      );
    }
    _addMenuReport(!isCarCrm());
    setState(() {});
  }

  _addMenuReport(bool v) {
    if (v)
      _listMenu.add(
        ButtonMenuModel(
            title: getT(KeyT.report),
            image: ICONS.IC_REPORT_PNG,
            backgroundColor: COLORS.ff5D5FEF,
            onTap: () {
              AppNavigator.navigateReport();
            }),
      );
  }

  void _showFaceId() async {
    final bool showDialogFaceID =
        await (shareLocal.getString(PreferencesKey.SHOW_LOGIN_FINGER_PRINT) ??
                'true') ==
            'true';
    if (showDialogFaceID) {
      shareLocal.putString(PreferencesKey.SHOW_LOGIN_FINGER_PRINT, 'false');
      ShowDialogCustom.showDialogBase(
        content: getT(KeyT.turn_on_login_with_finger_print_faceid),
        child: WidgetFingerPrint(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(
        moduleMy: ModuleMy.HOME,
        drawerKey: _drawerKey,
        onReload: () {
          _getMenu();
          _blocLogin.getListMenuFlash();
        },
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: floatingActionButton(
        _key,
        _blocLogin.listMenuFlash,
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(
            getT(KeyT.press_again_to_exit),
            style: AppStyle.DEFAULT_16.copyWith(
              color: COLORS.WHITE,
            ),
          ),
        ),
        child: Column(
          children: [
            BlocBuilder<GetInfoAccBloc, GetInforAccState>(
                builder: (context, state) {
              if (state is UpdateGetInforAccState) {
                return WidgetAppbar(
                  title: isCarCrm()
                      ? state.inforAcc.ten_viet_tat
                      : state.inforAcc.fullname,
                  textColor: COLORS.BLACK,
                  right: rightAppBar(),
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
                      width: 45,
                      height: 45,
                      borderRadius: 25,
                    ),
                  ),
                );
              } else {
                return WidgetAppbar(
                  title: '',
                  textColor: COLORS.BLACK,
                  right: rightAppBar(),
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
                      width: 45,
                      height: 45,
                      borderRadius: 25,
                    ),
                  ),
                );
              }
            }),
            isCarCrm()
                ? MainCar(
                    listMenu: _listMenu,
                  )
                : MainDefault(
                    listMenu: _listMenu,
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _blocLogin.dispose();
    super.dispose();
  }
}
