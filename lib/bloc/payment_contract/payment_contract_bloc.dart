import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../src/app_const.dart';
import '../../src/base.dart';
import '../../src/models/model_generator/detail_contract.dart';
import '../../widgets/loading_api.dart';

part 'payment_contract_event.dart';
part 'payment_contract_state.dart';

class PaymentContractBloc
    extends Bloc<PaymentContractEvent, PaymentContractState> {
  UserRepository userRepository;
  PaymentContractBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitPaymentContractState());
  @override
  Stream<PaymentContractState> mapEventToState(
      PaymentContractEvent event) async* {
    if (event is InitGetPaymentContractEvent) {
      yield* _getListPaymentContract(id: event.id);
    }
  }

  Stream<PaymentContractState> _getListPaymentContract(
      {required int id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingPaymentContractState();
      final response = await userRepository.getPaymentContract(id);
      if ((response.code == BASE_URL.SUCCESS) ||
          (response.code == BASE_URL.SUCCESS_200)) {
        if (response.data!.length == 0) {
          yield SuccessPaymentContractState([]);
        } else {
          yield SuccessPaymentContractState(response.data![0]!);
        }
      } else if (response.code == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else
        yield ErrorPaymentContractState(response.msg ?? '');
    } catch (e) {
      yield ErrorPaymentContractState(
          AppLocalizations.of(Get.context!)?.an_error_occurred ?? '');
      throw e;
    }
    LoadingApi().popLoading();
  }

  static PaymentContractBloc of(BuildContext context) =>
      BlocProvider.of<PaymentContractBloc>(context);
}
