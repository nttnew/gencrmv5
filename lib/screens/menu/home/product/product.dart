import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/product_module/product_module_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/screens/menu/home/product/scanner_qrcode.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_search.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';
import 'item_product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late final TextEditingController _controllerText;
  late final ProductModuleBloc _bloc;
  late final ScrollController _scrollController;
  late final String title;

  @override
  void initState() {
    title = Get.arguments;
    _scrollController = ScrollController();
    _bloc = ProductModuleBloc.of(context);
    _controllerText = TextEditingController();
    getDataFirst();
    listenerLoadMore();
    super.initState();
  }

  listenerLoadMore() {
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          _bloc.isLength) {
        _bloc.page = _bloc.page + 1;
        _bloc.add(InitGetListProductModuleEvent(page: _bloc.page));
      } else {}
    });
  }

  getDataFirst() {
    _bloc.add(InitGetListProductModuleEvent());
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
        body: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                width: double.infinity,
                height: AppValue.heights * 0.06,
                decoration: BoxDecoration(
                  border: Border.all(color: HexColor("#DBDBDB")),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: WidgetSearch(
                  inputController: _controllerText,
                  hintTextStyle: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: HexColor("#707070")),
                  hint: "Nhập tên, barCode, qrCode",
                  leadIcon: SvgPicture.asset(ICONS.IC_SEARCH_SVG),
                  endIcon: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => ScannerQrcode()))
                          .then((value) {
                        if (value != '') {
                          _controllerText.text = value;
                        }
                      });
                    },
                    child: Icon(
                      Icons.qr_code_scanner,
                      size: 20,
                    ),
                  ),
                  onClickRight: () {},
                  onChanged: (text) {},
                  onEditingComplete: () {},
                ),
              ),
              Expanded(
                  child: BlocBuilder<ProductModuleBloc, ProductModuleState>(
                builder: (BuildContext context, state) {
                  if (state is SuccessGetListProductModuleState) {
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
                            itemBuilder: (context, i) => ItemProductModule(
                                  productModule: list[i],
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
}
