import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/support/detail_support_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/list_note.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/line_horizontal_widget.dart';
import '../../../../bloc/checkin_bloc/checkin_bloc.dart';
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../bloc/support/support_bloc.dart';
import '../../../../l10n/key_text.dart';
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
  late final ListNoteBloc _blocNote;
  late final DetailSupportBloc _bloc;

  @override
  void initState() {
    _bloc = DetailSupportBloc(
        userRepository: DetailSupportBloc.of(context).userRepository);
    _blocNote =
        ListNoteBloc(userRepository: ListNoteBloc.of(context).userRepository);
    _bloc.add(InitGetDetailSupportEvent(id));
    super.initState();
  }

  _refresh() {
    _bloc.add(InitGetDetailSupportEvent(id));
    _blocNote.add(RefreshEvent());
  }

  checkLocation(SuccessGetDetailSupportState state) {
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
          title: getT(KeyT.check_in),
          icon: ICONS.IC_LOCATION_SVG,
          onThaoTac: () {
            Get.back();
            AppNavigator.navigateCheckIn(
                id.toString(), ModuleMy.CSKH, TypeCheckIn.CHECK_IN,
                onRefresh: () {
              SupportBloc.of(context).add(InitGetSupportEvent());
              _bloc.add(InitGetDetailSupportEvent(id));
            });
          },
        ));
      } else {
        list.add(ModuleThaoTac(
          title: getT(KeyT.check_out),
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
      title: getT(KeyT.sign),
      icon: ICONS.IC_ELECTRIC_SIGN_PNG,
      isSvg: false,
      onThaoTac: () {
        //todo
        Get.back();
        AppNavigator.navigateFormSign(getT(KeyT.sign), id, type: 'support');
      },
    ));

    list.add(ModuleThaoTac(
      title: getT(KeyT.add_discuss),
      icon: ICONS.IC_ADD_DISCUSS_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddNoteScreen(Module.HO_TRO, id, onRefresh: () {
          _blocNote.add(RefreshEvent());
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: getT(KeyT.see_attachment),
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
      title: getT(KeyT.edit),
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id, EDIT_SUPPORT, onRefresh: () {
          _bloc.add(InitGetDetailSupportEvent(id));
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: getT(KeyT.delete),
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
          onTap2: () => _bloc.add(DeleteSupportEvent(id)),
          content: getT(KeyT.are_you_sure_you_want_to_delete),
        );
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
              SupportBloc.of(context).add(InitGetSupportEvent());
              _bloc.add(InitGetDetailSupportEvent(id));
            } else if (state is ErrorCheckInState) {
              ShowDialogCustom.showDialogBase(
                title: getT(KeyT.notification),
                content: state.msg,
              );
            }
          },
          child: BlocBuilder<DetailSupportBloc, DetailSupportState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is SuccessGetDetailSupportState) {
                  checkLocation(state);
                  getThaoTac();
                  return BlocListener<DetailSupportBloc, DetailSupportState>(
                    bloc: _bloc,
                    listener: (context, state) async {
                      if (state is SuccessDeleteSupportState) {
                        LoadingApi().popLoading();
                        ShowDialogCustom.showDialogBase(
                          title: getT(KeyT.notification),
                          content: getT(KeyT.success),
                          onTap1: () {
                            Get.back();
                            Get.back();
                            Get.back();
                            Get.back();
                            SupportBloc.of(context).add(InitGetSupportEvent());
                          },
                        );
                      } else if (state is ErrorDeleteSupportState) {
                        LoadingApi().popLoading();
                        ShowDialogCustom.showDialogBase(
                          title: getT(KeyT.notification),
                          content: state.msg,
                          textButton1: getT(KeyT.come_back),
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
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await _refresh();
                            },
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    margin: EdgeInsets.only(
                                      top: 24,
                                    ),
                                    child: Column(
                                      children: List.generate(
                                        state.dataDetailSupport.length,
                                        (index) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
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
                                                      .data!.length, (index1) {
                                                final isKH = state
                                                            .dataDetailSupport[
                                                                index]
                                                            .data?[index1]
                                                            .id ==
                                                        'khach_hang' &&
                                                    (state
                                                            .dataDetailSupport[
                                                                index]
                                                            .data?[index1]
                                                            .is_link ??
                                                        false);
                                                if (state
                                                        .dataDetailSupport[
                                                            index]
                                                        .data![index1]
                                                        .value_field !=
                                                    '')
                                                  return Column(
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            AppValue.heights *
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
                                                            style: LabelStyle(),
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                if (isKH) {
                                                                  AppNavigator.navigateDetailCustomer(
                                                                      state.dataDetailSupport[index].data?[index1].link ??
                                                                          '',
                                                                      state.dataDetailSupport[index].data![index1]
                                                                              .value_field ??
                                                                          '');
                                                                }
                                                              },
                                                              child: WidgetText(
                                                                title: state
                                                                        .dataDetailSupport[
                                                                            index]
                                                                        .data![
                                                                            index1]
                                                                        .value_field ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style:
                                                                    ValueStyle()
                                                                        .copyWith(
                                                                  decoration: isKH
                                                                      ? TextDecoration
                                                                          .underline
                                                                      : null,
                                                                  color: isKH
                                                                      ? Colors
                                                                          .blue
                                                                      : null,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                return SizedBox();
                                              }),
                                            ),
                                            SizedBox(
                                              height: AppValue.heights * 0.02,
                                            ),
                                            LineHorizontal(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppValue.heights * 0.02,
                                  ),
                                  ListNote(
                                    module: Module.HO_TRO,
                                    id: id,
                                    bloc: _blocNote,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        ButtonThaoTac(onTap: () {
                          showThaoTac(context, list);
                        }),
                      ],
                    ),
                  );
                } else
                  return Container();
              }),
        ));
  }

  TextStyle ValueStyle([String? color]) => TextStyle(
        fontFamily: "Quicksand",
        color: color == null ? HexColor("#263238") : HexColor(color),
        fontWeight: FontWeight.w700,
        fontSize: 14,
      );

  TextStyle LabelStyle() => TextStyle(
        fontFamily: "Quicksand",
        color: COLORS.GREY,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
}
