import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/detail_customer.dart';
import '../../widgets/listview/list_load_infinity.dart';

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
    yield LoadingListDetailChanceState();
    try {
      final response = await userRepository.getListDetailChance(id);
      if (isSuccess(response.code)) {
        yield UpdateGetListDetailChanceState(response.data ?? []);
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else {
        yield ErrorGetListDetailChanceState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorGetListDetailChanceState(getT(KeyT.an_error_occurred));
    }
  }

  Stream<DetailChanceState> _deleteChance({required String id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.deleteChance({BASE_URL.ID: id});
      if (isSuccess(response.code)) {
        yield SuccessDeleteChanceState();
      } else {
        yield ErrorDeleteChanceState(response.msg ?? '');
      }
    } catch (e) {
      yield ErrorDeleteChanceState(getT(KeyT.an_error_occurred));
      throw e;
    }
    LoadingApi().popLoading();
  }

  Future<dynamic> getJobChance({
    required int id,
    int page = BASE_URL.PAGE_DEFAULT,
    bool isInit = true,
  }) async {
    try {
      final response = await userRepository.getJobChance(id, page);
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

  static GetListDetailChanceBloc of(BuildContext context) =>
      BlocProvider.of<GetListDetailChanceBloc>(context);
}
