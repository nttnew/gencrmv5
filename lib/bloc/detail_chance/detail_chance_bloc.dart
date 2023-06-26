import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/detail_chance.dart';
import '../../widgets/listview_loadmore_base.dart';

part 'detail_chance_event.dart';
part 'detail_chance_state.dart';

class GetListDetailChanceBloc
    extends Bloc<DetailChanceEvent, DetailChanceState> {
  final UserRepository userRepository;
  LoadMoreController controllerCV = LoadMoreController();

  GetListDetailChanceBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListDetailChance());

  @override
  Stream<DetailChanceState> mapEventToState(DetailChanceEvent event) async* {
    if (event is InitGetListDetailEvent) {
      initController(event.id);
      yield* _getListChanceDetail(id: event.id);
    } else if (event is InitDeleteChanceEvent) {
      yield* _deleteChance(id: event.id);
    }
  }

  initController(int idTxt) async {
    final dataCv = await getJobChance(
        page: BASE_URL.PAGE_DEFAULT, id: idTxt, isInit: false);
    await controllerCV.initData(dataCv);
  }

  Stream<DetailChanceState> _getListChanceDetail({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListDetailChance(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetListDetailChanceState(response.data ?? []);
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else {
        yield ErrorGetListDetailChanceState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetListDetailChanceState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      LoadingApi().popLoading();
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<DetailChanceState> _deleteChance({required String id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.deleteChance({BASE_URL.ID: id});
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessDeleteChanceState();
      } else {
        yield ErrorDeleteChanceState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorDeleteChanceState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  Future<dynamic> getJobChance(
      {required int id,
      int page = BASE_URL.PAGE_DEFAULT,
      bool isInit = true}) async {
    if (isInit) {
      LoadingApi().pushLoading();
    }
    try {
      final response = await userRepository.getJobChance(id, page);
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

  static GetListDetailChanceBloc of(BuildContext context) =>
      BlocProvider.of<GetListDetailChanceBloc>(context);
}
