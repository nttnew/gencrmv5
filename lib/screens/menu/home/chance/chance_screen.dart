import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/widgets.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import 'widget_chance_item.dart';

class ChanceScreen extends StatefulWidget {
  const ChanceScreen({Key? key}) : super(key: key);

  @override
  State<ChanceScreen> createState() => _ChanceScreenState();
}

class _ChanceScreenState extends State<ChanceScreen> {

  int page=1;
  String total='';
  int lenght=0;
  List<ListChanceData> listChanceData=[];
  String idFilter="";
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String search='';

  ScrollController _scrollController=ScrollController();

  @override
  void initState() {
    GetListUnReadNotifiBloc.of(context).add(CheckNotification());
    GetListChanceBloc.of(context).add(InitGetListOrderEventChance('', 1, ''));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent && lenght<int.parse(total)) {
        GetListChanceBloc.of(context).add(InitGetListOrderEventChance(idFilter, page+1, search,isLoadMore: true));
        page = page + 1;
      } else {
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(onPress: handleOnPressItemMenu),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      body: Column(
        children: [
          WidgetAppbar(
            title: Get.arguments,
            textColor: Colors.black,
            left: Padding(
              padding: EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: (){
                  if (_drawerKey.currentContext != null && !_drawerKey.currentState!.isDrawerOpen) {
                    _drawerKey.currentState!.openDrawer();
                  }
                },
                child: Image.asset('assets/icons/Menu.png'),
              ),
            ),
            right: GestureDetector(
              onTap: (){AppNavigator.navigateNotification();},
              child: BlocBuilder<GetListUnReadNotifiBloc,UnReadListNotifiState>(
                  builder: (context,state){
                    if(state is NotificationNeedRead){
                      return SvgPicture.asset("assets/icons/notification.svg");
                    }
                    else{
                      return SvgPicture.asset("assets/icons/notification2.svg");
                    }
                  }
              )
            ),
          ),
          AppValue.vSpaceTiny,
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: _buildSearch(),
          ),
          BlocBuilder<GetListChanceBloc, ChanceState>(
              builder: (context, state) {
                if (state is UpdateGetListChanceState){
                  total=state.total;
                  lenght=state.listChanceData.length;
                  // listChanceData=state.listChanceData;
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: ()=>Future.delayed(Duration(milliseconds: 300),(){
                        GetListChanceBloc.of(context).add(InitGetListOrderEventChance('', 1, ''));
                      }),
                      child: ListView.separated(
                        padding: EdgeInsets.only(top: 16),
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: state.listChanceData.length,
                        itemBuilder: (context, index) {
                          return WidgetItemChance(listChanceData: state.listChanceData[index],);
                          // return GestureDetector(
                          //   onTap: (){AppNavigator.navigateInfoChance();},
                          //   child: Container(
                          //     margin: EdgeInsets.only(left: 25,right: 25,bottom: 20),
                          //     padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                          //     decoration: BoxDecoration(
                          //       color: COLORS.WHITE,
                          //       borderRadius: BorderRadius.circular(20),
                          //       border: Border.all(width: 1,color: Colors.white),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: COLORS.BLACK.withOpacity(0.1),
                          //           spreadRadius: 1, blurRadius: 5,)],
                          //     ),
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Row(
                          //           children: [
                          //             Image.asset('assets/icons/Chance.png'),
                          //             SizedBox(width: 10,),
                          //             SizedBox(
                          //                 width: AppValue.widths*0.6,
                          //                 child: WidgetText(title:state.listChanceData[index].name!,style: AppStyle.DEFAULT_TITLE_PRODUCT.copyWith(color: COLORS.TEXT_COLOR),)),
                          //             Spacer(),
                          //             // Container(
                          //             //   decoration: BoxDecoration(
                          //             //       color: HexColor(state.listChanceData[index].color!),
                          //             //       borderRadius: BorderRadius.circular(99)),
                          //             //   width: AppValue.widths * 0.1,
                          //             //   height: AppValue.heights * 0.02,
                          //             // )
                          //           ],
                          //         ),
                          //         SizedBox(height: 15,),
                          //         Row(
                          //           children: [
                          //             SvgPicture.asset('assets/icons/User.svg'),
                          //             SizedBox(width: 10,),
                          //             SizedBox(
                          //                 width: AppValue.widths*0.7,
                          //                 child: Text(state.dataCustomer[index].name!,style: AppStyle.DEFAULT_LABEL_PRODUCT,)),
                          //   ],
                          //         ),
                          //         SizedBox(height: 15,),
                          //         Row(
                          //           children: [
                          //             SvgPicture.asset('assets/icons/dangxuly.svg'),
                          //             SizedBox(width: 10,),
                          //             Text('??ang x??? l??',style:  AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(color: COLORS.TEXT_COLOR)),
                          //           ],
                          //         ),
                          //         SizedBox(height: 15,),
                          //         Row(
                          //           children: [
                          //             Image.asset('assets/icons/date.png'),
                          //             SizedBox(width: 10,),
                          //             Text('25/05/2022',style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(color: COLORS.TEXT_COLOR)),
                          //             Spacer(),
                          //             SvgPicture.asset('assets/icons/Mess.svg'),
                          //           ],
                          //         ),
                          //         AppValue.hSpaceTiny,
                          //       ],
                          //     ),
                          //   ),
                          // );
                        },
                        separatorBuilder: (BuildContext context,
                            int index) => const SizedBox(),
                      ),
                    ),
                  );
              }
                else return Expanded(child: Center(
                  child: WidgetText(title:'Kh??ng c?? d??? li???u',style: AppStyle.DEFAULT_18_BOLD,),
                ));
              }
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<GetListChanceBloc, ChanceState>(
          builder: (context, state) {
            if (state is UpdateGetListChanceState)
              return Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: FloatingActionButton(
                  backgroundColor: Color(0xff1AA928),
                  onPressed: () {
                    // AppNavigator.navigateAddChance(state.listChanceData.first.id!);
                    AppNavigator.navigateFormAdd('Th??m c?? h???i',3);
                    },
                  child: Icon(Icons.add,size: 40),
                ),
        );
            else return Container();
          }
       ),
    );
  }
  _buildSearch(){
    return BlocBuilder<GetListChanceBloc, ChanceState>(
        builder: (context, state) {
          if (state is UpdateGetListChanceState)
            return Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: COLORS.COLORS_BA, width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: COLORS.WHITE),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Center(child:
                      Container(
                        height: 25, width: 25,
                        child: SvgPicture.asset('assets/icons/Search.svg',
                          color: COLORS.GREY.withOpacity(0.5),),)),
                  ),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        style: AppStyle.DEFAULT_14,
                        onChanged: (text){
                          search=text;
                        },
                        onEditingComplete: (){
                          GetListChanceBloc.of(context).add(InitGetListOrderEventChance(idFilter, 1, search));
                        },
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: MESSAGES.SEARCH_CHANCE,
                          hintStyle: AppStyle.DEFAULT_14.copyWith(
                              color: Color(0xff707070)),
                          // errorText: errorText,
                          // errorStyle: AppStyle.DEFAULT_12.copyWith(color: COLORS.RED),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1, height: 50,
                    margin: EdgeInsets.only(right: 15),
                    color: COLORS.COLORS_BA,),
                  GestureDetector(
                    onTap: (){
                      showBotomSheet(state.listFilter);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Container(height: 20,
                        width: 20,
                        child: SvgPicture.asset('assets/icons/Filter.svg'),),
                    ),
                  ),
                ],
              ),

          );
          else
            return Container();
        });
  }
  handleOnPressItemMenu(value) async {
    switch (value['id']){
      case '1':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateMain();
        break;
      case 'opportunity':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateChance(value['title']);
        break;
      case 'job':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateWork(value['title']);
        break;
      case 'contract':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateContract(value['title']);
        break;
      case 'support':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateSupport(value['title']);
        break;
      case 'customer':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateCustomer(value['title']);
        break;
      case 'contact':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateClue(value['title']);
        break;
      case 'report':
        _drawerKey.currentState!.openEndDrawer();
        String? money = await shareLocal.getString(PreferencesKey.MONEY);
        AppNavigator.navigateReport(money ?? "??");
        break;
      case '2':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateInformationAccount();
        break;
      case '3':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateAboutUs();
        break;
      case '4':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigatePolicy();
        break;
      case '5':
        _drawerKey.currentState!.openEndDrawer();
        AppNavigator.navigateChangePassword();
        break;
      default:
        break;
    }
  }

  showBotomSheet(List<FilterChance> dataFilter) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        elevation: 2,
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SafeArea(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: WidgetText(
                          title: 'Ch???n l???c',
                          textAlign: TextAlign.center,
                          style: AppStyle.DEFAULT_16_BOLD,
                        ),
                      ),
                      Column(
                        children: List.generate(
                            dataFilter.length,
                                (index) => GestureDetector(
                              onTap: () {
                                idFilter=dataFilter[index].id.toString();
                                Get.back();
                                GetListChanceBloc.of(context).add(InitGetListOrderEventChance(dataFilter[index].id.toString(), 1, search));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: COLORS.LIGHT_GREY))),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/Filter.svg',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        child: Container(
                                          child: WidgetText(
                                            title: dataFilter[index].name ?? '',
                                            style: AppStyle.DEFAULT_16,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
