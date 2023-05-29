import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/bloc/work/detail_work_bloc.dart';
import 'package:gen_crm/bloc/work/work_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/index.dart';
import 'package:gen_crm/screens/menu/home/customer/list_note.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../src/src_index.dart';
import '../../../../../widgets/line_horizontal_widget.dart';
import '../../../../widgets/widget_dialog.dart';

class DetailWorkScreen extends StatefulWidget {
  const DetailWorkScreen({Key? key}) : super(key: key);

  @override
  State<DetailWorkScreen> createState() => _DetailWorkScreenState();
}

class _DetailWorkScreenState extends State<DetailWorkScreen> {
  int id = Get.arguments[0];
  String title = Get.arguments[1];

  @override
  void initState() {
    super.initState();
    DetailWorkBloc.of(context).add(InitGetDetailWorkEvent(id));
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
      body: BlocListener<DetailWorkBloc, DetailWorkState>(
        listener: (context, state) async {
          if (state is SuccessDeleteWorkState) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WidgetDialog(
                  title: MESSAGES.NOTIFICATION,
                  content: "Thành công",
                  textButton1: "OK",
                  backgroundButton1: COLORS.PRIMARY_COLOR,
                  onTap1: () {
                    Get.back();
                    Get.back();
                    Get.back();
                    Get.back();
                    WorkBloc.of(context).add(InitGetListWorkEvent("1", "", ""));
                  },
                );
              },
            );
          } else if (state is ErrorDeleteWorkState) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<DetailWorkBloc, DetailWorkState>(
                          builder: (context, state) {
                        if (state is SuccessDetailWorkState)
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                state.data_list.length,
                                (index) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: AppValue.heights * 0.04,
                                        ),
                                        WidgetText(
                                          title: state.data_list[index]
                                                  .group_name ??
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
                                              state.data_list[index].data!
                                                  .length,
                                              (index1) => Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          WidgetText(
                                                            title: state
                                                                .data_list[
                                                                    index]
                                                                .data![index1]
                                                                .label_field,
                                                            style: LabelStyle(),
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child: state
                                                                        .data_list[
                                                                            index]
                                                                        .data![
                                                                            index1]
                                                                        .type !=
                                                                    'text_area'
                                                                ? WidgetText(
                                                                    title: state
                                                                        .data_list[
                                                                            index]
                                                                        .data![
                                                                            index1]
                                                                        .value_field,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style:
                                                                        ValueStyle(),
                                                                  )
                                                                : Html(
                                                                    data: state
                                                                        .data_list[
                                                                            index]
                                                                        .data![
                                                                            index1]
                                                                        .value_field,
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
                                                  )),
                                        ),
                                        LineHorizontal(),
                                      ],
                                    )),
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
                ),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      context: context,
                      builder: (context) {
                        return SafeArea(
                          child: Container(
                            height: AppValue.heights * 0.3,
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: AppValue.heights * 0.03,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                    AppNavigator.navigateAddNoteScreen(
                                        5, id.toString());
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: AppValue.widths * 0.2,
                                      ),
                                      SvgPicture.asset(
                                          "assets/icons/adddiscuss.svg"),
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
                                    AppNavigator.navigateEditDataScreen(
                                        id.toString(), 5);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: AppValue.widths * 0.2,
                                      ),
                                      SvgPicture.asset(
                                          "assets/icons/edit.svg"),
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
                                        onTap2: () =>
                                            DetailWorkBloc.of(context)
                                                .add(InitDeleteWorkEvent(id)),
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
                                          "assets/icons/delete.svg"),
                                      SizedBox(
                                        width: AppValue.widths * 0.1,
                                      ),
                                      Text("Xoá",
                                          style: styleTitleBottomSheet())
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          Navigator.of(context).pop(),
                                      child: Container(
                                        width: AppValue.widths * 0.8,
                                        height: AppValue.heights * 0.06,
                                        decoration: BoxDecoration(
                                          color: HexColor("#D0F1EB"),
                                          borderRadius:
                                              BorderRadius.circular(17.06),
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
    );
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
