import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/chance.dart';
import '../../widgets/listview/list_load_infinity.dart';

part 'chance_event.dart';
part 'chance_state.dart';

class GetListChanceBloc extends Bloc<GetListChanceEvent, ChanceState> {
  final UserRepository userRepository;
  BehaviorSubject<List<FilterChance>> listType = BehaviorSubject.seeded([]);
  LoadMoreController loadMoreController = LoadMoreController();
  String idFilter = '';
  String search = '';
  String ids = '';

  init() {
    idFilter = '';
    search = '';
    ids = '';
  }

  GetListChanceBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListChance());

  Future<dynamic> getListChance({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    LoadingApi().pushLoading();
    dynamic resDynamic = '';
    try {
      final response = await userRepository.getListChance(
        page,
        idFilter,
        search,
        ids,
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (page == BASE_URL.PAGE_DEFAULT)
          listType.add(response.data?.filter ?? []);
        resDynamic = response.data?.list ?? [];
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        resDynamic = response.msg ?? '';
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      throw e;
    }
    LoadingApi().popLoading();
    return resDynamic;
  }

  static GetListChanceBloc of(BuildContext context) =>
      BlocProvider.of<GetListChanceBloc>(context);
}
