import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/screens/menu/home/product/scanner_qrcode.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_search.dart';
import '../../menu_left/menu_drawer/main_drawer.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
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
          title: Text("Sản phẩm",
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
        body: Padding(
          padding: EdgeInsets.only(
              left: 15, right: 15, top: AppValue.heights * 0.02),
          child: Container(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: AppValue.heights * 0.06,
                  decoration: BoxDecoration(
                    border: Border.all(color: HexColor("#DBDBDB")),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: WidgetSearch(
                    inputController: _controller,
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
                            _controller.text = value;
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
                )
              ],
            ),
          ),
        ));
  }
}
