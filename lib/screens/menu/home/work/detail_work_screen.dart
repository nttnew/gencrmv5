import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/work/detail_work_bloc.dart';
import 'package:gen_crm/bloc/work/work_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/list_note.dart';
import 'package:get/get.dart';
import '../../../../../src/src_index.dart';
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
import '../../widget/information.dart';

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
  late final CheckInBloc _blocCheckIn;

  @override
  void initState() {
    _blocCheckIn = CheckInBloc.of(context);
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
    isCheckDone = isCheckDataLocation(state.checkOut);
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
                onRefreshCheckIn: () {
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
            AppNavigator.navigateCheckIn(
                id.toString(), ModuleMy.CONG_VIEC, TypeCheckIn.CHECK_OUT,
                onRefreshCheckIn: () {
              _bloc.add(InitGetDetailWorkEvent(id));
              WorkBloc.of(context).loadMoreController.reloadData();
            });
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
        AppNavigator.navigateForm(
          type: EDIT_JOB,
          id: id,
          onRefreshForm: () {
            WorkBloc.of(context).loadMoreController.reloadData();
            _bloc.add(InitGetDetailWorkEvent(id));
          },
        );
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
        bloc: _blocCheckIn,
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
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    top: 24,
                                  ),
                                  child: InfoBase(
                                    listData: state.dataList,
                                    checkIn: state.checkIn,
                                    checkOut: state.checkOut,
                                  ),
                                );
                              } else if (state is ErrorDeleteWorkState) {
                                return Text(
                                  state.msg,
                                  style: AppStyle.DEFAULT_16_T,
                                );
                              } else
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    top: 24,
                                  ),
                                  child: loadInfo(),
                                );
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
              BlocBuilder<DetailWorkBloc, DetailWorkState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (state is SuccessDetailWorkState)
                    return ButtonThaoTac(
                      onTap: () {
                        showThaoTac(context, list);
                      },
                    );
                  return ButtonThaoTac(
                    disable: true,
                    onTap: () {},
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
