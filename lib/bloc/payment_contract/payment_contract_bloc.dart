import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import '../../l10n/key_text.dart';
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
      yield* _getListPaymentContract(
        id: event.id,
        isLoad: event.isLoad ?? true,
      );
    }
  }

  Stream<PaymentContractState> _getListPaymentContract({
    required int id,
    required bool isLoad,
  }) async* {
    if (isLoad) LoadingApi().pushLoading();
    try {
      yield LoadingPaymentContractState();
      final response = await userRepository.getPaymentContract(id);
      if (isSuccess(response.code)) {
        if (response.data?.length == 0) {
          yield SuccessPaymentContractState([]);
        } else {
          yield SuccessPaymentContractState(response.data);
        }
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else
        yield ErrorPaymentContractState(response.msg ?? '');
    } catch (e) {
      yield ErrorPaymentContractState(getT(KeyT.an_error_occurred));
    }
    if (isLoad) LoadingApi().popLoading();
  }

  Future<String> deletePayment({
    required String idContract,
    required String idPayment,
  }) async {
    String mess = getT(KeyT.an_error_occurred);
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.deletePayment(
        idContract: idContract,
        idPayment: idPayment,
      );
      if (isSuccess(response.code)) {
        return '';
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else
        return response.msg ?? '';
    } catch (e) {
      LoadingApi().popLoading();
      return mess;
    }
    LoadingApi().popLoading();
    return mess;
  }

  static PaymentContractBloc of(BuildContext context) =>
      BlocProvider.of<PaymentContractBloc>(context);
}
