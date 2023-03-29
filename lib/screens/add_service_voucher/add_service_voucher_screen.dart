import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/screens/menu/home/contract/widget_total_sum.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../bloc/add_service_voucher/add_service_bloc.dart';
import '../../src/models/model_generator/post_info_car_response.dart';

class AddServiceVoucherScreen extends StatefulWidget {
  @override
  State<AddServiceVoucherScreen> createState() =>
      _AddServiceVoucherScreenState();
}

class _AddServiceVoucherScreenState extends State<AddServiceVoucherScreen> {
  // late final ServiceVoucherBloc _bloc;
  String sdt = '';
  String bienSo = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buildBack() {
    return IconButton(
      onPressed: () {
        AppNavigator.navigateBack();
      },
      icon: Image.asset(
        ICONS.ICON_BACK,
        height: 28,
        width: 28,
        color: COLORS.BLACK,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: AppValue.heights * 0.1,
          backgroundColor: HexColor("#D0F1EB"),
          title: WidgetText(
              title: "Thêm phiếu dịch vụ",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          leading: _buildBack(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
        body: BlocListener<ServiceVoucherBloc, ServiceVoucherState>(
          // bloc: _bloc,
          listener: (context, state) {
            if (state is GetServiceVoucherState) {
              LoadingApi().popLoading();
              AppNavigator.navigateAddServiceVoucherStepTwo();
            }
          },
          child: Container(
            padding: EdgeInsets.only(
                left: AppValue.widths * 0.05,
                right: AppValue.widths * 0.05,
                top: AppValue.heights * 0.02),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppValue.vSpaceSmall,
                  WidgetText(
                      title: "Nhập số điện thoại hoặc biển số",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                  AppValue.vSpaceSmall,
                  _fieldInputCustomer(
                      "Điện thoại", TextInputType.number, "Nhập điện thoại",
                      (v) {
                    sdt = v;
                  }),
                  _fieldInputCustomer(
                      "Biển số", TextInputType.text, "Nhập biển số", (v) {
                    bienSo = v;
                  }),
                  AppValue.vSpaceTiny,
                  WidgetButton(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (sdt.trim() == '' && bienSo.trim() == '') {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return WidgetDialog(
                                title: MESSAGES.NOTIFICATION,
                                content:
                                    "Bạn phải nhập số điện thoại hoặc biển số",
                              );
                            },
                          );
                        } else {
                          ServiceVoucherBloc.of(context).add(PostServiceVoucherEvent(
                              sdt.trim(), bienSo.trim()));
                        }
                      },
                      boxDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: HexColor("#A6C1BC"),
                      ),
                      textStyle: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      text: "KIỂM TRA"),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _fieldInputCustomer(String label, TextInputType textInputType,
      String prefixText, Function(String v) onChange) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: titlestyle(),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: HexColor("#BEB4B4"))),
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: Container(
                child: TextField(
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  keyboardType: textInputType,
                  onChanged: (v) => onChange(v),
                  decoration: InputDecoration(
                      hintText: prefixText,
                      hintStyle: hintTextStyle(),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
