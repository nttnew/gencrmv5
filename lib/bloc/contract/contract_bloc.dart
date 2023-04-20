import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/contract.dart';
import '../../src/models/model_generator/customer.dart';

part 'contract_event.dart';
part 'contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final UserRepository userRepository;
  List<ContractItemData>? list;

  ContractBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetContract());

  @override
  Stream<ContractState> mapEventToState(ContractEvent event) async* {
    if (event is InitGetContractEvent) {
      yield* _getListContract(
          filter: event.filter,
          page: event.page,
          search: event.search,
          isLoadMore: event.isLoadMore);
    }
  }

  Stream<ContractState> _getListContract(
      {required String filter,
      required int page,
      required String search,
      bool? isLoadMore = false}) async* {
    LoadingApi().pushLoading();
    if (isLoadMore == false) yield LoadingContractState();
    try {
      final response =
          await userRepository.getListContract(page, search, filter);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (page == 1) {
          list = response.data.list;
          yield UpdateGetContractState(
              response.data.list!, response.data.total!, response.data.filter!);
        } else {
          list = [...list!, ...response.data.list!];
          yield UpdateGetContractState(
              list!, response.data.total!, response.data.filter!);
        }
      } else if (response.code == 999) {
        loginSessionExpired();
      } else
        yield ErrorGetContractState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      loginSessionExpired();
      yield ErrorGetContractState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static ContractBloc of(BuildContext context) =>
      BlocProvider.of<ContractBloc>(context);
}
