import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/models/model_generator/infor_acc.dart';
import 'package:gen_crm/widgets/widget_button.dart';

import '../../../../bloc/authen/authentication_bloc.dart';
import '../../../../bloc/get_infor_acc/get_infor_acc_bloc.dart';
import '../../../../models/button_menu_model.dart';
import '../../../../src/models/model_generator/login_response.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/widget_cached_image.dart';
// import 'package:grouped_list/grouped_list.dart';
import '../../../../widgets/widget_dialog.dart';
import '../../../../widgets/widget_text.dart';
import 'widget_item_list_menu.dart'; // ignore: import_of_legacy_library_into_null_safe

class MainDrawer extends StatefulWidget {
  final Function? onPress;

  const MainDrawer({this.onPress});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

  List<ButtonMenuModel> listMenu = [];
  List _elements=[];

  @override
  void initState() {
    getMenu();
    super.initState();
  }

  getMenu()async{
    _elements.add({
      'id':'1',
      'title': MESSAGES.MAIN,
      'image': ICONS.MENU_HOME,
      'group': '1',
      'isAdmin': false,
    });
    String menu=await shareLocal.getString(PreferencesKey.MENU);
    List listM=jsonDecode(menu);
    for(int i=0;i<listM.length;i++){
      _elements.add({
        'id':listM[i]['id'],
        'title': listM[i]['name'],
        'image': listM[i]['id']=='opportunity'?ICONS.CHANCE:
        listM[i]['id']=='job'?ICONS.WORK:
        listM[i]['id']=='contract'?ICONS.CONTRACT:
        listM[i]['id']=='support'?ICONS.SUPPORT:
        listM[i]['id']=='customer'?ICONS.CUSTUMER:
        ICONS.CLUE,
        'group': '1',
        'isAdmin': false,
      });
      // listMenu.add(
      //   ButtonMenuModel(
      //       title: listM[i]['name'],
      //       image:listM[i]['id']=='opportunity'?ICONS.CHANCE:
      //       listM[i]['id']=='job'?ICONS.WORK:
      //       listM[i]['id']=='contract'?ICONS.CONTRACT:
      //       listM[i]['id']=='support'?ICONS.SUPPORT:
      //       listM[i]['id']=='customer'?ICONS.CUSTUMER:
      //       ICONS.CLUE,
      //       backgroundColor:listM[i]['id']=='opportunity'?Color(0xffFDC9D2):
      //       listM[i]['id']=='job'?Color(0xffFF993A):
      //       listM[i]['id']=='contract'?Color(0xffFFC000):
      //       listM[i]['id']=='support'?Color(0xff8AC53E):
      //       listM[i]['id']=='customer'?Color(0xff369FFF):
      //       Color(0xffA5A6F6),
      //       onTap: (){
      //         if(listM[i]['id']=='opportunity'){
      //           AppNavigator.navigateChance(listM[i]['name']);
      //         }
      //         else if(listM[i]['id']=='job'){
      //           AppNavigator.navigateWork(listM[i]['name']);
      //         }
      //         else if(listM[i]['id']=='contract'){
      //           AppNavigator.navigateContract(listM[i]['name']);
      //         }
      //         else if(listM[i]['id']=='support'){
      //           AppNavigator.navigateSupport(listM[i]['name']);
      //         }
      //         else if(listM[i]['id']=='customer'){
      //           AppNavigator.navigateCustomer(listM[i]['name']);
      //         }
      //         else{
      //           AppNavigator.navigateClue(listM[i]['name']);
      //         }
      //       }),
      // );
    }
    _elements=[..._elements,...[
      {
        'id':'report',
        'title': 'Báo cáo',
        'image': ICONS.WORK,
        'group': '1',
        'isAdmin': false
      },
      {
        'id':'2',
        'title': MESSAGES.INFORMATION_ACCOUNT,
        'image': ICONS.ICON_USER,
        'group': '1',
        'isAdmin': false
      },
      {
      'id':'3',
        'title': MESSAGES.MENU_INTRODUCE,
        'image': ICONS.ICONS_ABOUT_US,
        'group': '1',
        'isAdmin': false,
      },
      {
        'id':'4',
        'title': MESSAGES.POLICY,
        'image': ICONS.ICON_POLICY,
        'group': '1',
        'isAdmin': false,
      },
      {
        'id':'5',
        'title': MESSAGES.CHANGE_PASSWORD,
        'image': ICONS.ICON_CHANGEPASSWORK,
        'group': '1',
        'isAdmin': false,
      },
    ]];
    setState((){});
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
              child:_elements.length>0?
              ListView.builder(
                itemCount: _elements.length,
                itemBuilder: (BuildContext context,int index){
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
              ):
              SizedBox()),
          WidgetButton(
            onTap: () {
              ShowDialogCustom.showDialogTwoButton(onTap2: () {
                AuthenticationBloc.of(context)
                    .add(AuthenticationLogoutRequested());
              });
            },
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            text: MESSAGES.LOG_OUT,
            textColor: Colors.black,
            backgroundColor: COLORS.SECONDS_COLOR,
          ),
        ],
      ),
    );
  }

  _showDialog() {
    return WidgetDialog(
      onTap1: () => AppNavigator.navigateBack(),
      onTap2: () => AppNavigator.navigateBack(),
      title: 'Bạn chắc chắn muốn đăng xuất ?',
    );
  }
}
