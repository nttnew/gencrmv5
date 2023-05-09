import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/support/detail_support_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/list_note.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../src/src_index.dart';
import '../../../../../widgets/line_horizontal_widget.dart';
import '../../../../bloc/support/support_bloc.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/widget_dialog.dart';
import '../../attachment/attachment.dart';

class DetailSupportScreen extends StatefulWidget {
  const DetailSupportScreen({Key? key}) : super(key: key);

  @override
  State<DetailSupportScreen> createState() => _DetailSupportScreenState();
}

class _DetailSupportScreenState extends State<DetailSupportScreen> {
  String id = Get.arguments[0];
  String title = Get.arguments[0];

  @override
  void initState() {
    DetailSupportBloc.of(context).add(InitGetDetailSupportEvent(id));
    super.initState();
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
            maxLine: 3,
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
        body: BlocBuilder<DetailSupportBloc, DetailSupportState>(
            builder: (context, state) {
          if (state is SuccessGetDetailSupportState)
            return BlocListener<DetailSupportBloc, DetailSupportState>(
              listener: (context, state) async {
                if (state is SuccessDeleteSupportState) {
                  LoadingApi().popLoading();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return WidgetDialog(
                        title: MESSAGES.NOTIFICATION,
                        content: "Thành công",
                        textButton1: MESSAGES.OKE,
                        backgroundButton1: COLORS.PRIMARY_COLOR,
                        onTap1: () {
                          Get.back();
                          Get.back();
                          Get.back();
                          Get.back();
                          SupportBloc.of(context)
                              .add(InitGetSupportEvent(1, '', ''));
                        },
                      );
                    },
                  );
                } else if (state is ErrorDeleteSupportState) {
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
                          Get.back();
                        },
                      );
                    },
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: List.generate(
                                  state.dataDetailSupport.length,
                                  (index) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: AppValue.heights * 0.04,
                                          ),
                                          WidgetText(
                                            title: state
                                                    .dataDetailSupport[index]
                                                    .group_name ??
                                                '',
                                            style: TextStyle(
                                                fontFamily: "Quicksand",
                                                color: HexColor("#263238"),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14),
                                          ),
                                          Column(
                                            children: List.generate(
                                                state.dataDetailSupport[index]
                                                    .data!.length,
                                                (index1) => state
                                                            .dataDetailSupport[
                                                                index]
                                                            .data![index1]
                                                            .value_field !=
                                                        ''
                                                    ? Column(
                                                        children: [
                                                          SizedBox(
                                                            height: AppValue
                                                                    .heights *
                                                                0.02,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              WidgetText(
                                                                title: state
                                                                        .dataDetailSupport[
                                                                            index]
                                                                        .data![
                                                                            index1]
                                                                        .label_field ??
                                                                    '',
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
                                                                            .dataDetailSupport[
                                                                                index]
                                                                            .data![
                                                                                index1]
                                                                            .label_field ==
                                                                        BASE_URL
                                                                            .KHACH_HANG) {
                                                                      AppNavigator.navigateDetailCustomer(
                                                                          state
                                                                              .dataDetailSupport[index]
                                                                              .data![index1]
                                                                              .id!,
                                                                          state.dataDetailSupport[index].data![index1].value_field ?? '');
                                                                    }
                                                                  },
                                                                  child:
                                                                      WidgetText(
                                                                    title: state
                                                                            .dataDetailSupport[index]
                                                                            .data![index1]
                                                                            .value_field ??
                                                                        '',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style: ValueStyle()
                                                                        .copyWith(
                                                                      decoration: state.dataDetailSupport[index].data![index1].label_field ==
                                                                              BASE_URL.KHACH_HANG
                                                                          ? TextDecoration.underline
                                                                          : null,
                                                                      color: state.dataDetailSupport[index].data![index1].label_field ==
                                                                              BASE_URL.KHACH_HANG
                                                                          ? Colors.blue
                                                                          : null,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    : SizedBox()),
                                          ),
                                          SizedBox(
                                            height: AppValue.heights * 0.02,
                                          ),
                                          LineHorizontal(),
                                        ],
                                      )),
                            ),
                            SizedBox(
                              height: AppValue.heights * 0.02,
                            ),
                            ListNote(type: 6, id: id)
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30)),
                            ),
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                child: Container(
                                  height: AppValue.heights * 0.3,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                        height: AppValue.heights * 0.03,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                          AppNavigator.navigateAddNoteScreen(
                                              6, id);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: AppValue.widths * 0.2,
                                            ),
                                            SvgPicture.asset(
                                                ICONS.IC_ADD_DISCUSS_SVG),
                                            SizedBox(
                                              width: AppValue.widths * 0.1,
                                            ),
                                            Text("Thêm thảo luận",
                                                style: styleTitleBottomSheet())
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      Attachment(
                                                        id: id,
                                                        typeModule:
                                                            Module.HO_TRO,
                                                      )));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: AppValue.widths * 0.2,
                                            ),
                                            SvgPicture.asset(
                                                ICONS.IC_ATTACK_SVG),
                                            SizedBox(
                                              width: AppValue.widths * 0.1,
                                            ),
                                            Text("Xem đính kèm",
                                                style: styleTitleBottomSheet())
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                          AppNavigator.navigateEditDataScreen(
                                              id, 6);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: AppValue.widths * 0.2,
                                            ),
                                            SvgPicture.asset(
                                                ICONS.IC_EDIT_SVG),
                                            SizedBox(
                                              width: AppValue.widths * 0.1,
                                            ),
                                            Text("Sửa",
                                                style: styleTitleBottomSheet())
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          ShowDialogCustom.showDialogTwoButton(
                                              onTap2: () => DetailSupportBloc
                                                      .of(context)
                                                  .add(DeleteSupportEvent(id)),
                                              content:
                                                  "Bạn chắc chắn muốn xóa không ?");
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: AppValue.widths * 0.2,
                                            ),
                                            SvgPicture.asset(
                                                ICONS.IC_DELETE_SVG),
                                            SizedBox(
                                              width: AppValue.widths * 0.1,
                                            ),
                                            Text("Xoá",
                                                style: styleTitleBottomSheet())
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () =>
                                                Navigator.of(context).pop(),
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              width: AppValue.widths * 0.8,
                                              height: AppValue.heights * 0.06,
                                              decoration: BoxDecoration(
                                                color: HexColor("#D0F1EB"),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        17.06),
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
                      },
                      child: Container(
                        width: double.infinity,
                        height: AppValue.heights * 0.06,
                        margin: EdgeInsets.symmetric(vertical: 20),
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
            );
          else
            return Container();
        }));
  }

  TextStyle styleTitleBottomSheet() => TextStyle(
      color: HexColor("#0069CD"),
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w700,
      fontSize: 20);

  TextStyle ValueStyle([String? color]) => TextStyle(
      fontFamily: "Quicksand",
      color: color == null ? HexColor("#263238") : HexColor(color),
      fontWeight: FontWeight.w700,
      fontSize: 12);

  TextStyle LabelStyle() => TextStyle(
      fontFamily: "Quicksand",
      color: HexColor("#697077"),
      fontWeight: FontWeight.w600,
      fontSize: 12);
}
