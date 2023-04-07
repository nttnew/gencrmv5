import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../src/models/model_generator/customer.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/widget_search.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  int page = 1;
  int total = 0;
  int lenght = 0;
  List<CustomerData> listCustomer = [];
  String idFilter = "";

  @override
  void initState() {
    GetListUnReadNotifiBloc.of(context).add(CheckNotification());
    GetListCustomerBloc.of(context).add(InitGetListOrderEvent('', 1, ''));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          lenght < total) {
        GetListCustomerBloc.of(context).add(InitGetListOrderEvent(
            idFilter, page + 1, search,
            isLoadMore: true));
        page = page + 1;
      } else {}
    });
    super.initState();
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  String search = '';
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(onPress: handleOnPressItemMenu),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff1AA928),
        onPressed: () {
          showBotomSheet2();
        },
        child: Icon(Icons.add, size: 40),
      ),
      appBar: AppBar(
        toolbarHeight: AppValue.heights * 0.1,
        backgroundColor: HexColor("#D0F1EB"),
        centerTitle: false,
        title: WidgetText(
            title: Get.arguments,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
                fontSize: 16)),
        leading: Padding(
            padding: EdgeInsets.only(left: 40),
            child: InkWell(
                onTap: () {
                  if (_drawerKey.currentContext != null &&
                      !_drawerKey.currentState!.isDrawerOpen) {
                    _drawerKey.currentState!.openDrawer();
                  }
                },
                child: SvgPicture.asset("assets/icons/menu.svg"))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 30),
              child: InkWell(
                onTap: () => AppNavigator.navigateNotification(),
                child:
                    BlocBuilder<GetListUnReadNotifiBloc, UnReadListNotifiState>(
                        builder: (context, state) {
                  if (state is NotificationNeedRead) {
                    return SvgPicture.asset("assets/icons/notification.svg");
                  } else {
                    return SvgPicture.asset("assets/icons/notification2.svg");
                  }
                }),
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: AppValue.widths * 0.05,
                vertical: AppValue.heights * 0.02),
            width: double.infinity,
            height: AppValue.heights * 0.06,
            decoration: BoxDecoration(
              border: Border.all(color: HexColor("#DBDBDB")),
              borderRadius: BorderRadius.circular(10),
            ),
            child: BlocBuilder<GetListCustomerBloc, CustomerState>(
                builder: (context, state) {
              if (state is UpdateGetListCustomerState)
                return WidgetSearch(
                  hintTextStyle: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: HexColor("#707070")),
                  hint: "Tìm khách hàng",
                  leadIcon:
                      SvgPicture.asset("assets/icons/search_customer.svg"),
                  endIcon: SvgPicture.asset("assets/icons/fill_customer.svg"),
                  onClickRight: () {
                    showBotomSheet(state.listFilter);
                  },
                  onChanged: (text) {
                    search = text;
                  },
                  onEditingComplete: () {
                    GetListCustomerBloc.of(context)
                        .add(InitGetListOrderEvent(idFilter, 1, search));
                  },
                );
              else
                return Container();
            }),
          ),
          BlocBuilder<GetListCustomerBloc, CustomerState>(
              builder: (context, state) {
            if (state is UpdateGetListCustomerState) {
              total = state.total;
              lenght = state.listCustomer.length;
              listCustomer = state.listCustomer;
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      Future.delayed(Duration(microseconds: 300), () {
                    GetListCustomerBloc.of(context)
                        .add(InitGetListOrderEvent('', 1, ''));
                  }),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: List.generate(
                            state.listCustomer.length,
                            (index) => GestureDetector(
                                  onTap: () => AppNavigator.navigateDetailCustomer(
                                      state.listCustomer[index].id!,
                                      '${state.listCustomer[index].danh_xung ?? ''}' +
                                          ' ' +
                                          '${state.listCustomer[index].name ?? ''}'),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            state.listCustomer[index]
                                                        .is_company ==
                                                    true
                                                ? SvgPicture.asset(
                                                    "assets/icons/building.svg",
                                                    color: state
                                                                .listCustomer[
                                                                    index]
                                                                .tong_so_hop_dong! >
                                                            0
                                                        ? COLORS.ORANGE_IMAGE
                                                        : COLORS.GREY,
                                                  )
                                                : SvgPicture.asset(
                                                    "assets/icons/avatar_customer.svg",
                                                    color: state
                                                                .listCustomer[
                                                                    index]
                                                                .tong_so_hop_dong! >
                                                            0
                                                        ? COLORS.ORANGE_IMAGE
                                                        : COLORS.GREY,
                                                  ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: WidgetText(
                                                maxLine: 1,
                                                overflow: TextOverflow.ellipsis,
                                                title: '${state.listCustomer[index].danh_xung ?? ''}' +
                                                    ' ' +
                                                    '${state.listCustomer[index].name ?? ''}',
                                                style: AppStyle.DEFAULT_18
                                                    .copyWith(
                                                        color:
                                                            HexColor("#006CB1"),
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: state
                                                              .listCustomer[
                                                                  index]
                                                              .color ==
                                                          null
                                                      ? COLORS.PRIMARY_COLOR
                                                      : HexColor(state
                                                          .listCustomer[index]
                                                          .color!),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          99)),
                                              width: AppValue.widths * 0.1,
                                              height: AppValue.heights * 0.02,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                            height: AppValue.heights * 0.01),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/icons/location_customer.svg"),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: AppValue.widths * 0.03),
                                              child: SizedBox(
                                                  width: AppValue.widths * 0.5,
                                                  child: WidgetText(
                                                    title: (state
                                                                    .listCustomer[
                                                                        index]
                                                                    .address ==
                                                                null ||
                                                            state
                                                                    .listCustomer[
                                                                        index]
                                                                    .address ==
                                                                "")
                                                        ? 'Chưa có'
                                                        : state
                                                            .listCustomer[index]
                                                            .address,
                                                    style: AppStyle.DEFAULT_14
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: AppValue.heights * 0.01),
                                        (state.listCustomer[index].email!.val !=
                                                    null &&
                                                state.listCustomer[index].email!
                                                        .val !=
                                                    "")
                                            ? GestureDetector(
                                                onTap: () {
                                                  if ((state.listCustomer[index]
                                                                  .email!.val !=
                                                              null &&
                                                          state
                                                                  .listCustomer[
                                                                      index]
                                                                  .email!
                                                                  .val !=
                                                              "") &&
                                                      state.listCustomer[index]
                                                              .email!.action !=
                                                          null) {
                                                    launchUrl(Uri(
                                                        scheme: "mailto",
                                                        path:
                                                            "${state.listCustomer[index].email!.val!}"));
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/mail_customer.svg",
                                                      color: COLORS.GREY,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              AppValue.widths *
                                                                  0.03),
                                                      child: SizedBox(
                                                          width:
                                                              AppValue.widths *
                                                                  0.5,
                                                          child: WidgetText(
                                                            title: state
                                                                    .listCustomer[
                                                                        index]
                                                                    .email!
                                                                    .val ??
                                                                'Chưa có',
                                                            style: AppStyle
                                                                .DEFAULT_14
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                            height: AppValue.heights * 0.01),
                                        Row(
                                          children: [
                                            (state.listCustomer[index].phone!
                                                            .val !=
                                                        null &&
                                                    state.listCustomer[index]
                                                            .phone!.val !=
                                                        "")
                                                ? GestureDetector(
                                                    onTap: () {
                                                      if ((state
                                                                      .listCustomer[
                                                                          index]
                                                                      .phone!
                                                                      .val !=
                                                                  null &&
                                                              state
                                                                      .listCustomer[
                                                                          index]
                                                                      .phone!
                                                                      .val !=
                                                                  "") &&
                                                          state
                                                                  .listCustomer[
                                                                      index]
                                                                  .phone!
                                                                  .action !=
                                                              null) {
                                                        launchUrl(Uri(
                                                            scheme: "tel",
                                                            path:
                                                                "${state.listCustomer[index].phone!.val!}"));
                                                      }
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            "assets/icons/phone_customer.svg"),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: AppValue
                                                                      .widths *
                                                                  0.03),
                                                          child: SizedBox(
                                                              width: AppValue
                                                                      .widths *
                                                                  0.5,
                                                              child: Text(
                                                                  state
                                                                          .listCustomer[
                                                                              index]
                                                                          .phone!
                                                                          .val ??
                                                                      'Chưa có',
                                                                  style: AppStyle
                                                                      .DEFAULT_14
                                                                      .copyWith(
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              HexColor("#0052B4")))),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                            Spacer(),
                                            SvgPicture.asset(
                                                "assets/icons/question_answer.svg"),
                                            SizedBox(
                                              width: AppValue.widths * 0.01,
                                            ),
                                            Text(
                                              state.listCustomer[index]
                                                  .total_comment
                                                  .toString(),
                                              style: TextStyle(
                                                color: HexColor("#0052B4"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.only(
                                      left: AppValue.widths * 0.05,
                                      top: AppValue.heights * 0.01,
                                      right: AppValue.widths * 0.05,
                                    ),
                                    padding: EdgeInsets.only(
                                        left: AppValue.widths * 0.05,
                                        top: AppValue.heights * 0.02,
                                        right: AppValue.widths * 0.05,
                                        bottom: AppValue.widths * 0.05),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          offset: Offset(0,
                                              0), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                    ),
                  ),
                ),
              );
            } else
              return Expanded(
                  child: Center(
                child: WidgetText(
                  title: 'Không có dữ liệu',
                  style: AppStyle.DEFAULT_18_BOLD,
                ),
              ));
          }),
        ],
      ),
    );
  }

  handleOnPressItemMenu(value) async {
    switch (value['id']) {
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
        AppNavigator.navigateReport(money ?? "đ");
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

  showBotomSheet(List<FilterData> data) {
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
                                      GetListCustomerBloc.of(context).add(
                                          InitGetListOrderEvent(
                                              data[index].id.toString(),
                                              1,
                                              search));
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

  showBotomSheet2() {
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
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: WidgetText(
                          title: 'Chọn kiểu khách hàng',
                          textAlign: TextAlign.center,
                          style: AppStyle.DEFAULT_20_BOLD,
                        ),
                      ),
                      AppValue.vSpaceTiny,
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              AppNavigator.navigateAddCustomer();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              margin: EdgeInsets.only(bottom: 10),
                              child: WidgetText(
                                title: "Khách hàng cá nhân",
                                style: AppStyle.DEFAULT_18,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              AppNavigator.navigateFormAdd(
                                  "Thêm khách hàng tổ chức", 1);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: WidgetText(
                                title: "Khách hàng tổ chức",
                                style: AppStyle.DEFAULT_18,
                              ),
                            ),
                          )
                        ],
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
