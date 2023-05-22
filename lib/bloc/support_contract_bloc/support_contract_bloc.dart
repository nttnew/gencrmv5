import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/detail_contract.dart';
import '../../widgets/loading_api.dart';

part 'support_contract_event.dart';
part 'support_contract_state.dart';

class SupportContractBloc
    extends Bloc<SupportContractEvent, SupportContractState> {
  UserRepository userRepository;
  SupportContractBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitSupportContractState());
  @override
  Stream<SupportContractState> mapEventToState(
      SupportContractEvent event) async* {
    if (event is InitGetSupportContractEvent) {
      yield* _getSupportContract(id: event.id);
    }
  }

  Stream<SupportContractState> _getSupportContract({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingSupportContractState();
      final response = await userRepository.getSupportContract(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessSupportContractState(response.data!);
      } else if (response.code == 999) {
        loginSessionExpired();
      } else
        yield ErrorSupportContractState(response.msg ?? '');
    } catch (e) {
      yield ErrorSupportContractState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static SupportContractBloc of(BuildContext context) =>
      BlocProvider.of<SupportContractBloc>(context);
}
