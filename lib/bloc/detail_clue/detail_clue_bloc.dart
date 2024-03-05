import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/detail_customer.dart';
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
      yield ErrorGetDetailClueState(getT(KeyT.an_error_occurred));
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
      yield ErrorDeleteClueState(getT(KeyT.an_error_occurred));
      throw (e);
    }
    LoadingApi().popLoading();
  }

  Future<dynamic> getWorkClue({
    required String id,
    int page = BASE_URL.PAGE_DEFAULT,
    bool isInit = true,
  }) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response = await userRepository.getWorkClue(id, page);
      if (isSuccess(response.code)) {
        if (isInit) LoadingApi().popLoading();
        return response.data ?? [];
      } else if (isFail(response.code)) {
        if (isInit) LoadingApi().popLoading();
        loginSessionExpired();
      } else {
        if (isInit) LoadingApi().popLoading();
        return response.msg ?? '';
      }
    } catch (e) {
      if (isInit) LoadingApi().popLoading();
      return getT(KeyT.an_error_occurred);
    }
  }

  static GetDetailClueBloc of(BuildContext context) =>
      BlocProvider.of<GetDetailClueBloc>(context);
}
