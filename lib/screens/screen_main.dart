import 'dart:convert';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gen_crm/bloc/get_infor_acc/get_infor_acc_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/src/models/model_generator/report_option.dart';
import 'package:gen_crm/src/models/model_generator/xe_dich_vu_response.dart';
import 'package:gen_crm/widgets/widget_appbar.dart';
import 'package:gen_crm/models/index.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import '../bloc/login/login_bloc.dart';
import '../../l10n/key_text.dart';
import '../src/app_const.dart';
import '../storages/share_local.dart';
import '../widgets/dialog_call.dart';
import '../widgets/item_menu.dart';
import '../widgets/listview_loadmore_base.dart';
import '../widgets/widget_fingerprint_faceid.dart';
import 'add_service_voucher/add_service_voucher_screen.dart';
import 'menu/menu_left/menu_drawer/main_drawer.dart';

class ScreenMain extends StatefulWidget {
  @override
  _ScreenMainState createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  final _key = GlobalKey<ExpandableFabState>();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  List<ButtonMenuModel> listMenu = [];
  late LoginBloc _blocLogin;

  void getMenu() async {
    listMenu = [];
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
      listMenu.add(
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
    listMenu.add(
      ButtonMenuModel(
          title: getT(KeyT.report),
          image: ICONS.IC_REPORT_PNG,
          backgroundColor: COLORS.ff5D5FEF,
          onTap: () {
            AppNavigator.navigateReport(
                shareLocal.getString(PreferencesKey.MONEY) ?? '');
          }),
    );
    setState(() {});
  }

  _handelRouterMenuPlus(String id, String name) {
    if (ModuleText.CUSTOMER == id) {
      AppNavigator.navigateAddCustomer('${getT(KeyT.add)}'
          ' ${name.toLowerCase()} ${getT(KeyT.individual)}');
    } else if (ModuleText.DAU_MOI == id) {
      AppNavigator.navigateFormAdd(name, ADD_CLUE);
    } else if (ModuleText.LICH_HEN == id) {
      AppNavigator.navigateFormAdd(name, ADD_CHANCE);
    } else if (ModuleText.HOP_DONG_FLASH == id) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddServiceVoucherScreen(
                title: name.toUpperCase().capitalizeFirst ?? '',
              )));
    } else if (ModuleText.HOP_DONG == id) {
      AppNavigator.navigateAddContract(
          title: name.toUpperCase().capitalizeFirst ?? '');
    } else if (ModuleText.CONG_VIEC == id) {
      AppNavigator.navigateFormAdd(name, ADD_JOB);
    } else if (ModuleText.CSKH == id) {
      AppNavigator.navigateFormAdd(name, ADD_SUPPORT);
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
    GetInforAccBloc.of(context).add(InitGetInforAcc());
    GetNotificationBloc.of(context).add(CheckNotification());
    GetNotificationBloc.of(context).add(
      InitGetListUnReadNotificationEvent(
        BASE_URL.PAGE_DEFAULT,
        isLoading: false,
      ),
    );
    getMenu();
    _blocLogin.getListMenuFlash();
    if (isCarCrm()) _blocLogin.getChiNhanh();
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
        onPress: (v) => handleOnPressItemMenu(_drawerKey, v),
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
            BlocBuilder<GetInforAccBloc, GetInforAccState>(
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
                      width: 50,
                      height: 50,
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
                      width: 50,
                      height: 50,
                      borderRadius: 25,
                    ),
                  ),
                );
              }
            }),
            isCarCrm() ? _mainCar() : _main(),
          ],
        ),
      ),
    );
  }

  _main() => Expanded(
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
                    height: (MediaQuery.of(context).size.width - 75) / 2,
                    child: ItemMenu(
                      data: listMenu.last,
                      isLast: true,
                    ),
                  ),
                ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      );

  _mainCar() {
    return Expanded(
      child: Column(
        children: [
          StreamBuilder<FilterResponse>(
              stream: _blocLogin.locationTimeStream,
              builder: (context, snapshot) {
                final listLocation = snapshot.data?.data?.diem_ban ?? [];
                final listTrangThai = snapshot.data?.data?.trangthaihd ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (listLocation.length > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton2(
                                value: _blocLogin.valueLocation ??
                                    listLocation.first[1],
                                icon:
                                    const Icon(Icons.arrow_drop_down_outlined),
                                underline: SizedBox.shrink(),
                                dropdownMaxHeight: 250,
                                onChanged: (String? value) {
                                  _blocLogin.valueLocation = value ?? '';
                                  _blocLogin.loadMoreControllerCar.reloadData();
                                  setState(() {});
                                },
                                items: listLocation
                                    .map(
                                      (items) => DropdownMenuItem<String>(
                                        onTap: () {
                                          _blocLogin.location = items.first;
                                        },
                                        value: items[1],
                                        child: FittedBox(
                                          child: Text(
                                            items[1],
                                            style: AppStyle.DEFAULT_18_BOLD,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList()),
                            GestureDetector(
                              onTap: () {
                                AppNavigator.navigateReport(shareLocal
                                        .getString(PreferencesKey.MONEY) ??
                                    '');
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: 16,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: COLORS.PRIMARY_COLOR,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      4,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  getT(KeyT.report),
                                  style: AppStyle.DEFAULT_16_BOLD,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 50,
                      ),
                      padding: EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                            left: 16,
                          ),
                          itemCount: listTrangThai.length,
                          itemBuilder: (context, i) {
                            final itemData = listTrangThai[i];
                            return GestureDetector(
                              onTap: () {
                                _blocLogin.valueTrangThai =
                                    itemData == _blocLogin.valueTrangThai
                                        ? null
                                        : itemData;
                                _blocLogin.loadMoreControllerCar.reloadData();

                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: 16,
                                ),
                                decoration: BoxDecoration(
                                  border: _blocLogin.valueTrangThai == itemData
                                      ? Border(
                                          bottom: BorderSide(
                                            color: COLORS.RED,
                                            width: 3,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Text(
                                  itemData.label ?? '',
                                  style: AppStyle.DEFAULT_16_T.copyWith(
                                    fontWeight:
                                        _blocLogin.valueTrangThai == itemData
                                            ? FontWeight.w700
                                            : null,
                                    color: _blocLogin.valueTrangThai == itemData
                                        ? null
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                );
              }),
          Expanded(
            child: ListViewLoadMoreBase(
              isInit: true,
              functionInit: (page, isInit) {
                return _blocLogin.getXeDichVu(
                  page: page,
                );
              },
              itemWidget: (int index, data) {
                return ItemCar(
                  data: data,
                  onTap: () {
                    //todo
                  },
                );
              },
              controller: _blocLogin.loadMoreControllerCar,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCar extends StatelessWidget {
  const ItemCar({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);
  final XeDichVu data;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        padding: EdgeInsets.all(
          16,
        ),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(
                0.3,
              ),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: Image.asset(
                    ICONS.IC_CAR_PNG,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: WidgetText(
                    title: data.bienSo ?? getT(KeyT.not_yet),
                    style: AppStyle.DEFAULT_18.copyWith(
                      color: COLORS.ff006CB1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: COLORS.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(
                      99,
                    ),
                  ),
                  child: WidgetText(
                    title: data.chiNhanh ?? getT(KeyT.not_yet),
                    style: AppStyle.DEFAULT_14.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            itemTextIcon(
              text: data.tenKhachHang ?? '',
              icon: ICONS.IC_USER2_SVG,
              colorIcon: COLORS.GREY,
            ),
            itemTextIcon(
              onTap: () {
                if (data.diDong != null && data.diDong != '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogCall(
                        phone: '${data.diDong}',
                        name: '${data.tenKhachHang}',
                      );
                    },
                  );
                }
              },
              text: data.diDong ?? getT(KeyT.not_yet),
              styleText: AppStyle.DEFAULT_14.copyWith(
                fontWeight: FontWeight.w400,
                color: COLORS.TEXT_BLUE_BOLD,
              ),
              icon: ICONS.IC_PHONE_CUSTOMER_SVG,
            ),
            itemTextIcon(
              text: data.trangThai ?? getT(KeyT.not_yet),
              icon: ICONS.IC_DANG_XU_LY_SVG,
              colorIcon: COLORS.GREY,
              styleText: AppStyle.DEFAULT_14.copyWith(
                color: COLORS.ORANGE,
              ),
            ),
            itemTextIcon(
              text: data.soPhieu ?? '',
              icon: ICONS.IC_CART_PNG,
              isSVG: false,
              colorIcon: COLORS.GREY,
            ),
          ],
        ),
      ),
    );
  }
}
