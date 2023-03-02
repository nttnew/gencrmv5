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


part 'support_contract_event.dart';
part 'support_contract_state.dart';

class SupportContractBloc extends Bloc<SupportContractEvent,SupportContractState>{
  UserRepository userRepository;
  SupportContractBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitSupportContractState());
  @override
  Stream<SupportContractState> mapEventToState(SupportContractEvent event) async*{
    // TODO: implement mapEventToState
    if(event is InitGetSupportContractEvent) {
      yield* _getSupportContract(id: event.id);
    }
  }

  Stream<SupportContractState> _getSupportContract({required int id}) async* {
    LoadingApi().pushLoading();
    try {
      yield LoadingSupportContractState();
      final response = await userRepository.getSupportContract(id);
      if((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)){
        yield SuccessSupportContractState(response.data!);
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
        yield ErrorSupportContractState(response.msg ?? '');
    } catch (e) {
      yield ErrorSupportContractState(MESSAGES.CONNECT_ERROR);
      throw e;
    }
    LoadingApi().popLoading();
  }

  static SupportContractBloc of(BuildContext context) => BlocProvider.of<SupportContractBloc>(context);
}