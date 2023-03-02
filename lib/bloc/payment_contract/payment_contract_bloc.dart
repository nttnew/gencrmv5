import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:gen_crm/src/models/model_generator/clue_detail.dart';
import 'package:get/get.dart';

import '../../src/base.dart';
import '../../src/color.dart';
import '../../src/messages.dart';
import '../../src/models/model_generator/detail_contract.dart';
import '../../src/models/model_generator/note_clue.dart';
import '../../src/navigator.dart';
import '../../widgets/loading_api.dart';
import '../../widgets/widget_dialog.dart';


part 'payment_contract_event.dart';
part 'payment_contract_state.dart';

class PaymentContractBloc extends Bloc<PaymentContractEvent,PaymentContractState>{
  UserRepository userRepository;
  PaymentContractBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitPaymentContractState());
  @override
  Stream<PaymentContractState> mapEventToState(PaymentContractEvent event) async*{
    // TODO: implement mapEventToState
    if(event is InitGetPaymentContractEvent) {
      yield* _getListPaymentContract(id: event.id);
    }
  }

  Stream<PaymentContractState> _getListPaymentContract({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingPaymentContractState();
      final response = await userRepository.getPaymentContract(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        if(response.data!.length==0){
          yield SuccessPaymentContractState([]);
        }
        else{
          yield SuccessPaymentContractState(response.data![0]!);
        }

      }
      else if(response.code==999){
        Get.dialog(WidgetDialog(
          title: MESSAGES.NOTIFICATION,
          content: "Phiên đăng nhập hết hạn, hãy đăng nhập lại!",
          textButton1: "OK",
          backgroundButton1: COLORS.PRIMARY_COLOR,
          onTap1: () {
            AppNavigator.navigateLogout();
          },
        ));
      }
      else
        yield ErrorPaymentContractState(response.msg ?? '');
    } catch (e) {
      yield ErrorPaymentContractState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static PaymentContractBloc of(BuildContext context) => BlocProvider.of<PaymentContractBloc>(context);
}