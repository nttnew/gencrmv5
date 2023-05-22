import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/detail_chance.dart';

part 'detail_chance_event.dart';
part 'detail_chance_state.dart';

class GetListDetailChanceBloc
    extends Bloc<DetailChanceEvent, DetailChanceState> {
  final UserRepository userRepository;

  GetListDetailChanceBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetListDetailChance());

  @override
  Stream<DetailChanceState> mapEventToState(DetailChanceEvent event) async* {
    if (event is InitGetListDetailEvent) {
      yield* _getListChanceDetail(id: event.id);
    } else if (event is InitDeleteChanceEvent) {
      yield* _deleteChance(id: event.id);
    }
  }

  Stream<DetailChanceState> _getListChanceDetail({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getListDetailChance(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetListDetailChanceState(response.data!);
      } else if (response.code == 999) {
        loginSessionExpired();
      } else {
        yield ErrorGetListDetailChanceState(response.msg ?? '');
        LoadingApi().popLoading();
      }
    } catch (e) {
      yield ErrorGetListDetailChanceState(MESSAGES.CONNECT_ERROR);
      LoadingApi().popLoading();
      loginSessionExpired();
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
      yield ErrorDeleteChanceState(MESSAGES.CONNECT_ERROR);
      loginSessionExpired();
      throw e;
    }
    LoadingApi().popLoading();
  }

  static GetListDetailChanceBloc of(BuildContext context) =>
      BlocProvider.of<GetListDetailChanceBloc>(context);
}
