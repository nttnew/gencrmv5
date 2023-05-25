import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gen_crm/bloc/work/detail_work_bloc.dart';
import 'package:gen_crm/bloc/work/work_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/list_note.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/line_horizontal_widget.dart';
import '../../../../widgets/btn_thao_tac.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../attachment/attachment.dart';

class DetailWorkScreen extends StatefulWidget {
  const DetailWorkScreen({Key? key}) : super(key: key);

  @override
  State<DetailWorkScreen> createState() => _DetailWorkScreenState();
}

class _DetailWorkScreenState extends State<DetailWorkScreen> {
  int id = Get.arguments[0];
  String title = Get.arguments[1];
  int? location;
  List<ModuleThaoTac> list = [];

  @override
  void initState() {
    DetailWorkBloc.of(context).add(InitGetDetailWorkEvent(id));
    super.initState();
  }

  getThaoTac() {
    list = [];
    list.add(ModuleThaoTac(
      title: "Thêm thảo luận",
      icon: ICONS.IC_ADD_DISCUSS_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddNoteScreen(5, id.toString());
      },
    ));

    if (location != 1) //1 là có rồi
      list.add(ModuleThaoTac(
        title: "Thêm check in",
        icon: ICONS.IC_LOCATION_SVG,
        onThaoTac: () {
          Get.back();
          AppNavigator.navigateCheckIn(id.toString(), ModuleMy.CONG_VIEC);
        },
      ));

    list.add(ModuleThaoTac(
      title: "Xem đính kèm",
      icon: ICONS.IC_ATTACK_SVG,
      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: id.toString(),
                  typeModule: Module.CONG_VIEC,
                )));
      },
    ));

    list.add(ModuleThaoTac(
      title: "Sửa",
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id.toString(), 5);
      },
    ));

    list.add(ModuleThaoTac(
      title: "Xoá",
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
            onTap2: () =>
                DetailWorkBloc.of(context).add(InitDeleteWorkEvent(id)),
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
        listener: (context, state) {
          if (state is SuccessDeleteWorkState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
              title: MESSAGES.NOTIFICATION,
              content: "Thành công",
              onTap1: () {
                Get.back();
                Get.back();
                Get.back();
                Get.back();
                WorkBloc.of(context).add(InitGetListWorkEvent("1", "", ""));
              },
            );
          } else if (state is ErrorDeleteWorkState) {
            LoadingApi().popLoading();
            ShowDialogCustom.showDialogBase(
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
                        if (state is SuccessDetailWorkState) {
                          location = state.location;
                          getThaoTac();
                          return Container(
                            child: Column(
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
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: AppValue.heights * 0.02,
                                          ),
                                          Column(
                                            children: List.generate(
                                                state.data_list[index].data!
                                                    .length,
                                                (index1) =>
                                                    state
                                                                .data_list[
                                                                    index]
                                                                .data![index1]
                                                                .value_field !=
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
                                                                        .data_list[
                                                                            index]
                                                                        .data![
                                                                            index1]
                                                                        .label_field,
                                                                    style:
                                                                        LabelStyle(),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        if (state.data_list[index].data![index1].label_field ==
                                                                            BASE_URL.KHACH_HANG) {
                                                                          AppNavigator.navigateDetailCustomer(
                                                                              state.data_list[index].data![index1].id!,
                                                                              state.data_list[index].data![index1].value_field ?? '');
                                                                        }
                                                                      },
                                                                      child:
                                                                          SizedBox(
                                                                        child: state.data_list[index].data![index1].type !=
                                                                                'text_area'
                                                                            ? WidgetText(
                                                                                title: state.data_list[index].data![index1].value_field,
                                                                                textAlign: TextAlign.right,
                                                                                style: ValueStyle().copyWith(
                                                                                  decoration: state.data_list[index].data![index1].label_field == BASE_URL.KHACH_HANG ? TextDecoration.underline : null,
                                                                                  color: state.data_list[index].data![index1].label_field == BASE_URL.KHACH_HANG ? Colors.blue : null,
                                                                                ),
                                                                              )
                                                                            : Html(
                                                                                data: state.data_list[index].data![index1].value_field,
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
                        } else
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
              ButtonThaoTac(
                onTap: () {
                  showThaoTac(context, list);
                },
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
      fontSize: 14);

  TextStyle LabelStyle() => TextStyle(
      fontFamily: "Quicksand",
      color: COLORS.GREY,
      fontWeight: FontWeight.w600,
      fontSize: 14);
}
