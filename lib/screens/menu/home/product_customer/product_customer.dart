import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/product_customer_module/product_customer_module_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/screens/menu/home/product_customer/item_product_customer.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/list_product_customer_response.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_search.dart';
import '../../../../widgets/widget_text.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';

class ProductCustomerScreen extends StatefulWidget {
  const ProductCustomerScreen({Key? key}) : super(key: key);

  @override
  State<ProductCustomerScreen> createState() => _ProductCustomerScreenState();
}

class _ProductCustomerScreenState extends State<ProductCustomerScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late final TextEditingController _controllerText;
  late final ProductCustomerModuleBloc _bloc;
  late final ScrollController _scrollController;
  late final String title;

  @override
  void initState() {
    title = Get.arguments ?? '';
    _scrollController = ScrollController();
    _bloc = ProductCustomerModuleBloc.of(context);
    _controllerText = TextEditingController();
    getDataFirst();
    listenerLoadMore();
    _bloc.getFilter();
    super.initState();
  }

  listenerLoadMore() {
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          _bloc.isLength) {
        _bloc.page = _bloc.page + 1;
        _bloc.add(GetProductCustomerModuleEvent(
            page: _bloc.page,
            filter: _bloc.filter,
            querySearch: _bloc.querySearch));
      } else {}
    });
  }

  search() {
    _bloc.add(GetProductCustomerModuleEvent(
        page: BASE_URL.PAGE_DEFAULT,
        filter: _bloc.filter,
        querySearch: _bloc.querySearch));
  }

  getDataFirst() {
    _bloc.add(GetProductCustomerModuleEvent());
  }

  @override
  void deactivate() {
    _bloc.dispose();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _drawerKey,
        drawer:
            MainDrawer(onPress: (v) => handleOnPressItemMenu(_drawerKey, v)),
        appBar: AppBar(
          centerTitle: false,
          toolbarHeight: AppValue.heights * 0.1,
          backgroundColor: HexColor("#D0F1EB"),
          title: Text(title,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          leading: Padding(
              padding: EdgeInsets.only(left: 40),
              child: GestureDetector(
                  onTap: () {
                    if (_drawerKey.currentContext != null &&
                        !_drawerKey.currentState!.isDrawerOpen) {
                      _drawerKey.currentState!.openDrawer();
                    }
                  },
                  child: SvgPicture.asset(ICONS.IC_MENU_SVG))),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 30),
                child: GestureDetector(
                  onTap: () => AppNavigator.navigateNotification(),
                  child: BlocBuilder<GetListUnReadNotifiBloc,
                      UnReadListNotifiState>(builder: (context, state) {
                    if (state is NotificationNeedRead) {
                      return SvgPicture.asset(ICONS.IC_NOTIFICATION_SVG);
                    } else {
                      return SvgPicture.asset(ICONS.IC_NOTIFICATION2_SVG);
                    }
                  }),
                ))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff1AA928),
          onPressed: () => AppNavigator.navigateFormAdd(
              'Thêm $title', PRODUCT_CUSTOMER_TYPE),
          child: Icon(Icons.add, size: 40),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: HexColor("#DBDBDB")),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: WidgetSearch(
                  inputController: _controllerText,
                  hintTextStyle: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: HexColor("#707070")),
                  hint: "Tìm ${title.toLowerCase()}",
                  leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                  endIcon: GestureDetector(
                      onTap: () {
                        showBotomSheet(_bloc.dataFilter ?? []);
                      },
                      child: SvgPicture.asset(ICONS.IC_FILTER_SVG)),
                  onClickRight: () {},
                  onSubmit: (v) {
                    _bloc.querySearch = v;
                    search();
                  },
                ),
              ),
              Expanded(child: BlocBuilder<ProductCustomerModuleBloc,
                  ProductCustomerModuleState>(
                builder: (BuildContext context, state) {
                  if (state is SuccessGetListProductCustomerModuleState) {
                    _bloc.dataList = state.list;
                    final list = state.list;
                    if (list.length < BASE_URL.SIZE_DEFAULT) {
                      _bloc.isLength = false;
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await getDataFirst();
                        },
                        child: ListView.builder(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            controller: _scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, i) => ItemProductCustomer(
                                  productModule: list[i],
                                  onTap: () {
                                    AppNavigator.navigateDetailProductCustomer(
                                        list[i].name ?? '', list[i].id ?? '');
                                  },
                                )),
                      ),
                    );
                  }
                  return Container();
                },
              ))
            ],
          ),
        ));
  }

  showBotomSheet(List<DataFilter> dataFilter) {
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
                          title: 'Chọn lọc',
                          textAlign: TextAlign.center,
                          style: AppStyle.DEFAULT_16_BOLD,
                        ),
                      ),
                      Column(
                        children: List.generate(
                            dataFilter.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    _bloc.filter =
                                        dataFilter[index].id.toString();
                                    Get.back();
                                    search();
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
