import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/work/detail_work_bloc.dart';
import 'package:gen_crm/bloc/work/work_bloc.dart';
import 'package:gen_crm/screens/home/customer/widget/list_note.dart';
import 'package:gen_crm/screens/widget/audio_widget.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import '../../../../../src/src_index.dart';
import '../../../../bloc/checkin_bloc/checkin_bloc.dart';
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../widgets/btn_thao_tac.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../../../widgets/widget_appbar.dart';
import '../../attachment/attachment.dart';
import '../../widget/information.dart';

class DetailWorkScreen extends StatefulWidget {
  const DetailWorkScreen({Key? key}) : super(key: key);

  @override
  State<DetailWorkScreen> createState() => _DetailWorkScreenState();
}

class _DetailWorkScreenState extends State<DetailWorkScreen> {
  int _id = Get.arguments ?? '';
  String _title = '';
  int? _location;
  String _diDong = '';
  String _audio = '';
  bool _isCheckDone = false;
  List<ModuleThaoTac> _list = [];
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
    _bloc.add(InitGetDetailWorkEvent(_id));
    super.initState();
  }

  _init() {
    _blocNote.add(RefreshEvent());
    _bloc.add(InitGetDetailWorkEvent(_id));
  }

  _checkLocation(SuccessDetailWorkState state) {
    _location = state.location;
    _diDong = state.diDong ?? '';
    _isCheckDone = isCheckDataLocation(state.checkOut);
    _audio = state.audioUrl ?? '';
  }

  _getThaoTac() {
    _list = [];
    if (_diDong != '')
      _list.add(
        ModuleThaoTac(
          isSvg: false,
          title: getT(KeyT.call),
          icon: ICONS.IC_PHONE_PNG,
          onThaoTac: () {
            Get.back();
            dialogShowAllSDT(
              context,
              handelListSdt(_diDong),
              name: '',
            );
          },
        ),
      );

    if (_audio != '')
      _list.add(
        ModuleThaoTac(
          isSvg: false,
          title: getT(KeyT.audio),
          icon: ICONS.IC_AUDIO_PNG,
          onThaoTac: () {
            Get.back();
            ShowDialogCustom.showDialogScreenBase(
              isPop: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getT(KeyT.audio),
                    style: AppStyle.DEFAULT_16_BOLD,
                  ),
                  AudioBase(
                    audioUrl: _audio,
                    isDetail: true,
                  ),
                ],
              ),
            );
          },
        ),
      );

    if (!_isCheckDone) {
      if (_location != 1) {
        _list.add(ModuleThaoTac(
          title: getT(KeyT.check_in),
          icon: ICONS.IC_LOCATION_SVG,
          onThaoTac: () {
            Get.back();
            AppNavigator.navigateCheckIn(
                _id.toString(), ModuleMy.CONG_VIEC, TypeCheckIn.CHECK_IN,
                onRefresh: () {
              _bloc.add(InitGetDetailWorkEvent(_id));
              WorkBloc.of(context).loadMoreController.reloadData();
            });
          },
        ));
      } else {
        _list.add(ModuleThaoTac(
          title: getT(KeyT.check_out),
          icon: ICONS.IC_LOCATION_SVG,
          onThaoTac: () {
            Get.back();
            AppNavigator.navigateCheckIn(
                _id.toString(), ModuleMy.CONG_VIEC, TypeCheckIn.CHECK_OUT,
                onRefresh: () {
              _bloc.add(InitGetDetailWorkEvent(_id));
              WorkBloc.of(context).loadMoreController.reloadData();
            });
          },
        ));
      }
    }

    _list.add(ModuleThaoTac(
      title: getT(KeyT.sign),
      icon: ICONS.IC_ELECTRIC_SIGN_PNG,
      isSvg: false,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateFormSign(
          getT(KeyT.sign),
          _id.toString(),
          type: Module.CONG_VIEC,
          onRefresh: () {
            _bloc.add(InitGetDetailWorkEvent(_id));
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.add_discuss),
      icon: ICONS.IC_ADD_DISCUSS_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddNoteScreen(Module.CONG_VIEC, _id.toString(),
            onRefresh: () {
          _blocNote.add(RefreshEvent());
        });
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.see_attachment),
      icon: ICONS.IC_ATTACK_PNG,
      isSvg: false,
      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: _id.toString(),
                  typeModule: Module.CONG_VIEC,
                )));
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.edit),
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateForm(
          type: EDIT_JOB,
          id: _id,
          onRefreshForm: () {
            WorkBloc.of(context).loadMoreController.reloadData();
            _bloc.add(InitGetDetailWorkEvent(_id));
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.delete),
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
          onTap2: () => _bloc.add(InitDeleteWorkEvent(_id)),
          content: getT(KeyT.are_you_sure_you_want_to_delete),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CheckInBloc, CheckInState>(
        bloc: _blocCheckIn,
        listener: (context, state) {
          if (state is SuccessCheckInState) {
            _bloc.add(InitGetDetailWorkEvent(_id));
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
              Loading().popLoading();
              ShowDialogCustom.showDialogBase(
                title: getT(KeyT.notification),
                content: getT(KeyT.success),
                onTap1: () {
                  Get.back();
                  Get.back();
                  Get.back();
                  Get.back(result: true);
                  WorkBloc.of(context).loadMoreController.reloadData();
                },
              );
            } else if (state is ErrorDeleteWorkState) {
              Loading().popLoading();
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
              WidgetAppbar(
                title: _title,
                textColor: COLORS.BLACK,
                padding: 10,
                right: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        AppNavigator.navigateBieuMau(
                          idDetail: _id.toString(),
                          module: PDF_CONG_VIEC,
                        );
                      },
                      icon: Icon(
                        Icons.print,
                        color: !isCarCrm() ? COLORS.BLACK : COLORS.WHITE,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  color: getBackgroundWithIsCar(),
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
                                _checkLocation(state);
                                _getThaoTac();
                                _title = checkTitle(
                                  state.dataList,
                                  'cv_name',
                                );
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  setState(() {});
                                });
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
                          id: _id.toString(),
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
                    return ButtonCustom(
                      onTap: () {
                        showThaoTac(context, _list);
                      },
                    );
                  return ButtonCustom();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
