import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/widgets/widget_button.dart';
import '../../../../bloc/get_infor_acc/get_infor_acc_bloc.dart';
import '../../../../models/button_menu_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/widget_text.dart';
import 'widget_item_list_menu.dart';

class MainDrawer extends StatefulWidget {
  final Function? onPress;

  const MainDrawer({this.onPress});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  List<ButtonMenuModel> listMenu = [];
  List _elements = [];

  @override
  void initState() {
    getMenu();
    super.initState();
  }

  getMenu() async {
    _elements.add({
      'id': '1',
      'title': AppLocalizations.of(Get.context!)?.home_page??'',
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
          'id': 'report',
          'title':  AppLocalizations.of(Get.context!)?.report,
          'image': ICONS.IC_REPORT_PNG,
          'group': '1',
          'isAdmin': false
        },
        {
          'id': '2',
          'title': AppLocalizations.of(Get.context!)?.account_information,
          'image': ICONS.IC_USER_PNG,
          'group': '1',
          'isAdmin': false
        },
        {
          'id': '3',
          'title': AppLocalizations.of(Get.context!)?.introduce,
          'image': ICONS.IC_ABOUT_US_PNG,
          'group': '1',
          'isAdmin': false,
        },
        {
          'id': '4',
          'title': AppLocalizations.of(Get.context!)?.policy_terms,
          'image': ICONS.IC_POLICY_PNG,
          'group': '1',
          'isAdmin': false,
        },
        {
          'id': '5',
          'title': AppLocalizations.of(Get.context!)?.change_password,
          'image': ICONS.IC_CHANGE_PASS_WORK_PNG,
          'group': '1',
          'isAdmin': false,
        },
      ]
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: COLORS.WHITE,
      width: AppValue.widths * 0.85,
      height: AppValue.heights,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(top: 35, left: 10),
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
                              children: [
                                WidgetText(
                                  title: state.inforAcc.fullname ?? '',
                                  style: AppStyle.DEFAULT_16_BOLD.copyWith(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600),
                                ),
                                AppValue.vSpaceTiny,
                                WidgetText(
                                  title: state.inforAcc.email ?? '',
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
                          image: "",
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
              )),
          SizedBox(
            height: 10,
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
                                onTap: () => widget.onPress!(_elements[index]),
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
                    AuthenticationBloc.of(context)
                        .add(AuthenticationLogoutRequested());
                    LoginBloc.of(context).logout(context);
                  });
            },
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            text: AppLocalizations.of(Get.context!)?.logout,
            textColor: Colors.black,
            backgroundColor: COLORS.GREY.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
