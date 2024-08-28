import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/screens/menu_left/setting/setting_screen.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../bloc/get_infor_acc/get_infor_acc_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../models/button_menu_model.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/widget_text.dart';
import 'widget_item_list_menu.dart';

class MainDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> drawerKey;
  final Function onReload;
  final String moduleMy;

  const MainDrawer({
    required this.drawerKey,
    required this.onReload,
    required this.moduleMy,
  });

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  List<ButtonMenuModel> listMenu = [];
  List _elements = [];
  bool isReload = false;

  @override
  void initState() {
    getMenu();
    super.initState();
  }

  @override
  void dispose() {
    if (isReload) widget.onReload();
    super.dispose();
  }

  getMenu() async {
    _elements = [];
    _elements.add({
      'id': ModuleMy.HOME,
      'title': getT(KeyT.home_page),
      'image': ICONS.IC_MENU_HOME_PNG,
      'group': '1',
      'isAdmin': false,
    });
    String menu = await shareLocal.getString(PreferencesKey.MENU);
    List listM = jsonDecode(menu);
    for (int i = 0; i < listM.length; i++) {
      _elements.add({
        'id': listM[i]['id'],
        'title': listM[i]['name'],
        'image': ModuleMy.getIcon(listM[i]['id']),
        'group': '1',
        'isAdmin': false,
      });
    }
    _elements = [
      ..._elements,
      ...[
        {
          'id': ModuleMy.REPORT,
          'title': getT(KeyT.report),
          'image': ICONS.IC_REPORT_PNG,
          'group': '1',
          'isAdmin': false
        },
        {
          'id': ModuleMy.SETTING,
          'title': getT(KeyT.setting),
          'image': ICONS.IC_SETTING_PNG,
          'group': '1',
          'isAdmin': false
        },
      ]
    ];
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: COLORS.WHITE,
      width: AppValue.widths * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 35,
              left: 10,
              right: 10,
            ),
            decoration: BoxDecoration(
              color: getBackgroundWithIsCar(),
            ),
            height: AppValue.heights * 0.18,
            child: BlocBuilder<GetInfoAccBloc, GetInfoAccState>(
              builder: (context, state) {
                String avatar = '';
                String? title;
                String? departmentName;
                if (state is UpdateGetInfoAccState) {
                  avatar = state.infoAcc.avatar ?? '';
                  title = isCarCrm()
                      ? state.infoAcc.ten_viet_tat
                      : state.infoAcc.fullname;
                  departmentName = state.infoAcc.department_name;
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WidgetNetworkImage(
                      isAvatar: true,
                      image: avatar,
                      width: 75,
                      height: 75,
                      borderRadius: 75,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WidgetText(
                              title: title,
                              style: AppStyle.DEFAULT_16_BOLD.copyWith(
                                color: isCarCrm() ? COLORS.WHITE : null,
                              ),
                              maxLine: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AppValue.vSpaceTiny,
                            WidgetText(
                              title: departmentName,
                              style: AppStyle.DEFAULT_16.copyWith(
                                color: isCarCrm() ? COLORS.WHITE : null,
                              ),
                              maxLine: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: _elements.length > 0
                ? ListView.builder(
                    padding: EdgeInsets.only(
                      top: 16,
                    ),
                    itemCount: _elements.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                if (widget.moduleMy != _elements[index]['id'])
                                  _handleOnPressItemMenu(
                                    widget.drawerKey,
                                    _elements[index],
                                  );
                                widget.drawerKey.currentState!.openEndDrawer();
                              },
                              child: WidgetItemListMenu(
                                icon: _elements[index]['image'],
                                title: _elements[index]['title'],
                              ),
                            ),
                            AppValue.vSpaceSmall,
                          ],
                        ),
                      );
                    },
                  )
                : SizedBox.shrink(),
          ),
          ButtonCustom(
            paddingAll: 10,
            backgroundColor: COLORS.GREY.withOpacity(0.5),
            title: getT(KeyT.logout),
            onTap: () {
              ShowDialogCustom.showDialogBase(
                  colorButton2: COLORS.GREY.withOpacity(0.5),
                  colorButton1: getBackgroundWithIsCar(),
                  onTap2: () {
                    AppNavigator.navigateLogout();
                    AuthenticationBloc.of(context).add(
                      AuthenticationLogoutRequested(),
                    );
                    LoginBloc.of(context).logout(context);
                  });
            },
          ),
        ],
      ),
    );
  }

  _handleOnPressItemMenu(
    GlobalKey<ScaffoldState> _drawerKey,
    value,
  ) async {
    switch (value['id']) {
      case ModuleMy.HOME:
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateMain();
        break;
      case ModuleMy.LICH_HEN:
        _drawerKey.currentState!.openEndDrawer();
        _checkScreenPush(_drawerKey, ROUTE_NAMES.CHANCE);

        break;
      case ModuleMy.CONG_VIEC:
        _checkScreenPush(_drawerKey, ROUTE_NAMES.WORK);

        break;
      case ModuleMy.HOP_DONG:
        _checkScreenPush(_drawerKey, ROUTE_NAMES.CONTRACT);

        break;
      case ModuleMy.CSKH:
        _checkScreenPush(_drawerKey, ROUTE_NAMES.SUPPORT);

        break;
      case ModuleMy.CUSTOMER:
        _checkScreenPush(_drawerKey, ROUTE_NAMES.CUSTOMER);

        break;
      case ModuleMy.DAU_MOI:
        _checkScreenPush(_drawerKey, ROUTE_NAMES.CLUE);

        break;
      case ModuleMy.REPORT:
        _checkScreenPush(_drawerKey, ROUTE_NAMES.REPORT);

        break;
      case ModuleMy.SAN_PHAM:
        _checkScreenPush(_drawerKey, ROUTE_NAMES.PRODUCT);
        break;
      case ModuleMy.SETTING:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SettingScreen(
              onSelectLang: () {
                getMenu();
                isReload = true;
                if (isReload) widget.onReload();
              },
            ),
          ),
        );
        break;
      case ModuleMy.SAN_PHAM_KH:
        _checkScreenPush(_drawerKey, ROUTE_NAMES.PRODUCT_CUSTOMER);
        break;
      default:
        break;
    }
  }

  _checkScreenPush(_drawerKey, String routeName) {
    _drawerKey.currentState!.openEndDrawer();
    if (widget.moduleMy == ModuleMy.HOME) {
      Get.toNamed(routeName);
    } else {
      Get.offNamed(routeName);
    }
  }
}
