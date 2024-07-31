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
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import '../bloc/login/login_bloc.dart';
import '../../l10n/key_text.dart';
import '../src/app_const.dart';
import '../storages/share_local.dart';
import '../widgets/widget_fingerprint_faceid.dart';
import 'menu/form/add_service_voucher/add_service_voucher_screen.dart';
import 'menu/menu_left/menu_drawer/main_drawer.dart';

class ScreenMain extends StatefulWidget {
  @override
  _ScreenMainState createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  final _key = GlobalKey<ExpandableFabState>();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  List<ButtonMenuModel> _listMenu = [];
  late LoginBloc _blocLogin;

  void getMenu() async {
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

  _handelRouterMenuPlus(String id, String name) {
    if (ModuleText.CUSTOMER == id) {
      AppNavigator.navigateForm(
        title: '${getT(KeyT.add)}'
            ' ${name.toLowerCase()} ${getT(KeyT.individual)}',
        type: ADD_CUSTOMER,
      );
    } else if (ModuleText.DAU_MOI == id) {
      AppNavigator.navigateForm(title: name, type: ADD_CLUE);
    } else if (ModuleText.LICH_HEN == id) {
      AppNavigator.navigateForm(title: name, type: ADD_CHANCE);
    } else if (ModuleText.HOP_DONG_FLASH == id) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddServiceVoucherScreen(
                title: name.toUpperCase().capitalizeFirst ?? '',
              )));
    } else if (ModuleText.HOP_DONG == id) {
      AppNavigator.navigateForm(
        title: name.toUpperCase().capitalizeFirst ?? '',
        type: ADD_CONTRACT,
      );
    } else if (ModuleText.CONG_VIEC == id) {
      AppNavigator.navigateForm(title: name, type: ADD_JOB);
    } else if (ModuleText.CSKH == id) {
      AppNavigator.navigateForm(title: name, type: ADD_SUPPORT);
    } else if (ModuleText.THEM_MUA_XE == id) {
      //todo
    } else if (ModuleText.THEM_BAN_XE == id) {
      //todo
    }
  }
  //////////////////////

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
    getMenu();
    _blocLogin.getListMenuFlash();
    _blocLogin.getChiNhanh();
    super.initState();
  }

  void _showFaceId() async {
    final bool showDialogFaceID =
        await (shareLocal.getString(PreferencesKey.SHOW_LOGIN_FINGER_PRINT) ??
                "true") ==
            "true";
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
          getMenu();
          _blocLogin.getListMenuFlash();
        },
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _blocLogin.listMenuFlash.isNotEmpty
          ? ExpandableFab(
              key: _key,
              distance: 65,
              type: ExpandableFabType.up,
              child: Icon(Icons.add, size: 40),
              closeButtonStyle: const ExpandableFabCloseButtonStyle(
                child: Icon(Icons.close),
                foregroundColor: COLORS.WHITE,
                backgroundColor: COLORS.ff1AA928,
              ),
              backgroundColor: COLORS.ff1AA928,
              overlayStyle: ExpandableFabOverlayStyle(
                blur: 5,
              ),
              children: _blocLogin.listMenuFlash.reversed
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
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: COLORS.WHITE,
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
                              color: COLORS.WHITE,
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
                : _main(),
          ],
        ),
      ),
    );
  }

  _main() => Container(
        padding: EdgeInsets.all(8),
        child: Wrap(
          children: _listMenu.asMap().entries.map((entry) {
            final value = entry.value;
            final i = entry.key;
            final hAll = MediaQuery.of(context).size.height -
                AppValue.heightsAppBar -
                MediaQuery.of(context).padding.top -
                16;
            final wAll = MediaQuery.of(context).size.width - 16;
            final h = hAll / (_listMenu.length / 2).ceil();
            final w = (wAll / 2);
            bool isMaxWidth = false;
            if (_listMenu.length % 2 != 0) {
              isMaxWidth = (i + 1) == _listMenu.length;
            }
            return WidgetAnimator(
              incomingEffect: WidgetTransitionEffects.incomingScaleDown(
                duration: Duration(milliseconds: 800),
              ),
              child: Container(
                height: h,
                width: isMaxWidth ? wAll : w,
                padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: value.backgroundColor,
                    minimumSize: Size(0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          10,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () => value.onTap(),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        right: 0,
                        left: 0,
                        child: SizedBox(
                          width: (isMaxWidth ? wAll : w) - 16,
                          child: Text(
                            value.title,
                            style: AppStyle.DEFAULT_16_BOLD.copyWith(
                              color: isMaxWidth ? COLORS.WHITE : null,
                              fontSize: isMaxWidth ? 20 : null,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Image.asset(
                          ICONS.IC_NEXT_SCREEN_PNG,
                          height: 32,
                          color: isMaxWidth ? COLORS.WHITE : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );

  @override
  void dispose() {
    _blocLogin.dispose();
    super.dispose();
  }
}
