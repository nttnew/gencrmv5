import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/detail_customer.dart';
import '../../widgets/listview/list_load_infinity.dart';
import '../../widgets/loading_api.dart';

part 'detail_clue_event.dart';

part 'detail_clue_state.dart';

class GetDetailClueBloc extends Bloc<GetDetailClueEvent, DetailClueState> {
  UserRepository userRepository;
  LoadMoreController controllerCV = LoadMoreController();

  GetDetailClueBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetDetailClueState());

  @override
  Stream<DetailClueState> mapEventToState(GetDetailClueEvent event) async* {
    if (event is InitGetDetailClueEvent) {
      yield* _getDetailClue(event.id ?? '');
    } else if (event is InitDeleteClueEvent) {
      yield* _deleteClue(event.id ?? '');
    }
  }

  Stream<DetailClueState> _getDetailClue(String id) async* {
    try {
      yield LoadingDetailClueState();
      final responseDetailClue = await userRepository.getDetailClue(id);
      if (isSuccess(responseDetailClue.code)) {
        yield GetDetailClueState(responseDetailClue.data ?? []);
      } else {
        yield ErrorGetDetailClueState(responseDetailClue.msg ?? '');
      }
    } catch (e) {
      yield ErrorGetDetailClueState(getT(KeyT.an_error_occurred));
    }
  }

  Stream<DetailClueState> _deleteClue(String id) async* {
    Loading().showLoading();
    try {
      yield LoadingDetailClueState();
      final responseDetailClue =
          await userRepository.deleteContact({BASE_URL.ID: id});
      if (isSuccess(responseDetailClue.code)) {
        yield SuccessDeleteClueState();
      } else {
        yield ErrorDeleteClueState(responseDetailClue.msg ?? '');
      }
    } catch (e) {
      Loading().popLoading();
      yield ErrorDeleteClueState(getT(KeyT.an_error_occurred));
      throw (e);
    }
    Loading().popLoading();
  }

  Future<dynamic> getWorkClue({
    required String id,
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    try {
      final response = await userRepository.getWorkClue(id, page);
      if (isSuccess(response.code)) {
        return response.data ?? [];
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        return response.msg ?? '';
      }
    } catch (e) {
      return getT(KeyT.an_error_occurred);
    }
  }

  static GetDetailClueBloc of(BuildContext context) =>
      BlocProvider.of<GetDetailClueBloc>(context);
}
