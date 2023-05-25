import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/loading_api.dart';

import '../../api_resfull/user_repository.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/index.dart';
import '../../src/models/model_generator/support.dart';

part 'detail_support_event.dart';
part 'detail_support_state.dart';

class DetailSupportBloc extends Bloc<DetailSupportEvent, DetailSupportState> {
  final UserRepository userRepository;

  DetailSupportBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetDetailSupport());

  @override
  Stream<DetailSupportState> mapEventToState(DetailSupportEvent event) async* {
    if (event is InitGetDetailSupportEvent) {
      yield* _getDetailSupport(id: event.id);
    }
    if (event is DeleteSupportEvent) {
      yield* _deleteSupport(id: event.id);
    }
  }

  List<SupportItemData>? list;

  Stream<DetailSupportState> _getDetailSupport({required String id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingDetailSupportState();
      final response = await userRepository.getDetailSupport(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessGetDetailSupportState(
            response.data ?? [], response.location);
      } else
        yield ErrorGetDetailSupportState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      loginSessionExpired();
      yield ErrorGetDetailSupportState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<DetailSupportState> _deleteSupport({required String id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.deleteSupport({"id": id});
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessDeleteSupportState();
      } else
        yield ErrorDeleteSupportState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      loginSessionExpired();
      yield ErrorDeleteSupportState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static DetailSupportBloc of(BuildContext context) =>
      BlocProvider.of<DetailSupportBloc>(context);
}
