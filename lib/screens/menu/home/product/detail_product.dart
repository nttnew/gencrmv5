import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/list_note.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../src/src_index.dart';
import '../../../../../widgets/line_horizontal_widget.dart';
import '../../../../bloc/detail_product/detail_product_bloc.dart';
import '../../../../src/app_const.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/widget_dialog.dart';
import '../../attachment/attachment.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({Key? key}) : super(key: key);

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  String id = Get.arguments[1];
  String title = Get.arguments[0];

  @override
  void initState() {
    super.initState();
    DetailProductBloc.of(context).add(InitGetDetailProductEvent(id));
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
            child: InkWell(
                onTap: () => AppNavigator.navigateBack(),
                child: Icon(Icons.arrow_back, color: Colors.black))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: BlocListener<DetailProductBloc, DetailProductState>(
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
                    Navigator.pushNamedAndRemoveUntil(
                        context, ROUTE_NAMES.PRODUCT, ModalRoute.withName('/'),
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
                    Navigator.pushReplacementNamed(
                        context, ROUTE_NAMES.DETAIL_PRODUCT,
                        arguments: [title, id]);
                  },
                );
              },
            );
          }
        },
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<DetailProductBloc, DetailProductState>(
                        builder: (context, state) {
                      if (state is UpdateGetDetailProductState)
                        return Container(
                          height: AppValue.heights * 0.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                (state.productInfo.data ?? []).length,
                                (index) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: AppValue.heights * 0.04,
                                        ),
                                        WidgetText(
                                          title: (state.productInfo.data ??
                                                      [])[index]
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
                                              (state.productInfo.data?[index]
                                                          .data ??
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
                                                                      .data?[
                                                                          index]
                                                                      .data?[
                                                                          index1]
                                                                      .labelField,
                                                                  style:
                                                                      LabelStyle(),
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
                                                                              .data?[index]
                                                                              .data?[index1]
                                                                              .labelField ==
                                                                          BASE_URL.KHACH_HANG) {
                                                                        AppNavigator.navigateDetailCustomer(
                                                                            state.productInfo.data?[index].data?[index1].id ??
                                                                                '',
                                                                            state.productInfo.data?[index].data?[index1].valueField ??
                                                                                '');
                                                                      }
                                                                    },
                                                                    child:
                                                                        WidgetText(
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
                                                                      style: ValueStyle()
                                                                          .copyWith(
                                                                        decoration: state.productInfo.data?[index].data?[index1].labelField ==
                                                                                BASE_URL.KHACH_HANG
                                                                            ? TextDecoration.underline
                                                                            : null,
                                                                        color: state.productInfo.data?[index].data?[index1].labelField ==
                                                                                BASE_URL.KHACH_HANG
                                                                            ? Colors.blue
                                                                            : null,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: AppValue
                                                                      .heights *
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
                        return Container();
                    }),
                    SizedBox(
                      height: 16,
                    ),
                    ListNote(type: 5, id: id.toString()),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showMore();
                  },
                  child: Container(
                    width: double.infinity,
                    height: AppValue.heights * 0.06,
                    margin: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: HexColor("#D0F1EB"),
                      borderRadius: BorderRadius.circular(17.06),
                    ),
                    child: Center(
                      child: Text("THAO TÁC",
                          style: TextStyle(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showMore() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              height: AppValue.heights * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: AppValue.heights * 0.03,
                  ),
                  itemIcon(
                    "Xem đính kèm",
                    ICONS.IC_ATTACK_SVG,
                    () async {
                      Get.back();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Attachment(
                                id: id,
                                typeModule: Module.PRODUCT,
                              )));
                    },
                  ),
                  itemIcon(
                    "Sửa",
                    ICONS.IC_EDIT_SVG,
                    () {
                      Get.back();
                      AppNavigator.navigateEditDataScreen(id, PRODUCT_TYPE);
                    },
                  ),
                  itemIcon(
                    "Xoá",
                    ICONS.IC_DELETE_SVG,
                    () {
                      ShowDialogCustom.showDialogTwoButton(
                          onTap2: () async {
                            DetailProductBloc.of(context)
                                .add(DeleteProductEvent(id));
                          },
                          content: "Bạn chắc chắn muốn xóa không ?");
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: AppValue.widths * 0.8,
                          height: AppValue.heights * 0.06,
                          decoration: BoxDecoration(
                            color: HexColor("#D0F1EB"),
                            borderRadius: BorderRadius.circular(17.06),
                          ),
                          child: Center(
                            child: Text("Đóng"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  TextStyle ValueStyle([String? color]) => TextStyle(
      fontFamily: "Quicksand",
      color: color == null ? HexColor("#263238") : HexColor(color),
      fontWeight: FontWeight.w700,
      fontSize: 14);

  TextStyle LabelStyle() => TextStyle(
      fontFamily: "Quicksand",
      color: COLORS.BLACK,
      fontWeight: FontWeight.w600,
      fontSize: 14);
}
