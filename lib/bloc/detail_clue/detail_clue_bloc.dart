import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:gen_crm/src/models/model_generator/clue_detail.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../widgets/listview_loadmore_base.dart';
import '../../widgets/loading_api.dart';

part 'detail_clue_event.dart';

part 'detail_clue_state.dart';

class GetDetailClueBloc extends Bloc<GetDetailClueEvent, DetailClueState> {
  UserRepository userRepository;
  LoadMoreController controllerCV = LoadMoreController();

  GetDetailClueBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetDetailClueState());

  initController(String idTxt) async {
    final dataCv = await getWorkClue(
        page: BASE_URL.PAGE_DEFAULT, id: idTxt, isInit: false);
    await controllerCV.initData(dataCv);
  }

  @override
  Stream<DetailClueState> mapEventToState(GetDetailClueEvent event) async* {
    if (event is InitGetDetailClueEvent) {
      initController(event.id ?? '');
      yield* _getDetailClue(event.id ?? '');
    } else if (event is InitDeleteClueEvent) {
      yield* _deleteClue(event.id ?? '');
    }
  }

  Stream<DetailClueState> _getDetailClue(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingDetailClueState();
      final responseDetailClue = await userRepository.getDetailClue(id);
      if ((responseDetailClue.code == BASE_URL.SUCCESS) ||
          (responseDetailClue.code == BASE_URL.SUCCESS_200)) {
        yield GetDetailClueState(responseDetailClue.data ?? []);
      } else {
        LoadingApi().popLoading();
        yield ErrorGetDetailClueState(responseDetailClue.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetDetailClueState(MESSAGES.CONNECT_ERROR);
      throw (e);
    }
    LoadingApi().popLoading();
  }

  Stream<DetailClueState> _deleteClue(String id) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingDetailClueState();
      final responseDetailClue =
          await userRepository.deleteContact({BASE_URL.ID: id});
      if ((responseDetailClue.code == BASE_URL.SUCCESS) ||
          (responseDetailClue.code == BASE_URL.SUCCESS_200)) {
        yield SuccessDeleteClueState();
      } else {
        yield ErrorDeleteClueState(responseDetailClue.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorDeleteClueState(MESSAGES.CONNECT_ERROR);
      throw (e);
    }
    LoadingApi().popLoading();
  }

  Future<dynamic> getWorkClue(
      {required String id,
      int page = BASE_URL.PAGE_DEFAULT,
      bool isInit = true}) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response = await userRepository.getWorkClue(id, page);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        LoadingApi().popLoading();
        return response.data ?? [];
      } else if (response.code == BASE_URL.SUCCESS_999) {
        LoadingApi().popLoading();
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        return response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
    }
  }

  static GetDetailClueBloc of(BuildContext context) =>
      BlocProvider.of<GetDetailClueBloc>(context);
}
