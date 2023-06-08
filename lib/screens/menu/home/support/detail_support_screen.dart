import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/support/detail_support_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/list_note.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/line_horizontal_widget.dart';
import '../../../../bloc/checkin_bloc/checkin_bloc.dart';
import '../../../../bloc/support/support_bloc.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../attachment/attachment.dart';

class DetailSupportScreen extends StatefulWidget {
  const DetailSupportScreen({Key? key}) : super(key: key);

  @override
  State<DetailSupportScreen> createState() => _DetailSupportScreenState();
}

class _DetailSupportScreenState extends State<DetailSupportScreen> {
  String id = Get.arguments[0];
  String title = Get.arguments[1];
  List<ModuleThaoTac> list = [];
  int? location;
  bool isCheckDone = false;

  @override
  void initState() {
    DetailSupportBloc.of(context).add(InitGetDetailSupportEvent(id));
    super.initState();
  }

  checkLocation(state) {
    location = state.location;
    if (state.dataDetailSupport.isNotEmpty) {
      final listLocation = state.dataDetailSupport.first.data
          ?.where((element) => element.id == 'checkout')
          .toList();
      if (listLocation?.isNotEmpty ?? false) {
        isCheckDone = listLocation?.first.value_field != '' &&
            listLocation?.first.value_field != null;
      }
    }
  }

  getThaoTac() {
    list = [];
    if (!isCheckDone) {
      if (location != 1) {
        //1 là có rồi
        list.add(ModuleThaoTac(
          title: "Check in",
          icon: ICONS.IC_LOCATION_SVG,
          onThaoTac: () {
            Get.back();
            AppNavigator.navigateCheckIn(
                id.toString(), ModuleMy.CSKH, TypeCheckIn.CHECK_IN);
          },
        ));
      } else {
        list.add(ModuleThaoTac(
          title: "Check out",
          icon: ICONS.IC_LOCATION_SVG,
          onThaoTac: () {
            Get.back();
            CheckInBloc.of(context).add(
              SaveCheckIn(
                '',
                '',
                '',
                id,
                ModuleMy.CSKH,
                TypeCheckIn.CHECK_OUT,
              ),
            );
          },
        ));
      }
    }

    list.add(ModuleThaoTac(
      title: "Thêm thảo luận",
      icon: ICONS.IC_ADD_DISCUSS_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddNoteScreen(Module.HO_TRO, id);
      },
    ));

    list.add(ModuleThaoTac(
      title: "Xem đính kèm",
      icon: ICONS.IC_ATTACK_SVG,
      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: id,
                  typeModule: Module.HO_TRO,
                )));
      },
    ));

    list.add(ModuleThaoTac(
      title: "Sửa",
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id, EDIT_SUPPORT);
      },
    ));

    list.add(ModuleThaoTac(
      title: "Xoá",
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
            onTap2: () =>
                DetailSupportBloc.of(context).add(DeleteSupportEvent(id)),
            content: "Bạn chắc chắn muốn xóa không ?");
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarBaseNormal(title),
        body: BlocListener<CheckInBloc, CheckInState>(
          listener: (context, state) {
            if (state is SuccessCheckInState) {
              DetailSupportBloc.of(context).add(InitGetDetailSupportEvent(id));
            } else if (state is ErrorCheckInState) {
              ShowDialogCustom.showDialogBase(
                title: MESSAGES.NOTIFICATION,
                content: state.msg,
              );
            }
          },
          child: BlocBuilder<DetailSupportBloc, DetailSupportState>(
              builder: (context, state) {
            if (state is SuccessGetDetailSupportState) {
              checkLocation(state);
              getThaoTac();
              return BlocListener<DetailSupportBloc, DetailSupportState>(
                listener: (context, state) async {
                  if (state is SuccessDeleteSupportState) {
                    LoadingApi().popLoading();
                    ShowDialogCustom.showDialogBase(
                      title: MESSAGES.NOTIFICATION,
                      content: "Thành công",
                      onTap1: () {
                        Get.back();
                        Get.back();
                        Get.back();
                        Get.back();
                        SupportBloc.of(context)
                            .add(InitGetSupportEvent());
                      },
                    );
                  } else if (state is ErrorDeleteSupportState) {
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
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
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
                                                                      if (state.dataDetailSupport[index].data?[index1].label_field ==
                                                                              BASE_URL
                                                                                  .KHACH_HANG &&
                                                                          (state.dataDetailSupport[index].data?[index1].is_link ??
                                                                              false)) {
                                                                        AppNavigator.navigateDetailCustomer(
                                                                            state.dataDetailSupport[index].data?[index1].link ??
                                                                                '',
                                                                            state.dataDetailSupport[index].data![index1].value_field ??
                                                                                '');
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
                                                                        decoration: (state.dataDetailSupport[index].data?[index1].label_field == BASE_URL.KHACH_HANG &&
                                                                                (state.dataDetailSupport[index].data?[index1].is_link ?? false))
                                                                            ? TextDecoration.underline
                                                                            : null,
                                                                        color: (state.dataDetailSupport[index].data?[index1].label_field == BASE_URL.KHACH_HANG &&
                                                                                (state.dataDetailSupport[index].data?[index1].is_link ?? false))
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
                            ),
                            SizedBox(
                              height: AppValue.heights * 0.02,
                            ),
                            ListNote(module: Module.HO_TRO, id: id)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ButtonThaoTac(onTap: () {
                        showThaoTac(context, list);
                      }),
                    ),
                  ],
                ),
              );
            } else
              return Container();
          }),
        ));
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
