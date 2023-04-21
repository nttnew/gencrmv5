import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/contract/contract_bloc.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/contract.dart';
import '../../../../src/models/model_generator/customer.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../../../widgets/widget_search.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({Key? key}) : super(key: key);

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  int page = 1;
  String total = "0";
  int lenght = 0;
  String idFilter = "";
  String title = "";
  String search = "";
  TextEditingController _editingController = TextEditingController();
  bool isCheck = true;

  @override
  void initState() {
    GetListUnReadNotifiBloc.of(context).add(CheckNotification());
    ContractBloc.of(context).add(InitGetContractEvent(page, "", ""));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          lenght < int.parse(total)) {
        ContractBloc.of(context).add(InitGetContractEvent(
            page + 1, _editingController.text, idFilter,
            isLoadMore: true));
        page = page + 1;
      } else {}
    });
    title = Get.arguments;
    super.initState();
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(onPress: (v) => handleOnPressItemMenu(_drawerKey, v)),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      body: Column(
        children: [
          WidgetAppbar(
            title: Get.arguments,
            textColor: Colors.black,
            left: Padding(
              padding: EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  if (_drawerKey.currentContext != null &&
                      !_drawerKey.currentState!.isDrawerOpen) {
                    _drawerKey.currentState!.openDrawer();
                  }
                },
                child: Image.asset(ICONS.IC_MENU_PNG),
              ),
            ),
            right: GestureDetector(onTap: () {
              AppNavigator.navigateNotification();
            }, child:
                BlocBuilder<GetListUnReadNotifiBloc, UnReadListNotifiState>(
                    builder: (context, state) {
              if (state is NotificationNeedRead) {
                return SvgPicture.asset(ICONS.IC_NOTIFICATION_SVG);
              } else {
                return SvgPicture.asset(ICONS.IC_NOTIFICATION2_SVG);
              }
            })),
          ),
          AppValue.vSpaceSmall,
          _buildSearch(),
          AppValue.vSpaceSmall,
          BlocBuilder<ContractBloc, ContractState>(builder: (context, state) {
            if (state is UpdateGetContractState) {
              total = state.total;
              lenght = state.listContract.length;
              return Expanded(
                  child: RefreshIndicator(
                onRefresh: () =>
                    Future.delayed(Duration(milliseconds: 250), () {
                  ContractBloc.of(context)
                      .add(InitGetContractEvent(page, "", ""));
                }),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: List.generate(state.listContract.length,
                        (index) => _buildCustomer(state.listContract[index])),
                  ),
                ),
              ));
            } else
              return Container();
          }),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: Color(0xff1AA928),
          onPressed: () {
            AppNavigator.navigateAddContract(title: title.toLowerCase());
          },
          child: Icon(Icons.add, size: 40),
        ),
      ),
    );
  }

  _buildSearch() {
    return BlocBuilder<ContractBloc, ContractState>(builder: (context, state) {
      if (state is UpdateGetContractState)
        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: AppValue.widths * 0.05,
              vertical: AppValue.heights * 0.02),
          width: double.infinity,
          height: AppValue.heights * 0.06,
          decoration: BoxDecoration(
            border: Border.all(color: HexColor("#DBDBDB")),
            borderRadius: BorderRadius.circular(10),
          ),
          child: WidgetSearch(
            inputController: _editingController,
            hintTextStyle: TextStyle(
                fontFamily: "Roboto",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: HexColor("#707070")),
            hint: "Tìm ${title.toLowerCase()}",
            leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
            endIcon: SvgPicture.asset(ICONS.IC_FILL_SVG),
            onClickRight: () {
              this.onClickFilter(state.listFilter);
            },
            onChanged: (text) {
              search = text;
            },
            onEditingComplete: () {
              ContractBloc.of(context).add(InitGetContractEvent(
                  page, _editingController.text, idFilter));
            },
          ),
        );
      else
        return Container();
    });
  }

  _buildCustomer(ContractItemData data) {
    return GestureDetector(
      onTap: () {
        AppNavigator.navigateInfoContract(data.id!, data.name!);
      },
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: COLORS.WHITE,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: COLORS.BLACK.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(ICONS.IC_CONTRACT_PNG),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: AppValue.widths * 0.5,
                    child: WidgetText(
                      title: data.name ?? '',
                      style: AppStyle.DEFAULT_TITLE_PRODUCT
                          .copyWith(color: COLORS.TEXT_COLOR),
                    )),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: data.status_color != ""
                          ? HexColor(data.status_color!)
                          : COLORS.RED,
                      borderRadius: BorderRadius.circular(99)),
                  width: AppValue.widths * 0.08,
                  height: AppValue.heights * 0.02,
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            if (data.customer?.name?.trim().isNotEmpty ?? false) ...[
              Row(
                children: [
                  SvgPicture.asset(
                    ICONS.IC_USER2_SVG,
                    color: Color(0xffE75D18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: WidgetText(
                      title: data.customer!.name ?? '',
                      style: AppStyle.DEFAULT_LABEL_PRODUCT,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
            ],
            if (data.status?.trim().isNotEmpty ?? false) ...[
              Row(
                children: [
                  SvgPicture.asset(
                    ICONS.IC_DANG_XU_LY_SVG,
                    color: data.status_color != ""
                        ? HexColor(data.status_color!)
                        : COLORS.RED,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  WidgetText(
                      title: data.status ?? '',
                      style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                        color: data.status_color != ""
                            ? HexColor(data.status_color!)
                            : COLORS.RED,
                      )),
                ],
              ),
              SizedBox(
                height: 8,
              ),
            ],
            Row(
              children: [
                SvgPicture.asset(
                  ICONS.IC_MAIL_SVG,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                WidgetText(
                  title: 'Tổng tiền: ' + '${data.price.toString()}' + 'đ',
                  style: AppStyle.DEFAULT_LABEL_PRODUCT
                      .copyWith(color: COLORS.GREY),
                ),
                Spacer(),
                SvgPicture.asset(ICONS.IC_QUESTION_SVG),
                SizedBox(
                  width: AppValue.widths * 0.01,
                ),
                WidgetText(
                  title: data.total_note.toString(),
                  style: TextStyle(
                    color: HexColor("#0052B4"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            AppValue.hSpaceTiny,
          ],
        ),
      ),
    );
  }

  void onClickFilter(List<FilterData> data) {
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: WidgetText(
                            title: 'Chọn lọc',
                            textAlign: TextAlign.center,
                            style: AppStyle.DEFAULT_16_BOLD,
                          ),
                        ),
                        Column(
                          children: List.generate(
                              data.length,
                              (index) => GestureDetector(
                                    onTap: () {
                                      Get.back();
                                      idFilter = data[index].id.toString();
                                      ContractBloc.of(context).add(
                                          InitGetContractEvent(
                                              page,
                                              _editingController.text,
                                              data[index].id.toString()));
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: COLORS.LIGHT_GREY))),
                                      child: Row(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            ICONS.IC_FILTER_SVG,
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
                                              title: data[index].name ?? '',
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
                ),
              );
            },
          );
        });
  }
}
