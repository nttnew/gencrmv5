import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/chance.dart';

part 'chance_event.dart';
part 'chance_state.dart';

class GetListChanceBloc extends Bloc<GetListChanceEvent, ChanceState> {
  final UserRepository userRepository;

  GetListChanceBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListChance());

  @override
  Stream<ChanceState> mapEventToState(GetListChanceEvent event) async* {
    if (event is InitGetListOrderEventChance) {
      yield* _getListChance(
          filter: event.filter,
          page: event.page,
          search: event.search,
          isLoadMore: event.isLoadMore);
    }
  }

  List<ListChanceData>? listChance;

  Stream<ChanceState> _getListChance(
      {required String filter,
      required int page,
      required String search,
      bool? isLoadMore = false}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListChance(page, filter, search);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (page == 1) {
          listChance = response.data!.list;
          yield UpdateGetListChanceState(response.data!.list!,
              response.data!.total!, response.data!.filter!);
        } else {
          listChance!.addAll(response.data!.list!);
          yield UpdateGetListChanceState(
              listChance!, response.data!.total!, response.data!.filter!);
        }
      } else if (response.code == 999) {
        loginSessionExpired();
      } else
        yield ErrorGetListChanceState(response.msg ?? '');
    } catch (e) {
      yield ErrorGetListChanceState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      loginSessionExpired();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static GetListChanceBloc of(BuildContext context) =>
      BlocProvider.of<GetListChanceBloc>(context);
}
