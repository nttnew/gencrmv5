import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/contract_customer.dart';
import '../../src/models/model_generator/customer.dart';

part 'contract_customer_event.dart';
part 'contract_customer_state.dart';

class ContractCustomerBloc
    extends Bloc<ContractCustomerEvent, ContractCustomerState> {
  final UserRepository userRepository;
  int id = 0;
  List<CustomerData>? listCus;

  ContractCustomerBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetContractCustomer());

  @override
  Stream<ContractCustomerState> mapEventToState(
      ContractCustomerEvent event) async* {
    if (event is InitGetContractCustomerEvent) {
      yield* _getContractCustomer(id: event.id);
    }
  }

  Stream<ContractCustomerState> _getContractCustomer({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.getContractCustomer(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield UpdateGetContractCustomerState(response.data!);
      } else if (response.code == 999) {
        loginSessionExpired();
      } else {
        LoadingApi().popLoading();
        yield ErrorGetContractCustomerState(response.msg ?? '');
      }
    } catch (e) {
      LoadingApi().popLoading();
      loginSessionExpired();
      yield ErrorGetContractCustomerState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static ContractCustomerBloc of(BuildContext context) =>
      BlocProvider.of<ContractCustomerBloc>(context);
}
