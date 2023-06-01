import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/customer.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_search.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import 'item_list_customer.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  int page = 1;
  int total = 0;
  int length = 0;
  List<CustomerData> listCustomer = [];
  String idFilter = '';
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final _key = GlobalKey<ExpandableFabState>();
  String search = '';
  String title = Get.arguments;
  ScrollController _scrollController = ScrollController();
  List<String> listAdd = [
    'Khách hàng tổ chức',
    'Khách hàng cá nhân',
  ];

  @override
  void initState() {
    GetListUnReadNotifiBloc.of(context).add(CheckNotification());
    GetListCustomerBloc.of(context).add(InitGetListOrderEvent('', 1, ''));
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          length < total) {
        GetListCustomerBloc.of(context).add(InitGetListOrderEvent(
            idFilter, page + 1, search,
            isLoadMore: true));
        page = page + 1;
      } else {}
    });
    super.initState();
  }

  _handleRouter(String value) {
    if (listAdd.last == value) {
      AppNavigator.navigateAddCustomer();
    } else {
      AppNavigator.navigateFormAdd("Thêm ${value.toLowerCase()}", 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      resizeToAvoidBottomInset: false,
      drawer: MainDrawer(onPress: (v) => handleOnPressItemMenu(_drawerKey, v)),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        childrenOffset: Offset(0, 0),
        key: _key,
        distance: 65,
        type: ExpandableFabType.up,
        child: Icon(Icons.add, size: 40),
        closeButtonStyle: const ExpandableFabCloseButtonStyle(
          child: Icon(Icons.close),
          foregroundColor: Colors.white,
          backgroundColor: Color(0xff1AA928),
        ),
        backgroundColor: Color(0xff1AA928),
        overlayStyle: ExpandableFabOverlayStyle(
          blur: 5,
        ),
        children: listAdd
            .map(
              (e) => InkWell(
                onTap: () async {
                  final state = _key.currentState;
                  if (state != null) {
                    if (state.isOpen) {
                      await _handleRouter(e);
                      state.toggle();
                    }
                  }
                },
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                        title: e,
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
                        boxShadow: [
                          BoxShadow(
                            color: COLORS.BLACK.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          )
                        ],
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          ICONS.IC_CUSTOMER_3X_PNG,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
            .toList(),
      ),
      appBar: AppbarBase(_drawerKey, title),
      body: BlocBuilder<GetListCustomerBloc, CustomerState>(
          builder: (context, state) {
        if (state is UpdateGetListCustomerState) {
          total = state.total;
          length = state.listCustomer.length;
          listCustomer = state.listCustomer;
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                  left: 25,
                  right: 25,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: HexColor("#DBDBDB")),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: WidgetSearch(
                  hintTextStyle: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: HexColor("#707070")),
                  hint: "Tìm khách hàng",
                  leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                  endIcon: SvgPicture.asset(ICONS.IC_FILL_SVG),
                  onClickRight: () {
                    _showBottomSheet(state.listFilter);
                  },
                  onSubmit: (v) {
                    search = v;
                    GetListCustomerBloc.of(context)
                        .add(InitGetListOrderEvent(idFilter, 1, v));
                  },
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      Future.delayed(Duration(microseconds: 300), () {
                    GetListCustomerBloc.of(context)
                        .add(InitGetListOrderEvent('', 1, ''));
                  }),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: List.generate(
                            state.listCustomer.length,
                            (index) => ItemCustomer(
                                  data: state.listCustomer[index],
                                  onTap: () => AppNavigator.navigateDetailCustomer(
                                      state.listCustomer[index].id??'',
                                      '${state.listCustomer[index].danh_xung ?? ''}' +
                                          ' ' +
                                          '${state.listCustomer[index].name ?? ''}'),
                                )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else
          return noData();
      }),
    );
  }

  _showBottomSheet(List<FilterData> data) {
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
