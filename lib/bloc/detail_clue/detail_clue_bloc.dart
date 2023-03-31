import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:gen_crm/src/models/model_generator/clue_detail.dart';
import 'package:get/get.dart';

import '../../src/base.dart';
import '../../src/color.dart';
import '../../src/messages.dart';
import '../../src/navigator.dart';
import '../../widgets/loading_api.dart';
import '../../widgets/widget_dialog.dart';

part 'detail_clue_event.dart';

part 'detail_clue_state.dart';

class GetDetailClueBloc extends Bloc<GetDetailClueEvent, DetailClueState> {
  UserRepository userRepository;

  GetDetailClueBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetDetailClueState());

  @override
  Stream<DetailClueState> mapEventToState(GetDetailClueEvent event) async* {
    if (event is InitGetDetailClueEvent) {
      yield* _getDetailClue(event.id!);
    }
    if (event is InitDeleteClueEvent) {
      yield* _deleteClue(event.id!);
    }
  }

  Stream<DetailClueState> _getDetailClue(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingDetailClueState();
      final responseDetailClue = await userRepository.getDetailClue(id);
      if ((responseDetailClue.code == BASE_URL.SUCCESS) ||
          (responseDetailClue.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetDetailClueState(responseDetailClue.data!);
      } else {
        yield ErrorGetDetailClueState(responseDetailClue.msg ?? '');
        LoadingApi().popLoading();
        yield ErrorGetDetailClueState("${responseDetailClue.msg ?? ''}");
      }
    } catch (e) {
      yield ErrorGetDetailClueState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      Get.dialog(WidgetDialog(
        title: MESSAGES.NOTIFICATION,
        content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
        textButton1: "OK",
        backgroundButton1: COLORS.PRIMARY_COLOR,
        onTap1: () {
          AppNavigator.navigateLogout();
        },
      ));
      throw (e);
    }
    LoadingApi().popLoading();
  }

  Stream<DetailClueState> _deleteClue(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingDetailClueState();
      final responseDetailClue = await userRepository.deleteContact({"id": id});
      if ((responseDetailClue.code == BASE_URL.SUCCESS) ||
          (responseDetailClue.code == BASE_URL.SUCCESS_200)) {
        yield SuccessDeleteClueState();
      } else {
        yield ErrorDeleteClueState(responseDetailClue.msg ?? '');
        LoadingApi().popLoading();
        // yield ErrorGetDetailClueState("${responseDetailClue.msg ?? ''}"+" "+ "${responseListNoteClue.msg ?? ''}");
        yield ErrorDeleteClueState("${responseDetailClue.msg ?? ''}");
      }
    } catch (e) {
      yield ErrorDeleteClueState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      Get.dialog(WidgetDialog(
        title: MESSAGES.NOTIFICATION,
        content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
        textButton1: "OK",
        backgroundButton1: COLORS.PRIMARY_COLOR,
        onTap1: () {
          AppNavigator.navigateLogout();
        },
      ));
      throw (e);
    }
    LoadingApi().popLoading();
  }

  static GetDetailClueBloc of(BuildContext context) =>
      BlocProvider.of<GetDetailClueBloc>(context);
}
