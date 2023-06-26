import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/widgets/loading_api.dart';
import '../../api_resfull/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';

part 'customer_contract_event.dart';
part 'customer_contract_state.dart';

class CustomerContractBloc
    extends Bloc<CustomerContractEvent, CustomerContractState> {
  final UserRepository userRepository;
  List<List<dynamic>>? list;

  CustomerContractBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitGetContractCustomer());

  @override
  Stream<CustomerContractState> mapEventToState(
      CustomerContractEvent event) async* {
    if (event is InitGetContractCustomerEvent) {
      yield* _getListContractCustomer(
          search: event.querySearch, page: event.page);
    } else if (event is InitGetContactCusEvent) {
      yield* _getListContactCus(id: event.id);
    }
  }

  Stream<CustomerContractState> _getListContractCustomer(
      {required String page, required String search}) async* {
    LoadingApi().pushLoading();
    try {
      if (page == BASE_URL.PAGE_DEFAULT.toString())
        yield LoadingContractCustomerState();
      final response = await userRepository.getCustomerContract(page, search);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (page == BASE_URL.PAGE_DEFAULT.toString()) {
          list = response.data;
          yield SuccessGetContractCustomerState(response.data!);
        } else {
          if (response.data!.length > 0) {
            list = [...list!, ...response.data!];
            yield SuccessGetContractCustomerState(list!);
          }
        }
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorGetContractCustomerState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetContractCustomerState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  Stream<CustomerContractState> _getListContactCus(
      {required String id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingContractCustomerState();
      final response = await userRepository.getContactByCustomer(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        yield SuccessGetContractCustomerState(response.data!);
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorGetContractCustomerState(response.msg ?? '');
    } catch (e) {
      LoadingApi().popLoading();
      yield ErrorGetContractCustomerState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  static CustomerContractBloc of(BuildContext context) =>
      BlocProvider.of<CustomerContractBloc>(context);
}
