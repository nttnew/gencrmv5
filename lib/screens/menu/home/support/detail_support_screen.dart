import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/support/detail_support_bloc.dart';
import 'package:gen_crm/screens/menu/home/customer/widget/list_note.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import '../../../../../src/src_index.dart';
import '../../../../bloc/checkin_bloc/checkin_bloc.dart';
import '../../../../bloc/list_note/list_note_bloc.dart';
import '../../../../bloc/support/support_bloc.dart';
import '../../../../l10n/key_text.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/loading_api.dart';
import '../../../../widgets/show_thao_tac.dart';
import '../../attachment/attachment.dart';
import '../../widget/information.dart';

class DetailSupportScreen extends StatefulWidget {
  const DetailSupportScreen({Key? key}) : super(key: key);

  @override
  State<DetailSupportScreen> createState() => _DetailSupportScreenState();
}

class _DetailSupportScreenState extends State<DetailSupportScreen> {
  String _id = Get.arguments ?? '';
  String _title = '';
  List<ModuleThaoTac> _list = [];
  int? _location;
  bool _isCheckDone = false;
  late final ListNoteBloc _blocNote;
  late final DetailSupportBloc _bloc;
  late final CheckInBloc _blocCheckIn;

  @override
  void initState() {
    _blocCheckIn = CheckInBloc.of(context);
    _bloc = DetailSupportBloc(
        userRepository: DetailSupportBloc.of(context).userRepository);
    _blocNote =
        ListNoteBloc(userRepository: ListNoteBloc.of(context).userRepository);
    _bloc.add(InitGetDetailSupportEvent(_id));
    super.initState();
  }

  _refresh() {
    _bloc.add(InitGetDetailSupportEvent(_id));
    _blocNote.add(RefreshEvent());
  }

  _checkLocation(SuccessGetDetailSupportState state) {
    _location = state.location;
    _isCheckDone = isCheckDataLocation(state.checkOut);
  }

  _getThaoTac() {
    _list = [];
    if (!_isCheckDone) {
      if (_location != 1) {
        //1 là có rồi
        _list.add(ModuleThaoTac(
          title: getT(KeyT.check_in),
          icon: ICONS.IC_LOCATION_SVG,
          onThaoTac: () {
            Get.back();
            AppNavigator.navigateCheckIn(
                _id.toString(), ModuleMy.CSKH, TypeCheckIn.CHECK_IN,
                onRefreshCheckIn: () {
              SupportBloc.of(context).add(InitGetSupportEvent());
              _bloc.add(InitGetDetailSupportEvent(_id));
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
                _id.toString(), ModuleMy.CSKH, TypeCheckIn.CHECK_OUT,
                onRefreshCheckIn: () {
              SupportBloc.of(context).add(InitGetSupportEvent());
              _bloc.add(InitGetDetailSupportEvent(_id));
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
          _id,
          type: ModuleMy.CSKH,
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.add_discuss),
      icon: ICONS.IC_ADD_DISCUSS_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateAddNoteScreen(Module.HO_TRO, _id, onRefresh: () {
          _blocNote.add(RefreshEvent());
        });
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.see_attachment),
      icon: ICONS.IC_ATTACK_SVG,
      onThaoTac: () async {
        Get.back();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Attachment(
                  id: _id,
                  typeModule: Module.HO_TRO,
                )));
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.edit),
      icon: ICONS.IC_EDIT_SVG,
      onThaoTac: () {
        Get.back();
        AppNavigator.navigateForm(
          type: EDIT_SUPPORT,
          id: int.tryParse(_id),
          onRefreshForm: () {
            _bloc.add(InitGetDetailSupportEvent(_id));
          },
        );
      },
    ));

    _list.add(ModuleThaoTac(
      title: getT(KeyT.delete),
      icon: ICONS.IC_DELETE_SVG,
      onThaoTac: () {
        ShowDialogCustom.showDialogBase(
          onTap2: () => _bloc.add(DeleteSupportEvent(_id)),
          content: getT(KeyT.are_you_sure_you_want_to_delete),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarBaseNormal(_title),
        body: BlocListener<CheckInBloc, CheckInState>(
          bloc: _blocCheckIn,
          listener: (context, state) {
            if (state is SuccessCheckInState) {
              SupportBloc.of(context).add(InitGetSupportEvent());
              _bloc.add(InitGetDetailSupportEvent(_id));
            } else if (state is ErrorCheckInState) {
              ShowDialogCustom.showDialogBase(
                title: getT(KeyT.notification),
                content: state.msg,
              );
            }
          },
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<DetailSupportBloc, DetailSupportState>(
                    bloc: _bloc,
                    builder: (context, state) {
                      if (state is SuccessGetDetailSupportState) {
                        _checkLocation(state);
                        _getThaoTac();
                        _title = checkTitle(
                          state.dataDetailSupport,
                          'ten_ht',
                        );
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          setState(() {});
                        });
                        return BlocListener<DetailSupportBloc,
                            DetailSupportState>(
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
                                  SupportBloc.of(context)
                                      .add(InitGetSupportEvent());
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
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await _refresh();
                            },
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 24,
                                    ),
                                    child: InfoBase(
                                      listData: state.dataDetailSupport,
                                      checkIn: state.checkIn,
                                      checkOut: state.checkOut,
                                    ),
                                  ),
                                  AppValue.vSpaceTiny,
                                  ListNote(
                                    module: Module.HO_TRO,
                                    id: _id,
                                    bloc: _blocNote,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (state is ErrorGetDetailSupportState) {
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
              ),
              BlocBuilder<DetailSupportBloc, DetailSupportState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (state is SuccessGetDetailSupportState)
                    return ButtonThaoTac(onTap: () {
                      showThaoTac(context, _list);
                    });
                  return ButtonThaoTac(disable: true, onTap: () {});
                },
              ),
            ],
          ),
        ));
  }
}
