import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_resfull/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/chance.dart';

part 'chance_event.dart';
part 'chance_state.dart';

class GetListChanceBloc extends Bloc<GetListChanceEvent, ChanceState> {
  final UserRepository userRepository;
  BehaviorSubject<List<FilterChance>> listType = BehaviorSubject.seeded([]);

  GetListChanceBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListChance());

  @override
  Stream<ChanceState> mapEventToState(GetListChanceEvent event) async* {
    if (event is InitGetListOrderEventChance) {
      yield* _getListChance(
        ids: event.ids ?? '',
        filter: event.filter ?? '',
        page: event.page ?? BASE_URL.PAGE_DEFAULT,
        search: event.search ?? '',
        isLoadMore: event.isLoadMore,
      );
    }
  }

  List<ListChanceData>? listChance;

  Stream<ChanceState> _getListChance({
    required String filter,
    required String ids,
    required int page,
    required String search,
    bool? isLoadMore = false,
  }) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListChance(
        page,
        filter,
        search,
        ids,
      );
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        listType.add(response.data?.filter ?? []);
        if (page == BASE_URL.PAGE_DEFAULT) {
          listChance = response.data?.list ?? [];
          yield UpdateGetListChanceState(
            response.data?.list ?? [],
            response.data?.total ?? '0',
          );
        } else {
          yield UpdateGetListChanceState(
              [...listChance ?? [], ...response.data?.list ?? []],
              response.data?.total ?? '0');
          listChance?.addAll(response.data?.list ?? []);
        }
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorGetListChanceState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetListChanceState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  static GetListChanceBloc of(BuildContext context) =>
      BlocProvider.of<GetListChanceBloc>(context);
}
