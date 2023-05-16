import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/detail_product_customer/detail_product_customer_bloc.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/line_horizontal_widget.dart';
import '../../../../src/app_const.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../../../widgets/widget_dialog.dart';
import '../../attachment/attachment.dart';

class DetailProductCustomerScreen extends StatefulWidget {
  const DetailProductCustomerScreen({Key? key}) : super(key: key);

  @override
  State<DetailProductCustomerScreen> createState() =>
      _DetailProductCustomerScreenState();
}

class _DetailProductCustomerScreenState
    extends State<DetailProductCustomerScreen> {
  String title = Get.arguments[0];
  String id = Get.arguments[1];

  List<ModuleThaoTac> list = [];

  @override
  void initState() {
    getThaoTac();
    DetailProductCustomerBloc.of(context)
        .add(InitGetDetailProductCustomerEvent(id));
    super.initState();
  }

  getThaoTac() {
    list.add(ModuleThaoTac(
      title: "Xem đính kèm",
      icon: ICONS.IC_ATTACK_SVG,
      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: id,
                  typeModule: Module.SAN_PHAM_KH,
                )));
      },
    ));

    list.add(ModuleThaoTac(
      title: "Sửa",
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id, PRODUCT_CUSTOMER_TYPE);
      },
    ));

    list.add(ModuleThaoTac(
      title: "Xoá",
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogTwoButton(
            onTap2: () async {
              DetailProductCustomerBloc.of(context).add(DeleteProductEvent(id));
            },
            content: "Bạn chắc chắn muốn xóa không ?");
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: AppValue.heights * 0.1,
        backgroundColor: HexColor("#D0F1EB"),
        title: WidgetText(
          title: title,
          style: AppStyle.DEFAULT_18_BOLD,
        ),
        leading: Padding(
            padding: EdgeInsets.only(left: 30),
            child: GestureDetector(
                onTap: () => AppNavigator.navigateBack(),
                child: Icon(Icons.arrow_back, color: Colors.black))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: BlocListener<DetailProductCustomerBloc, DetailProductCustomerState>(
        listener: (context, state) async {
          if (state is SuccessDeleteProductState) {
            LoadingApi().popLoading();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WidgetDialog(
                  title: MESSAGES.NOTIFICATION,
                  content: "Xoá thành công",
                  textButton1: MESSAGES.OKE,
                  backgroundButton1: COLORS.PRIMARY_COLOR,
                  onTap1: () {
                    Navigator.pushNamedAndRemoveUntil(context,
                        ROUTE_NAMES.PRODUCT_CUSTOMER, ModalRoute.withName('/'),
                        arguments: title);
                  },
                );
              },
            );
          } else if (state is ErrorDeleteProductState) {
            LoadingApi().popLoading();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WidgetDialog(
                  title: MESSAGES.NOTIFICATION,
                  content: state.msg,
                  textButton1: "Quay lại",
                  onTap1: () {
                    Get.back();
                    Get.back();
                    Get.back();
                    DetailProductCustomerBloc.of(context)
                        .add(InitGetDetailProductCustomerEvent(id));
                  },
                );
              },
            );
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: ButtonThaoTac(onTap: () {
                  showThaoTac(context, list);
                }),
              ),
              BlocBuilder<DetailProductCustomerBloc,
                  DetailProductCustomerState>(builder: (context, state) {
                if (state is UpdateGetDetailProductCustomerState)
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          (state.productInfo.data ?? []).length,
                          (index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: AppValue.heights * 0.04,
                                  ),
                                  WidgetText(
                                    title: (state.productInfo.data ?? [])[index]
                                            .groupName ??
                                        '',
                                    style: TextStyle(
                                        fontFamily: "Quicksand",
                                        color: HexColor("#263238"),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: AppValue.heights * 0.02,
                                  ),
                                  Column(
                                    children: List.generate(
                                        (state.productInfo.data?[index].data ??
                                                [])
                                            .length,
                                        (index1) =>
                                            state
                                                            .productInfo
                                                            .data?[index]
                                                            .data?[index1]
                                                            .valueField !=
                                                        null &&
                                                    state
                                                            .productInfo
                                                            .data?[index]
                                                            .data?[index1]
                                                            .valueField !=
                                                        ''
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          WidgetText(
                                                            title: state
                                                                .productInfo
                                                                .data?[index]
                                                                .data?[index1]
                                                                .labelField,
                                                            style: LabelStyle(),
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                if (state
                                                                        .productInfo
                                                                        .data?[
                                                                            index]
                                                                        .data?[
                                                                            index1]
                                                                        .labelField ==
                                                                    BASE_URL
                                                                        .KHACH_HANG) {
                                                                  AppNavigator.navigateDetailCustomer(
                                                                      state.productInfo.data?[index].data?[index1].link ??
                                                                          '',
                                                                      state
                                                                              .productInfo
                                                                              .data?[index]
                                                                              .data?[index1]
                                                                              .valueField ??
                                                                          '');
                                                                }
                                                              },
                                                              child: WidgetText(
                                                                title: state
                                                                    .productInfo
                                                                    .data?[
                                                                        index]
                                                                    .data?[
                                                                        index1]
                                                                    .valueField,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style:
                                                                    ValueStyle()
                                                                        .copyWith(
                                                                  decoration: state
                                                                              .productInfo
                                                                              .data?[
                                                                                  index]
                                                                              .data?[
                                                                                  index1]
                                                                              .labelField ==
                                                                          BASE_URL
                                                                              .KHACH_HANG
                                                                      ? TextDecoration
                                                                          .underline
                                                                      : null,
                                                                  color: state
                                                                              .productInfo
                                                                              .data?[
                                                                                  index]
                                                                              .data?[
                                                                                  index1]
                                                                              .labelField ==
                                                                          BASE_URL
                                                                              .KHACH_HANG
                                                                      ? Colors
                                                                          .blue
                                                                      : null,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            AppValue.heights *
                                                                0.02,
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox()),
                                  ),
                                  LineHorizontal(),
                                ],
                              )),
                    ),
                  );
                else
                  return SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle ValueStyle([String? color]) => TextStyle(
      fontFamily: "Quicksand",
      color: color == null ? HexColor("#263238") : HexColor(color),
      fontWeight: FontWeight.w700,
      fontSize: 14);

  TextStyle LabelStyle() => TextStyle(
      fontFamily: "Quicksand",
      color: COLORS.GREY,
      fontWeight: FontWeight.w600,
      fontSize: 14);
}
