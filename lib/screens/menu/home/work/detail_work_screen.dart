import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gen_crm/bloc/work/detail_work_bloc.dart';
import 'package:gen_crm/bloc/work/work_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/list_note.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../src/src_index.dart';
import '../../../../../widgets/line_horizontal_widget.dart';
import '../../../../bloc/checkin_bloc/checkin_bloc.dart';
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/btn_thao_tac.dart';
import '../../../../widgets/dialog_call.dart';
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
  String? diDong;
  bool isCheckDone = false;
  List<ModuleThaoTac> list = [];
  late final ListNoteBloc _blocNote;
  late final DetailWorkBloc _bloc;

  @override
  void initState() {
    _bloc = DetailWorkBloc(
        userRepository: DetailWorkBloc.of(context).userRepository);
    _blocNote =
        ListNoteBloc(userRepository: ListNoteBloc.of(context).userRepository);
    _bloc.add(InitGetDetailWorkEvent(id));
    super.initState();
  }

  _init() {
    _blocNote.add(RefreshEvent());
    _bloc.add(InitGetDetailWorkEvent(id));
  }

  checkLocation(SuccessDetailWorkState state) {
    location = state.location;
    diDong = state.diDong;
    if (state.data_list.isNotEmpty) {
      final listLocation = (state.data_list.first.data ?? [])
          .where((element) => element.id == 'checkout')
          .toList();
      if (listLocation.isNotEmpty) {
        isCheckDone = listLocation.first.value_field != '' &&
            listLocation.first.value_field != null;
      }
    }
  }

  getThaoTac() {
    list = [];
    if (diDong != null && diDong != '')
      list.add(
        ModuleThaoTac(
          isSvg: false,
          title: getT(KeyT.call),
          icon: ICONS.IC_PHONE_PNG,
          onThaoTac: () {
            Get.back();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogCall(
                  phone: diDong.toString(),
                  name: '',
                );
              },
            );
          },
        ),
      );

    list.add(ModuleThaoTac(
      title: getT(KeyT.add_discuss),
      icon: ICONS.IC_ADD_DISCUSS_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddNoteScreen(Module.CONG_VIEC, id.toString(),
            onRefresh: () {
          _blocNote.add(RefreshEvent());
        });
      },
    ));
    if (!isCheckDone) {
      if (location != 1) {
        list.add(ModuleThaoTac(
          title: getT(KeyT.check_in),
          icon: ICONS.IC_LOCATION_SVG,
          onThaoTac: () {
            Get.back();
            AppNavigator.navigateCheckIn(
                id.toString(), ModuleMy.CONG_VIEC, TypeCheckIn.CHECK_IN,
                onRefresh: () {
              _bloc.add(InitGetDetailWorkEvent(id));
              WorkBloc.of(context).loadMoreController.reloadData();
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
                id.toString(),
                ModuleMy.CONG_VIEC,
                TypeCheckIn.CHECK_OUT,
              ),
            );
            _bloc.add(InitGetDetailWorkEvent(id));
          },
        ));
      }
    }

    list.add(ModuleThaoTac(
      title: getT(KeyT.see_attachment),
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
      title: getT(KeyT.edit),
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateEditDataScreen(id.toString(), EDIT_JOB,
            onRefresh: () {
          WorkBloc.of(context).loadMoreController.reloadData();

          _bloc.add(InitGetDetailWorkEvent(id));
        });
      },
    ));

    list.add(ModuleThaoTac(
      title: getT(KeyT.delete),
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
          onTap2: () => _bloc.add(InitDeleteWorkEvent(id)),
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
            _bloc.add(InitGetDetailWorkEvent(id));
          } else if (state is ErrorCheckInState) {
            ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: state.msg,
            );
          }
        },
        child: BlocListener<DetailWorkBloc, DetailWorkState>(
          bloc: _bloc,
          listener: (context, state) {
            if (state is SuccessDeleteWorkState) {
              LoadingApi().popLoading();
              ShowDialogCustom.showDialogBase(
                title: getT(KeyT.notification),
                content: getT(KeyT.success),
                onTap1: () {
                  Get.back();
                  Get.back();
                  Get.back();
                  Get.back();
                  WorkBloc.of(context).loadMoreController.reloadData();
                },
              );
            } else if (state is ErrorDeleteWorkState) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await _init();
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<DetailWorkBloc, DetailWorkState>(
                            bloc: _bloc,
                            builder: (context, state) {
                              if (state is SuccessDetailWorkState) {
                                checkLocation(state);
                                getThaoTac();
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  margin: EdgeInsets.only(
                                    top: 24,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                        state.data_list.length,
                                        (index) => Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
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
                                                  height:
                                                      AppValue.heights * 0.02,
                                                ),
                                                Column(
                                                  children: List.generate(
                                                      state
                                                          .data_list[index]
                                                          .data!
                                                          .length, (index1) {
                                                    bool isKH = state
                                                                .data_list[
                                                                    index]
                                                                .data?[index1]
                                                                .id ==
                                                            'cv_kh' &&
                                                        (state
                                                                .data_list[
                                                                    index]
                                                                .data?[index1]
                                                                .is_link ??
                                                            false);
                                                    bool isSPKH = state
                                                            .data_list[index]
                                                            .data?[index1]
                                                            .id ==
                                                        'cvsan_pham_kh';
                                                    if (state
                                                            .data_list[index]
                                                            .data![index1]
                                                            .value_field !=
                                                        '')
                                                      return Column(
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
                                                                  onTap: () {
                                                                    if (isKH) {
                                                                      AppNavigator.navigateDetailCustomer(
                                                                          state.data_list[index].data?[index1].link ??
                                                                              '',
                                                                          state.data_list[index].data![index1].value_field ??
                                                                              '');
                                                                    } else if (isSPKH) {
                                                                      AppNavigator
                                                                          .navigateDetailProductCustomer(
                                                                        state.data_list[index].data?[index1].label_field ??
                                                                            '',
                                                                        state.data_list[index].data?[index1].link ??
                                                                            '',
                                                                      );
                                                                    }
                                                                  },
                                                                  child:
                                                                      SizedBox(
                                                                    child: state.data_list[index].data![index1].type !=
                                                                            'text_area'
                                                                        ? WidgetText(
                                                                            title:
                                                                                state.data_list[index].data![index1].value_field,
                                                                            textAlign:
                                                                                TextAlign.right,
                                                                            style:
                                                                                ValueStyle().copyWith(
                                                                              decoration: isKH || isSPKH ? TextDecoration.underline : null,
                                                                              color: isKH || isSPKH ? Colors.blue : null,
                                                                            ),
                                                                          )
                                                                        : Html(
                                                                            data:
                                                                                state.data_list[index].data![index1].value_field,
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
                                                      );
                                                    return SizedBox();
                                                  }),
                                                ),
                                                LineHorizontal(),
                                              ],
                                            )),
                                  ),
                                );
                              } else
                                return SizedBox.shrink();
                            }),
                        SizedBox(
                          height: 16,
                        ),
                        ListNote(
                          module: Module.CONG_VIEC,
                          id: id.toString(),
                          bloc: _blocNote,
                        ),
                      ],
                    ),
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
