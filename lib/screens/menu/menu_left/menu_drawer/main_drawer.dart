import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/screens/menu/menu_left/setting/setting_screen.dart';
import 'package:gen_crm/widgets/widget_button.dart';
import '../../../../bloc/get_infor_acc/get_infor_acc_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../models/button_menu_model.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/widget_text.dart';
import 'widget_item_list_menu.dart';

class MainDrawer extends StatefulWidget {
  final Function onPress;
  final Function onReload;

  const MainDrawer({
    required this.onPress,
    required this.onReload,
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
      'id': '1',
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
          'id': 'setting',
          'title': getT(KeyT.setting),
          'image': ICONS.IC_SETTING_PNG,
          'group': '1',
          'isAdmin': false
        },
      ]
    ];
    setState(() {});
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
            color: COLORS.SECONDS_COLOR,
            height: AppValue.heights * 0.18,
            child: BlocBuilder<GetInforAccBloc, GetInforAccState>(
              builder: (context, state) {
                if (state is UpdateGetInforAccState) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WidgetNetworkImage(
                        isAvatar: true,
                        image: state.inforAcc.avatar ?? "",
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
                                title: state.inforAcc.fullname ?? '',
                                style: AppStyle.DEFAULT_16_BOLD.copyWith(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600),
                              ),
                              AppValue.vSpaceTiny,
                              WidgetText(
                                title: state.inforAcc.department_name ?? '',
                                style: AppStyle.DEFAULT_16.copyWith(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400),
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
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WidgetNetworkImage(
                        isAvatar: true,
                        image: '',
                        width: 75,
                        height: 75,
                        borderRadius: 75,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetText(
                              title: '',
                              style: AppStyle.DEFAULT_16_BOLD.copyWith(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600),
                            ),
                            AppValue.vSpaceTiny,
                            WidgetText(
                              title: '',
                              style: AppStyle.DEFAULT_16.copyWith(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Expanded(
              child: _elements.length > 0
                  ? ListView.builder(
                      itemCount: _elements.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (_elements[index]['id'] == 'setting') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SettingScreen(
                                          onSelectLang: () {
                                            getMenu();
                                            isReload = true;
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    widget.onPress(_elements[index]);
                                  }
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
                  : SizedBox()),
          WidgetButton(
            onTap: () {
              ShowDialogCustom.showDialogBase(
                  colorButton2: COLORS.GREY.withOpacity(0.5),
                  colorButton1: COLORS.SECONDS_COLOR,
                  onTap2: () {
                    AppNavigator.navigateLogout();
                    AuthenticationBloc.of(context)
                        .add(AuthenticationLogoutRequested());
                    LoginBloc.of(context).logout(context);
                  });
            },
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            text: getT(KeyT.logout),
            textColor: COLORS.BLACK,
            backgroundColor: COLORS.GREY.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
